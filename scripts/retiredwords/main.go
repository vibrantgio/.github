// retiredwords — classify occurrences of the retired words in one file set.
//
// Invoked by scripts/check-retired-words.sh, which owns the word list, the
// exclusion rules and the report; this program owns one thing the shell
// cannot do correctly — telling a Go identifier from a comment from a string
// literal. It tokenizes .go files with go/scanner rather than matching
// regexes over source, so `Wash` in a comment is never filed as an
// identifier and an identifier inside a raw string is never filed as code.
//
// Input: file paths on stdin, one per line. Output: one TSV hit per line,
//
//	path <TAB> line <TAB> kind <TAB> word <TAB> match <TAB> token <TAB> line text
//
// kind is identifier, comment, string or doc; word is the retired word in
// its canonical lower-case spelling; match is the text that actually matched
// (`Washes`, `Marked`); token is the whole identifier the word sits in
// (`ghostWash`), or the match again for the text kinds; the line text is
// trimmed and truncated, for the reader and for the shell's exclusion rules.
//
// Matching is case-insensitive on word boundaries, with the inflections a
// retired word takes in English prose (s, es, ed, ing, ly) — "washes" and
// "registered" are the same word as "wash" and "register". Identifiers are
// split on underscores and camel-case humps first (`ghostWash` -> ghost,
// Wash; `HTMLCanvas` -> HTML, Canvas), so a compound identifier is a hit on
// its embedded word.
package main

import (
	"bufio"
	"flag"
	"fmt"
	"go/scanner"
	"go/token"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"unicode"
)

func main() {
	words := flag.String("words", "", "comma-separated retired words, lower case")
	flag.Parse()
	if *words == "" {
		fmt.Fprintln(os.Stderr, "retiredwords: -words is required")
		os.Exit(2)
	}
	list := strings.Split(*words, ",")
	// One case-insensitive, word-boundary pattern per word, so that the hit
	// can name which word matched. \b works here because every retired word
	// is pure ASCII letters.
	pats := make([]*regexp.Regexp, len(list))
	for i, w := range list {
		pats[i] = regexp.MustCompile(`(?i)\b` + regexp.QuoteMeta(w) + `(s|es|ed|ing|ly)?\b`)
	}

	out := bufio.NewWriter(os.Stdout)
	defer out.Flush()
	in := bufio.NewScanner(os.Stdin)
	in.Buffer(make([]byte, 0, 1<<20), 1<<20)
	for in.Scan() {
		path := strings.TrimSpace(in.Text())
		if path == "" {
			continue
		}
		src, err := os.ReadFile(path)
		if err != nil {
			fmt.Fprintf(os.Stderr, "retiredwords: %v\n", err)
			os.Exit(1)
		}
		lines := strings.Split(string(src), "\n")
		emit := func(line int, kind, word, match, tok string) {
			text := ""
			if line-1 >= 0 && line-1 < len(lines) {
				text = strings.TrimSpace(strings.ReplaceAll(lines[line-1], "\t", " "))
			}
			// Truncated on runes: a line cut mid-rune is invalid UTF-8, and
			// the shell's awk rejects the byte sequence rather than the line.
			if r := []rune(text); len(r) > 200 {
				text = string(r[:200])
			}
			fmt.Fprintf(out, "%s\t%d\t%s\t%s\t%s\t%s\t%s\n", path, line, kind, word, match, tok, text)
		}
		if filepath.Ext(path) == ".go" {
			scanGo(path, src, list, pats, emit)
			continue
		}
		for n, text := range lines {
			for i, re := range pats {
				for _, m := range re.FindAllString(text, -1) {
					emit(n+1, "doc", list[i], m, m)
				}
			}
		}
	}
	if err := in.Err(); err != nil {
		fmt.Fprintf(os.Stderr, "retiredwords: %v\n", err)
		os.Exit(1)
	}
}

// scanGo files every hit in one Go source file by the kind of token it sits
// in. Scanning errors are ignored: a file that does not tokenize cleanly
// still yields its good tokens, and `go build` is the judge of syntax.
func scanGo(path string, src []byte, list []string, pats []*regexp.Regexp, emit func(int, string, string, string, string)) {
	fset := token.NewFileSet()
	file := fset.AddFile(path, fset.Base(), len(src))
	var s scanner.Scanner
	s.Init(file, src, func(token.Position, string) {}, scanner.ScanComments)
	for {
		pos, tok, lit := s.Scan()
		if tok == token.EOF {
			break
		}
		line := fset.Position(pos).Line
		switch tok {
		case token.IDENT:
			for _, part := range splitIdent(lit) {
				for i, re := range pats {
					if m := re.FindString(part); m != "" {
						emit(line, "identifier", list[i], m, lit)
					}
				}
			}
		case token.COMMENT:
			// A comment spans lines; report the line the word is on, not the
			// line the comment opened on.
			for n, text := range strings.Split(lit, "\n") {
				for i, re := range pats {
					for _, m := range re.FindAllString(text, -1) {
						emit(line+n, "comment", list[i], m, m)
					}
				}
			}
		case token.STRING, token.CHAR:
			for n, text := range strings.Split(lit, "\n") {
				for i, re := range pats {
					for _, m := range re.FindAllString(text, -1) {
						emit(line+n, "string", list[i], m, m)
					}
				}
			}
		}
	}
}

// splitIdent cuts an identifier into the words it is built from: on
// underscores, on a lower-to-upper hump (ghostWash -> ghost, Wash), before
// the last capital of a run that starts a word (HTMLCanvas -> HTML, Canvas),
// and between letters and digits (Level2 -> Level, 2).
func splitIdent(id string) []string {
	var parts []string
	var cur []rune
	flush := func() {
		if len(cur) > 0 {
			parts = append(parts, string(cur))
			cur = nil
		}
	}
	rs := []rune(id)
	for i, r := range rs {
		switch {
		case r == '_':
			flush()
			continue
		case i > 0 && unicode.IsUpper(r) && !unicode.IsUpper(rs[i-1]):
			flush()
		case i > 0 && unicode.IsUpper(r) && unicode.IsUpper(rs[i-1]) &&
			i+1 < len(rs) && unicode.IsLower(rs[i+1]):
			flush()
		case i > 0 && unicode.IsDigit(r) != unicode.IsDigit(rs[i-1]):
			flush()
		}
		cur = append(cur, r)
	}
	flush()
	return parts
}
