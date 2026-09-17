package main

import (
	"regexp"
	"strings"
	"testing"
)

// These pin the fix for the wrapped-line defect: a `ctx` exclusion used to
// test its regex against the path and the matched line alone, so prose that
// wrapped between a retired word and its kept-sense context tripped the
// guard. ctxWindow now supplies the line before and the line after too, and
// these tests exercise it the way check-retired-words.sh's awk does: lower
// the window and match a rule's regex against it.

func matchesWindow(t *testing.T, lines []string, line int, rule string) bool {
	t.Helper()
	re := regexp.MustCompile(rule)
	return re.MatchString(strings.ToLower(ctxWindow(lines, line)))
}

func TestCtxWindow_KeptSenseContextOnNextLine(t *testing.T) {
	// "material" is retired as the design system, but a macOS material
	// measured against a platform application keeps its sense — the
	// context here ("Voice Memos") lands on the line after the match.
	lines := []string{
		"the sidebar reads the platform's own material,",
		"measured beside Voice Memos in both appearances.",
	}
	if !matchesWindow(t, lines, 1, `voice memos`) {
		t.Fatal("kept sense with its context on the next line was not excluded")
	}
}

func TestCtxWindow_KeptSenseContextOnPreviousLine(t *testing.T) {
	// "register" as what a handler does keeps its sense; here the word
	// "handler" lands on the line before the match.
	lines := []string{
		"the pointer event handler",
		"is registered once, at construction.",
	}
	if !matchesWindow(t, lines, 2, `handler|listener|callback`) {
		t.Fatal("kept sense with its context on the previous line was not excluded")
	}
}

func TestCtxWindow_RetiredSenseWithNoNearbyContextIsCaught(t *testing.T) {
	// No handler, listener, callback or any other kept-sense word appears
	// in the three-line window, so the retired sense is still a caught
	// line.
	lines := []string{
		"the first paragraph of the doc.",
		"this line still says register here.",
		"a third, unrelated paragraph.",
	}
	if matchesWindow(t, lines, 2, `handler|listener|callback|registry`) {
		t.Fatal("retired sense with no context in the window was wrongly excluded")
	}
}

func TestCtxWindow_ContextFourLinesAwayIsNotFound(t *testing.T) {
	// "handler" sits four lines from the match — outside the three-line
	// window — so it must not rescue the caught line.
	lines := []string{
		"the event handler is set up first.",
		"a gap line.",
		"another gap line.",
		"this line still says register here.",
		"a trailing gap line.",
	}
	if matchesWindow(t, lines, 4, `handler`) {
		t.Fatal("context four lines away was found; the window has widened too far")
	}
}

func TestCtxWindow_FileEdges(t *testing.T) {
	// The first line has no line before it; the last line has no line
	// after it. The window is shorter there, not padded or wrapped.
	lines := []string{"first line of the file", "second and last line"}

	if got, want := ctxWindow(lines, 1), "first line of the file second and last line"; got != want {
		t.Fatalf("window at the first line = %q, want %q", got, want)
	}
	if got, want := ctxWindow(lines, 2), "first line of the file second and last line"; got != want {
		t.Fatalf("window at the last line = %q, want %q", got, want)
	}
}

func TestCtxWindow_SingleLineFile(t *testing.T) {
	lines := []string{"the only line"}
	if got, want := ctxWindow(lines, 1), "the only line"; got != want {
		t.Fatalf("window in a single-line file = %q, want %q", got, want)
	}
}

// These pin CG4.17's fix: the inflection list gains "able", "ible" and the
// "un-" prefix, so "reachable" and its kin are matched as the retired word
// "reach" and not read as some other word entirely.

func TestBuildPattern_ReachableCaught(t *testing.T) {
	re := buildPattern("reach")
	if !re.MatchString("reachable") {
		t.Fatal(`"reachable" was not matched as an inflection of "reach"`)
	}
}

func TestBuildPattern_UnreachableCaught(t *testing.T) {
	re := buildPattern("reach")
	if !re.MatchString("unreachable") {
		t.Fatal(`"unreachable" was not matched as an inflection of "reach"`)
	}
}

func TestBuildPattern_UnreachedCaught(t *testing.T) {
	re := buildPattern("reach")
	if !re.MatchString("unreached") {
		t.Fatal(`"unreached" was not matched as an inflection of "reach"`)
	}
}

func TestBuildPattern_KeptSenseExcludedInAbleForm(t *testing.T) {
	// "author" is retired for who built the application; who wrote the
	// content keeps the word, and check-retired-words.sh's ctx rule keeps
	// it whenever a content word ("post", among others) sits in the
	// three-line window. The -able form is still matched as the word
	// "author", and the kept-sense rule must still exclude it once its ctx
	// carries the kept sense.
	re := buildPattern("author")
	if !re.MatchString("authorable") {
		t.Fatal(`"authorable" was not matched as an inflection of "author"`)
	}
	lines := []string{"the CMS makes every post authorable by its writer."}
	rule := `wrote|writes|written|article|testimonial|front ?matter|commit|content|document|feed|post|avatar|name|role|drew|drawn|authored|icon|glyph|path`
	if !matchesWindow(t, lines, 1, rule) {
		t.Fatal("kept sense in the -able form was not excluded by the ctx rule")
	}
}

func TestBuildPattern_UnrelatedAbleWordNotCaught(t *testing.T) {
	re := buildPattern("reach")
	for _, word := range []string{"table", "stable"} {
		if re.MatchString(word) {
			t.Fatalf("%q was wrongly matched as an inflection of %q", word, "reach")
		}
	}
}

// These pin CG4.17's ruling on the guard side: check-retired-words.sh's
// reach::*::ctx kept-sense rule keeps the computer-science senses of
// "reachable"/"unreachable" (dead code, memory and garbage-collector
// reachability, package/import-graph reachability) as ordinary English,
// while the genuine "operating a control" sense stays caught for reword.
// The regex is the rule's own, mirrored here so a change to one without
// the other fails a test rather than silently drifting.

const reachKeptSenseRule = `panic\(|unreachable"\)|garbage|collect|retain|memory|import|package|graph|dead code|not reachable by|reachable from the root|lint|promotion|unreachable offset|struct|rather than from|chroma|registry|evict|handle|goroutine|unreachable here|unreachable code|device`

func TestCtxWindow_DeadCodePanicExcludedFromReach(t *testing.T) {
	lines := []string{
		"\tdefault:",
		"\t\tpanic(\"unreachable\")",
		"\t}",
	}
	if !matchesWindow(t, lines, 2, reachKeptSenseRule) {
		t.Fatal(`panic("unreachable") was not excluded by the dead-code kept-sense rule`)
	}
}

func TestCtxWindow_ReachableFromKeyboardStaysCaught(t *testing.T) {
	lines := []string{
		"// LayoutSelectable lays out items exactly like [Layout] and additionally makes",
		"// the whole list reachable from the keyboard. rowFn is told whether the row it",
		"// is drawing is the selected one, so the caller renders selection its own way;",
	}
	if matchesWindow(t, lines, 2, reachKeptSenseRule) {
		t.Fatal(`"reachable from the keyboard" was wrongly excluded by the dead-code kept-sense rule`)
	}
}
