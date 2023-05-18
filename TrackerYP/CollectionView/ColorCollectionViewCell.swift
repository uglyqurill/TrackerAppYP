import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    let colorButton = UIButton()
    var selectionView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        colorButton.layer.cornerRadius = 8
        colorButton.clipsToBounds = true
        colorButton.backgroundColor = .blue
        
        contentView.addSubview(colorButton)
        colorButton.translatesAutoresizingMaskIntoConstraints = false
        
        selectionView = UIView(frame: CGRect(x: 0, y: 0, width: 46, height: 46))
        selectionView.backgroundColor = .clear
        selectionView.layer.borderWidth = 3.0
        selectionView.layer.borderColor = UIColor(named: "ypGrey")?.cgColor
        selectionView.layer.cornerRadius = 8
        selectionView.isHidden = false
        
        contentView.addSubview(selectionView)
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorButton.heightAnchor.constraint(equalToConstant: 40),
            colorButton.widthAnchor.constraint(equalToConstant: 40),
            selectionView.centerXAnchor.constraint(equalTo: colorButton.centerXAnchor),
            selectionView.centerYAnchor.constraint(equalTo: colorButton.centerYAnchor),
            selectionView.widthAnchor.constraint(equalTo: colorButton.widthAnchor, constant: 8),
            selectionView.heightAnchor.constraint(equalTo: colorButton.heightAnchor, constant: 8)
        ])
    }
    
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
