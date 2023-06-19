import UIKit

protocol CreateTrackerVCDelegate: AnyObject {
    func createTracker(_ tracker: Tracker, categoryName: String)
}

class CreatingTrackerViewController: UIViewController {
   
    public weak var delegate: CreateTrackerVCDelegate?
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Создание трекера"
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var createHabbitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Привычка", for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(habbitButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var createIrregularEventButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нерегулярное событие", for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(irregularEventButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setupLayout()
    }
    
    
    @objc private func habbitButtonAction() {
        let creatingHabitVC = CreatingHabitViewController()
        creatingHabitVC.delegate = self
        present(creatingHabitVC, animated: true)
    }
    
    @objc private func irregularEventButtonAction() {
        let creatingIrregularEventVC = CreatingIrregularEvent()
        creatingIrregularEventVC.delegate = self
        present(creatingIrregularEventVC, animated: true)
    }
    
    private func addSubviews() {
        view.addSubview(label)
        view.addSubview(createHabbitButton)
        view.addSubview(createIrregularEventButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            
            createHabbitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createHabbitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createHabbitButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 295),
            createHabbitButton.widthAnchor.constraint(equalToConstant: 335),
            createHabbitButton.heightAnchor.constraint(equalToConstant: 60),
            
            createIrregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createIrregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createIrregularEventButton.topAnchor.constraint(equalTo: createHabbitButton.bottomAnchor, constant: 16),
            createIrregularEventButton.widthAnchor.constraint(equalToConstant: 335),
            createIrregularEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension CreatingTrackerViewController: CreateEventVCDelegate {
    
    func createTracker(_ tracker: Tracker, categoryName: String) {
        delegate?.createTracker(tracker, categoryName: categoryName)
    }
}
