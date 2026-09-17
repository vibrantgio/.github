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
