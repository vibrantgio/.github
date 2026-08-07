**`transition` is the odd package out, and it is the control.** Its swatches
are drawn on the CPU with `image/draw` — colour interpolation, no widget
rendering — so it calls `golden.CompareNRGBA` on an image it built itself
rather than `golden.Render`, and needs no headless window at all. That is
what made this repository the one F5.7 ran its experiment on: with the GL
drivers installed on the runner, nine of the twenty-one stored images differed
under Linux mesa while these three still matched exactly, which is how the
harness, the PNG encoding and the comparison were cleared and the GPU
rasteriser was not.

F5.5 deleted the four inlined harnesses that used to live here, one per
package.
