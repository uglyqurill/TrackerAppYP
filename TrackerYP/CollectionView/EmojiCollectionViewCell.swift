import UIKit

class EmojiCollectionViewCell: UICollectionViewCell {
    let titleLabel = UILabel()
    var selectionView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 34)
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        
        selectionView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        selectionView.backgroundColor = UIColor(named: "ypLightGrey")
        selectionView.layer.cornerRadius = 10
        selectionView.layer.zPosition = -1
        selectionView.isHidden = true
        
        titleLabel.addSubview(selectionView)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectionView.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            selectionView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
    
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
