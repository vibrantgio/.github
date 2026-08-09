**Coordination in this repository is ADR-008's, and none of it is a bus.**
Four packages here used to export an `rx.Observable` that widgets published
to — `popover.Arbitration`, `tooltip.Arbitration`, `modal.Stack` and
`toast.Notifications`. Three of the four had no subscriber anywhere in the
organization; all four are gone, along with their snapshot types. What
replaced them:

- **`popover`, `tooltip` and `modal` arbitrate through a plain value.**
  `NewArbiter()` returns one, `Props.Arbiter` takes it, and the value *is* the
  scope — widgets sharing an arbiter arbitrate with one another and with
  nobody else, which makes one per window the right grain. There is no
  package-level default: a nil `Arbiter` means *arbitrate alone*, so two
  popovers that both leave it nil stay open together. No mutex and no atomics,
  because one Gio frame runs on one goroutine, and the doc comment on each
  arbiter says so — that sentence is the invariant.
- **A claim must be an edge, and a level must be latched.** The claim happens
  on the first frame a widget is drawn open, and it dismisses the incumbent
  from inside the claimant's own layout pass. Under the old per-frame poll a
  level-guarded claim was survivable; under the direct write two participants
  trade the top every frame. `tooltip`'s dwell is the case that found this.
- **`toast` is the one that went to the model.** `toast.Requested` and
  `toast.Expired` are messages, `toast.Queue` is the state they reduce onto,
  `toast.Expire(id, lifetime)` is the timer command, and `Props.Toasts` is how
  the stack reads them. `Notify` kept its name and broke its signature — it
  needs a `layout.Context` to reach `mvu.MessageOp`, and there is no shim that
  both compiles and works, so it fails loudly at every call site instead.
  A `Stack` handed no toasts renders an empty column forever and nothing
  fails at build time; `TestStackWithNoToastsRendersEmpty` pins that.

`scripts/check-subjects.sh` in `vibrantgio/.github` is the gate. It will not
catch the thing that actually went wrong here — an exported observable with no
reader looks exactly like a working one — so when you export an observable
from this repository, go and find its subscribers first.

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
