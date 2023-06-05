import UIKit

final class CreatingTrackerViewController: UIViewController {
    
    let habitButton = UIButton()
    let eventButton = UIButton()
    let infoLabel = UILabel()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        adjustElements()
    }
    
    func adjustElements() {
        setLabel()
        setButtons()
    }
    
    func setLabel() {
        infoLabel.text = "Создание трекера"
        infoLabel.textColor = UIColor(named: "ypBlackDay")
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setButtons() {
        habitButton.setTitle("Привычка", for: .normal)
        eventButton.setTitle("Нерегулярное событие", for: .normal)
        habitButton.layer.cornerRadius = 10
        eventButton.layer.cornerRadius = 10
        habitButton.clipsToBounds = true
        eventButton.clipsToBounds = true
        
        habitButton.addTarget(self, action: #selector(presentCreatingHabitViewController), for: .touchUpInside)
        
        habitButton.backgroundColor = UIColor(named: "ypBlackDay")
        eventButton.backgroundColor = UIColor(named: "ypBlackDay")
        
        habitButton.titleLabel?.textColor = .white
        eventButton.titleLabel?.textColor = .white
        
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(habitButton)
        view.addSubview(eventButton)
        
        NSLayoutConstraint.activate([
            habitButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 295),
            habitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habitButton.widthAnchor.constraint(equalToConstant: 335),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.widthAnchor.constraint(equalToConstant: 335),
            eventButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            eventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func presentCreatingHabitViewController() {
        let creatingHabitVC = CreatingHabitViewController()
        present(creatingHabitVC, animated: true, completion: nil)
    }
    
}

extension CreatingHabitViewController: ThirdViewControllerDelegate {
    func thirdViewControllerDidDismiss(_ creatingHabitViewController: CreatingHabitViewController) {
    }
    
    func createTracker(_ tracker: Tracker, categoryName: String) {
        delegate?.createTracker(tracker, categoryName: categoryName)
    }
}
