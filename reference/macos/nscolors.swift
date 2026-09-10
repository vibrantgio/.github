import AppKit
let names: [(String, NSColor)] = [
 ("windowBackgroundColor", .windowBackgroundColor), ("underPageBackgroundColor", .underPageBackgroundColor),
 ("controlBackgroundColor", .controlBackgroundColor), ("textBackgroundColor", .textBackgroundColor),
 ("selectedContentBackgroundColor", .selectedContentBackgroundColor), ("unemphasizedSelectedContentBackgroundColor", .unemphasizedSelectedContentBackgroundColor),
 ("selectedTextBackgroundColor", .selectedTextBackgroundColor), ("unemphasizedSelectedTextBackgroundColor", .unemphasizedSelectedTextBackgroundColor),
 ("findHighlightColor", .findHighlightColor), ("separatorColor", .separatorColor), ("gridColor", .gridColor),
 ("labelColor", .labelColor), ("secondaryLabelColor", .secondaryLabelColor), ("tertiaryLabelColor", .tertiaryLabelColor), ("quaternaryLabelColor", .quaternaryLabelColor),
 ("textColor", .textColor), ("placeholderTextColor", .placeholderTextColor), ("selectedTextColor", .selectedTextColor), ("linkColor", .linkColor), ("headerTextColor", .headerTextColor),
 ("controlColor", .controlColor), ("controlTextColor", .controlTextColor), ("disabledControlTextColor", .disabledControlTextColor),
 ("selectedControlColor", .selectedControlColor), ("selectedControlTextColor", .selectedControlTextColor), ("alternateSelectedControlTextColor", .alternateSelectedControlTextColor),
 ("controlAccentColor", .controlAccentColor), ("keyboardFocusIndicatorColor", .keyboardFocusIndicatorColor),
 ("systemRed", .systemRed), ("systemOrange", .systemOrange), ("systemYellow", .systemYellow), ("systemGreen", .systemGreen), ("systemMint", .systemMint), ("systemTeal", .systemTeal), ("systemCyan", .systemCyan), ("systemBlue", .systemBlue), ("systemIndigo", .systemIndigo), ("systemPurple", .systemPurple), ("systemPink", .systemPink), ("systemBrown", .systemBrown), ("systemGray", .systemGray),
 ("shadowColor", .shadowColor), ("highlightColor", .highlightColor), 
]
func hex(_ c: NSColor) -> String {
  guard let s = c.usingColorSpace(.sRGB) else { return "?" }
  let r = Int((s.redComponent*255).rounded()), g = Int((s.greenComponent*255).rounded()), b = Int((s.blueComponent*255).rounded())
  let a = s.alphaComponent
  return String(format: "#%02x%02x%02x", r, g, b) + (a < 0.999 ? String(format: " a%.2f", a) : "")
}
for (name, c) in names {
  var l = "", d = ""
  NSAppearance(named: .aqua)!.performAsCurrentDrawingAppearance { l = hex(c) }
  NSAppearance(named: .darkAqua)!.performAsCurrentDrawingAppearance { d = hex(c) }
  print("\(name)\t\(l)\t\(d)")
}
