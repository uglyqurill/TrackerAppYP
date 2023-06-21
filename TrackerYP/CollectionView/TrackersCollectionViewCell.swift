import UIKit

protocol TrackersCollectionViewCellDelegate: AnyObject {
    func completedTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(id: UUID, at indexPath: IndexPath)
}

final class TrackersCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "trackersCollectionViewCell"

    public weak var delegate: TrackersCollectionViewCellDelegate?
    private var isCompletedToday: Bool = false
    private var trackerId: UUID? = nil
    private var indexPath: IndexPath?
    private let limitNumberOfCharacters = 38
    public var menuView: UIView {
        return trackerView
    }
    
    private let doneImage = UIImage(named: "DoneButton")
    private let plusImage = UIImage(systemName: "plus")
    
    private lazy var trackerView: UIView = {
        let trackerView = UIView()
        trackerView.layer.cornerRadius = 16
        trackerView.translatesAutoresizingMaskIntoConstraints = false
        return trackerView
    }()
    
    private lazy var emojiView: UIView = {
        let emojiView = UIView()
        emojiView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        emojiView.layer.cornerRadius = 12
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        return emojiView
    }()
    
    private lazy var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        return emojiLabel
    }()
    
    private lazy var trackerNameLabel: UILabel = {
        let trackerNameLabel = UILabel()
        trackerNameLabel.font = .systemFont(ofSize: 14)
        trackerNameLabel.numberOfLines = 0
        trackerNameLabel.text = "Название трекера "
        trackerNameLabel.textColor = .white
        trackerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return trackerNameLabel
    }()
    
    private lazy var resultLabel: UILabel = {
        let resultLabel = UILabel()
        resultLabel.text = "0 дней"
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        return resultLabel
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton(type: .system)
        let pointSize = UIImage.SymbolConfiguration(pointSize: 11)
        let image = isCompletedToday ? doneImage : plusImage
        button.tintColor = .ypWhiteBlack
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 34/2
        button.addTarget(self, action: #selector(trackButtonTapped), for:
                .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tracker: Tracker,
                   isCompletedToday: Bool,
                   indexPath: IndexPath,
                   completedDays: Int) {
        self.isCompletedToday = isCompletedToday
        setIsCompletedToday(isCompletedToday) // Add this line to update the completed image
        self.trackerId = tracker.id
        self.indexPath = indexPath
        let dayCount = dayText(day: completedDays)
        resultLabel.text = dayCount
        addElements()
    }

    func addElements() {
        contentView.addSubview(trackerView)
        trackerView.addSubview(emojiView)
        emojiView.addSubview(emojiLabel)
        trackerView.addSubview(trackerNameLabel)
        contentView.addSubview(resultLabel)
        contentView.addSubview(checkButton)
        
       
        NSLayoutConstraint.activate([
            
            trackerView.heightAnchor.constraint(equalToConstant: 90),
            trackerView.widthAnchor.constraint(equalToConstant: 167),
            trackerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            emojiView.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor) ,
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),

            trackerNameLabel.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 44),
            trackerNameLabel.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -12),
            trackerNameLabel.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            trackerNameLabel.heightAnchor.constraint(equalToConstant: 34),
            
            checkButton.topAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: 8),
            checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            checkButton.heightAnchor.constraint(equalToConstant: 34),
            checkButton.widthAnchor.constraint(equalToConstant: 34 ),
            
            resultLabel.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor),
            resultLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
            
        ])
    }
    
    func setTrackerId(_ id: UUID) {
        trackerId = id
    }
    
    func setTrackerName(_ name: String) {
        trackerNameLabel.text = name
    }
    
    func setTrackerColor(_ color: UIColor) {
        trackerView.backgroundColor = color
    }
    
    func setTrackerEmoji(_ emoji: String) {
        emojiLabel.text = emoji
    }
    
    func setTrackerCheckButtonColor(_ color: UIColor) {
        checkButton.backgroundColor = color
    }
    
    func setIsCompletedToday(_ completed: Bool) {
        isCompletedToday = completed
        checkButton.setImage(isCompletedToday ? doneImage : plusImage, for: .normal)
    }
    
    func setCheckButtonIsEnabled(_ isEnabled: Bool) {
        checkButton.isEnabled = isEnabled
    }
    
    func dayText(day: Int) -> String {
        
        let tasksRemaining = day // Для простоты примера используем числовой литерал
        let resultText = String.localizedStringWithFormat(
            NSLocalizedString("daysОfRepetitions", comment: "Number of repetition days"),
            tasksRemaining
        )
        
        return resultText
    }

    @objc private func trackButtonTapped() {
        guard let trackerId = trackerId, let indexPath = indexPath else {
            assertionFailure("no trackerID")
            return
        }
        
        if isCompletedToday {
            delegate?.uncompleteTracker(id: trackerId, at: indexPath)
        } else {
            delegate?.completedTracker(id: trackerId, at: indexPath)
        }
    }
    
}
