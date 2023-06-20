import UIKit

extension UIView {
        func addGradientBorder(colors: [UIColor], width: CGFloat, cornerRadius: CGFloat) {
            let gradient = CAGradientLayer()
            gradient.frame =  CGRect(origin: .zero, size: self.bounds.size)
            gradient.colors = colors.map { $0.cgColor }
            
            let mask = CAShapeLayer()
            mask.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            mask.fillColor = UIColor.clear.cgColor
            mask.strokeColor = UIColor.white.cgColor
            mask.lineWidth = width
            
            gradient.mask = mask
            
            layer.addSublayer(gradient)
        }
}
