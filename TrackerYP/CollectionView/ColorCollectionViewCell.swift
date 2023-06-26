import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    let colorButton = UIView()
    var selectionView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        colorButton.layer.cornerRadius = 8
        colorButton.clipsToBounds = true
        colorButton.backgroundColor = .blue
        
        contentView.addSubview(colorButton)
        colorButton.translatesAutoresizingMaskIntoConstraints = false
        
        selectionView = UIView(frame: CGRect(x: 0, y: 0, width: 52, height: 52))
        selectionView.layer.borderWidth = 3.0
        selectionView.layer.borderColor = UIColor(named: "ypGrey")?.cgColor
        selectionView.layer.cornerRadius = 8
        selectionView.isHidden = true
        
        contentView.addSubview(selectionView)
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorButton.heightAnchor.constraint(equalToConstant: 40),
            colorButton.widthAnchor.constraint(equalToConstant: 40),
            selectionView.centerXAnchor.constraint(equalTo: colorButton.centerXAnchor),
            selectionView.centerYAnchor.constraint(equalTo: colorButton.centerYAnchor),
            selectionView.widthAnchor.constraint(equalToConstant: 52),
            selectionView.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


