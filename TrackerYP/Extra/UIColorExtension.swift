import UIKit.UIColor

// MARK: Дополнение к UIColor, которое позволяет изменять цвет с помощью HEX номера
extension UIColor {
    
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        let length = hexSanitized.count
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

extension UIColor {
    
    static var backgroundColor: UIColor { UIColor(named: "ypBackgroundDay") ?? UIColor.red }
    static var findColor: UIColor { UIColor(named: "ypLightGrey") ?? UIColor.gray }
    static var ypGray: UIColor { UIColor(named: "ypGray") ?? UIColor.gray }
    static var ypRed: UIColor { UIColor(named: "ypRed") ?? UIColor.red }
    static var ypBlack: UIColor { UIColor(named: "ypBlack") ?? UIColor.black }
    static var lightGray: UIColor { UIColor(named: "ypLightGrey") ?? UIColor.gray }
    static var ypBlue: UIColor { UIColor(named: "ypBlue") ?? UIColor.blue }
    static var color1: UIColor { UIColor(named: "Color1") ?? UIColor.red }
    static var color2: UIColor { UIColor(named: "Color2") ?? UIColor.red }
    static var color3: UIColor { UIColor(named: "Color3") ?? UIColor.red }
    static var color4: UIColor { UIColor(named: "Color4") ?? UIColor.red }
    static var color5: UIColor { UIColor(named: "Color5") ?? UIColor.red }
    static var color6: UIColor { UIColor(named: "Color6") ?? UIColor.red }
    static var color7: UIColor { UIColor(named: "Color7") ?? UIColor.red }
    static var color8: UIColor { UIColor(named: "Color8") ?? UIColor.red }
    static var color9: UIColor { UIColor(named: "Color9") ?? UIColor.red }
    static var color10: UIColor { UIColor(named: "Color10") ?? UIColor.red }
    static var color11: UIColor { UIColor(named: "Color11") ?? UIColor.red }
    static var color12: UIColor { UIColor(named: "Color12") ?? UIColor.red }
    static var color13: UIColor { UIColor(named: "Color13") ?? UIColor.red }
    static var color14: UIColor { UIColor(named: "Color14") ?? UIColor.red }
    static var color15: UIColor { UIColor(named: "Color15") ?? UIColor.red }
    static var color16: UIColor { UIColor(named: "Color16") ?? UIColor.red }
    static var color17: UIColor { UIColor(named: "Color17") ?? UIColor.red }
    static var color18: UIColor { UIColor(named: "Color18") ?? UIColor.red }
    static var switchColor: UIColor { ypBlue }
    
    var hexString: String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        return String.init(
            format: "%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
    }
}
