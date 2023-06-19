import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    let dayLabel = UILabel()
    let daySwitch = UISwitch(frame: CGRect(x: 0, y: 0, width: 51, height: 31))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Set up the label
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dayLabel)
        dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        // Set up the switch
        daySwitch.translatesAutoresizingMaskIntoConstraints = false
        daySwitch.onTintColor = UIColor(named: "ypBlue")
        contentView.addSubview(daySwitch)
        daySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        daySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
