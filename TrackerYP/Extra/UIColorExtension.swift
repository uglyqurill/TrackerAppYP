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
    static var ypBlack: UIColor { UIColor(named: "ypBlackDay") ?? UIColor.black }
    static var lightGray: UIColor { UIColor(named: "ypLightGrey") ?? UIColor.gray }
    static var ypBlue: UIColor { UIColor(named: "ypBlue") ?? UIColor.blue }
    static var ypDatePickerColor: UIColor { UIColor(named: "ypDatePickerColor") ?? UIColor.gray }
    
    static var ypWhiteBlack: UIColor { UIColor(named: "ypWhiteBlack") ?? UIColor.white }
    static var ypBlackWhite: UIColor { UIColor(named: "ypBlackWhite") ?? UIColor.black }
    
    
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
