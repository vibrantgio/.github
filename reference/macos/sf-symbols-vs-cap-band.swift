// Offscreen measurement of macOS system marks against their label's cap band.
//
// Nothing is displayed: no NSWindow is created and no application is launched.
// Text and SF Symbols are drawn into an 8x supersampled CoreGraphics bitmap and
// the ink is measured out of the pixels.
//
// Build and run:  swiftc -O marks.swift -o marks && ./marks

import AppKit

let SCALE: CGFloat = 8.0
let W = 200.0, H = 60.0
let ORIGIN = CGPoint(x: 10, y: 20)

func render(_ a: NSAttributedString) -> (m: [[Bool]], w: Int, h: Int) {
    let w = Int(W * SCALE), h = Int(H * SCALE)
    let ctx = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w * 4,
                        space: CGColorSpaceCreateDeviceRGB(),
                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    ctx.setFillColor(red: 1, green: 1, blue: 1, alpha: 1)
    ctx.fill(CGRect(x: 0, y: 0, width: w, height: h))
    ctx.scaleBy(x: SCALE, y: SCALE)
    let prev = NSGraphicsContext.current
    NSGraphicsContext.current = NSGraphicsContext(cgContext: ctx, flipped: false)
    a.draw(at: NSPoint(x: ORIGIN.x, y: ORIGIN.y))
    NSGraphicsContext.current = prev
    let d = ctx.data!.bindMemory(to: UInt8.self, capacity: w * h * 4)
    var m = [[Bool]](repeating: [Bool](repeating: false, count: w), count: h)
    for y in 0..<h { for x in 0..<w {
        let i = (y * w + x) * 4
        let lum = 0.2126 * Double(d[i]) + 0.7152 * Double(d[i+1]) + 0.0722 * Double(d[i+2])
        m[y][x] = lum < 200
    } }
    return (m, w, h)
}

struct Box { var top = 0, bot = 0, left = 0, right = 0 }

func groups(_ r: (m: [[Bool]], w: Int, h: Int), gap: Int) -> [Box] {
    var colHas = [Bool](repeating: false, count: r.w)
    for x in 0..<r.w { for y in 0..<r.h where r.m[y][x] { colHas[x] = true; break } }
    var out: [Box] = []
    var x = 0
    while x < r.w {
        if colHas[x] {
            var end = x, run = 0, probe = x
            while probe < r.w {
                if colHas[probe] { end = probe; run = 0 } else { run += 1; if run > gap { break } }
                probe += 1
            }
            var top = Int.max, bot = -1
            for yy in 0..<r.h { for xx in x...end where r.m[yy][xx] { top = min(top, yy); bot = max(bot, yy) } }
            out.append(Box(top: top, bot: bot, left: x, right: end))
            x = end + 1
        } else { x += 1 }
    }
    return out
}

var lines: [String] = []
func p(_ s: String) { print(s); lines.append(s) }

p("macOS \(ProcessInfo.processInfo.operatingSystemVersionString)")
p("SF Pro (NSFont.systemFont), SF Symbols at a matched point size, regular weight unless noted.")
p("All values in points, measured from an 8x supersampled offscreen bitmap.")
p("")

for pt in [11.0, 13.0, 15.0] as [CGFloat] {
    let font = NSFont.systemFont(ofSize: pt)
    let attrs: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: NSColor.black]

    // The label's own band and stem, from the same pipeline the symbols go through.
    var capTopRow = 0, capBotRow = 0, stem: CGFloat = 0, capH: CGFloat = 0
    do {
        let r = render(NSAttributedString(string: "HI", attributes: attrs))
        let g = groups(r, gap: Int(SCALE))
        let b = g[0]
        capTopRow = b.top; capBotRow = b.bot
        capH = CGFloat(b.bot - b.top + 1) / SCALE
        // the 'I' is the trailing stem of the pair; measure its own ink width
        let gi = groups(r, gap: Int(SCALE * 0.2))
        stem = CGFloat(gi.last!.right - gi.last!.left + 1) / SCALE
    }
    p(String(format: "=== %.0f pt: declared capHeight %.3f, measured cap ink %.3f, stem ink %.3f ===",
             pt, font.capHeight, capH, stem))

    for name in ["plus", "checkmark", "xmark", "magnifyingglass"] {
        guard let base = NSImage(systemSymbolName: name, accessibilityDescription: nil),
              let sym = base.withSymbolConfiguration(.init(pointSize: pt, weight: .regular)) else { continue }
        let att = NSTextAttachment()
        att.image = sym
        let s = NSMutableAttributedString(string: "H ", attributes: attrs)
        s.append(NSAttributedString(attachment: att))
        s.addAttribute(.foregroundColor, value: NSColor.black, range: NSRange(location: 0, length: s.length))
        let r = render(s)
        let g = groups(r, gap: Int(SCALE * 0.75))
        guard g.count >= 2 else { continue }
        let cap = g[0], sym1 = g[1]
        let above = CGFloat(cap.top - sym1.top) / SCALE
        let below = CGFloat(sym1.bot - cap.bot) / SCALE
        let h = CGFloat(sym1.bot - sym1.top + 1) / SCALE
        let capMeasured = CGFloat(cap.bot - cap.top + 1) / SCALE
        var runs: [Int] = []
        for y in sym1.top...sym1.bot {
            var run = 0
            for x in sym1.left...sym1.right {
                if r.m[y][x] { run += 1 } else { if run > 0 { runs.append(run) }; run = 0 }
            }
            if run > 0 { runs.append(run) }
        }
        var hist: [Int: Int] = [:]; for v in runs { hist[v, default: 0] += 1 }
        let modal = CGFloat(hist.max { $0.value < $1.value }?.key ?? 0) / SCALE
        // A diagonal's horizontal run is its band divided by the cosine of its
        // angle; the two marks below run at 45 degrees, the plus is axis-aligned.
        let band = (name == "xmark" || name == "checkmark") ? modal * cos(.pi / 4) : modal
        p(String(format: "  %-16@ ink %.3f (%.3f x cap), %+.3f above the cap line, %+.3f below the baseline, run %.3f, band %.3f (%.3f x stem)",
                 name as NSString, h, h / capMeasured, above, below, modal, band, band / stem))
    }
    _ = capTopRow; _ = capBotRow
    p("")
}

try? lines.joined(separator: "\n").write(toFile: CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "/dev/null",
                                         atomically: true, encoding: .utf8)
