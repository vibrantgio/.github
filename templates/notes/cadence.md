**Never let a golden helper close over the parent test's `*testing.T`.** Pass
the subtest's own `t` down as a parameter. This is not style: it is why this
repository was red on all sixteen CI runs between B3.5 and F5.7 while green on
every developer machine, and the failure is invisible in both directions until
you know it.

`sidebar`'s active-tint test built its `render` closure in the parent test's
scope and then called it from inside two `t.Run` subtests, where an inner `t`
shadows the outer name at every call site but not inside the closure. Locally
that never matters, because `headless.NewWindow` succeeds and the harness
never reaches its skip path. On a runner it does: `golden.Capture` answers
with `t.Skipf`, `t.Skipf` is `runtime.Goexit`, and a Goexit taken on the
parent's `t` from the subtest's goroutine unwinds the subtest without
finishing it. The testing package reports that as

    test executed panic(nil) or runtime.Goexit:
    subtest may have called FailNow on a parent test

which is a failure, not a skip — so the repository failed for exactly the
reason its images were never compared.

F5.5 deleted the eighteen inlined harnesses that used to live here, one per
component package.
