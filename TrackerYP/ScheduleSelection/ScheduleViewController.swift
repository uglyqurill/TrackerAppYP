import UIKit

final class ScheduleViewController: UIViewController {
    
    weak var delegate: ScheduleViewControllerDelegate?
    
    let tableView = UITableView()
    let infoLabel = UILabel()
    let readyButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setLabel()
        setupTableView()
        setupButton()
    }
    
    func setLabel() {
        infoLabel.text = "Расписание"
        infoLabel.textColor = UIColor(named: "ypBlackDay")
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    
    func setupTableView() {
        tableView.backgroundColor = UIColor(named: "ypBackgroundDay")
        tableView.layer.cornerRadius = 10
        tableView.clipsToBounds = true
        
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: "dayCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 30),
            tableView.heightAnchor.constraint(equalToConstant: 524)
        ])
    }
    
    func setupButton() {
        readyButton.layer.cornerRadius = 10
        readyButton.clipsToBounds = true
        readyButton.setTitle("Готово", for: .normal)
        readyButton.backgroundColor = UIColor(named: "ypBlackDay")
        readyButton.addTarget(self, action: #selector(scheduleIsReady), for: .touchUpInside)
        
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(readyButton)
        
        NSLayoutConstraint.activate([
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 47),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
}

extension ScheduleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as! ScheduleTableViewCell
        cell.backgroundColor = .clear
        
        switch indexPath.section {
        case 0:
            cell.dayLabel.text = "Понедельник"
        case 1:
            cell.dayLabel.text = "Вторник"
        case 2:
            cell.dayLabel.text = "Среда"
        case 3:
            cell.dayLabel.text = "Четверг"
        case 4:
            cell.dayLabel.text = "Пятница"
        case 5:
            cell.dayLabel.text = "Суббота"
        case 6:
            cell.dayLabel.text = "Воскресенье"
        default:
            cell.dayLabel.text = ""
        }
        
        return cell
    }
    
    @objc func scheduleIsReady() {
        var selectedDays = [WeekDay]()
        
        for section in 0..<tableView.numberOfSections {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: section)) as? ScheduleTableViewCell {
                if cell.daySwitch.isOn {
                    switch section {
                    case 0:
                        selectedDays.append(.monday)
                    case 1:
                        selectedDays.append(.tuesday)
                    case 2:
                        selectedDays.append(.wednesday)
                    case 3:
                        selectedDays.append(.thursday)
                    case 4:
                        selectedDays.append(.friday)
                    case 5:
                        selectedDays.append(.saturday)
                    case 6:
                        selectedDays.append(.sunday)
                    default:
                        break
                    }
                }
            }
        }
        
        delegate?.didUpdateSchedule(selectedDays: selectedDays)
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75 // adjust this value to fit your needs
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // If the cell contains a switch, don't allow selection and let the switch handle the tap event
        return nil
    }
}
