import UIKit

final class StatisticViewController: UIViewController {
    private lazy var viewLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Cтатистика"
        textLabel.tintColor = .black
        textLabel.font = UIFont(name: "HelveticaNeue", size: 34)
        textLabel.font = UIFont.boldSystemFont(ofSize: 34)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    private lazy var emptyLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Анализировать пока нечего"
        textLabel.tintColor = .black
        textLabel.font = UIFont(name: "HelveticaNeue", size: 12)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    private lazy var emojiImageView: UIImageView = {
        let emojiView = UIImageView()
        let emojiImage = UIImage(named: "SadEmoji")
        emojiView.image = emojiImage
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        return emojiView
    }()
    
    private lazy var gradientView: UIView = {
        let color1 = UIColor(named: "gradientBlue") ?? .blue
        let color2 = UIColor(named: "gradientGreen") ?? .green
        let color3 = UIColor(named: "gradientRed") ?? .red

        let gradientView = UIView(frame: CGRect(x: 0, y: 0, width: 343, height: 90))
        gradientView.backgroundColor = UIColor.clear
        gradientView.addGradientBorder(colors: [color1, color2, color3], width: 1, cornerRadius: 16)
        gradientView.layer.cornerRadius = 16
        gradientView.layer.masksToBounds = true

        gradientView.translatesAutoresizingMaskIntoConstraints = false
        return gradientView
    }()
    
    private lazy var countLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.tintColor = .black
        textLabel.font = UIFont(name: "HelveticaNeue", size: 34)
        textLabel.font = UIFont.boldSystemFont(ofSize: 34)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    private lazy var statNameLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Трекеров завершено"
        textLabel.tintColor = .black
        textLabel.font = UIFont(name: "HelveticaNeue", size: 12)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    var trackerRecordStore = TrackerRecordStore()
    var completedTrackers: [TrackerRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteBlack
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        completedTrackers = trackerRecordStore.trackerRecords
        countLabel.text = "\(completedTrackers.count)"
        adjustElements()
    }
    
    func adjustElements() {
        setupLabel()

        if completedTrackers.isEmpty {
            setupCentre()
            emojiImageView.isHidden = false
            emptyLabel.isHidden = false
        } else {
            setupStatisticView()
            emojiImageView.isHidden = true
            emptyLabel.isHidden = true
        }
    }
    
    func setupLabel() {
        view.addSubview(viewLabel)
        NSLayoutConstraint.activate([
            viewLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            viewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            viewLabel.heightAnchor.constraint(equalToConstant: 41)
        ])
    }
    
    func setupCentre() {
        view.addSubview(emptyLabel)
        view.addSubview(emojiImageView)
        
        NSLayoutConstraint.activate([
            emojiImageView.topAnchor.constraint(equalTo: viewLabel.bottomAnchor, constant: 246),
            emojiImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiImageView.heightAnchor.constraint(equalToConstant: 80),
            emojiImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyLabel.topAnchor.constraint(equalTo: emojiImageView.bottomAnchor, constant: 8),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupStatisticView() {
        view.addSubview(gradientView)
        view.addSubview(countLabel)
        view.addSubview(statNameLabel)
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: viewLabel.bottomAnchor, constant: 77),
            gradientView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gradientView.widthAnchor.constraint(equalToConstant: 343),
            gradientView.heightAnchor.constraint(equalToConstant: 90),
            
            countLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 12),
            countLabel.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -12),
            countLabel.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 12),
            countLabel.heightAnchor.constraint(equalToConstant: 41),
            
            statNameLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 12),
            statNameLabel.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -12),
            statNameLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 7),
            statNameLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}


