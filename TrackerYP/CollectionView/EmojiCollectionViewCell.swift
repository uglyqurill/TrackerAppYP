import UIKit

class EmojiCollectionViewCell: UICollectionViewCell {
    let titleLabel = UILabel()
    var selectionView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 34)
        titleLabel.textAlignment = .center
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        //selectionView = UIView(frame: CGRect(x: 0, y: 0, width: 52, height: 52))
        selectionView = UIView(frame: CGRect(x: 0, y: 0, width: 52, height: 52))
        selectionView.backgroundColor = UIColor(named: "ypLightGrey")
        selectionView.layer.cornerRadius = 16
        selectionView.clipsToBounds = true
        selectionView.layer.zPosition = -1
        selectionView.isHidden = true
        
        contentView.addSubview(selectionView)
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 38),
            titleLabel.widthAnchor.constraint(equalToConstant: 34),
            selectionView.heightAnchor.constraint(equalToConstant: 52),
            selectionView.widthAnchor.constraint(equalToConstant: 52),
            selectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectionView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
        ])
    }
    
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
