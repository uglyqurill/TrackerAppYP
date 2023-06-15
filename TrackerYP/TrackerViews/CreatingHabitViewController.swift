import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didUpdateSchedule(selectedDays: [WeekDay])
}

protocol CreateEventVCDelegate: AnyObject {
    func createTracker(_ tracker: Tracker, categoryName: String)
}

final class CreatingHabitViewController: UIViewController, UICollectionViewDelegate {
    weak var delegate: CreateEventVCDelegate?
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    var selectionView = UIView()
    // MARK: Class constants
    let infoLabel = UILabel()
    
    let searchTrackerField = UITextField()
    let categoryButton = UIButton()
    let scheduleButton = UIButton()
    let createButton = UIButton()
    let cancelButton = UIButton()
    

    let separatorView = UIView()
    let emojiLabel = UILabel()
    let colorLabel = UILabel()
    
    var trackerDate = ""
    var selectedEmoji = "🌟"
    var selectedColor: UIColor = .gray
    var trackerDays = [WeekDay]()

    let emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let emojies = [ "🙂", "🏓", "❤️", "🐕", "🤔", "😪", "🥇", "🥦", "🙌", "😡", "👨‍🎓", "🥹", "🔥", "⏰", "🛌", "🎂", "👨‍💻", "📚"]
    let colors = ["#FD4C49", "#FF881E", "#007BFA", "#6E44FE", "#33CF69", "#E66DD4", "#F9D4D4", "#34A7FE", "#46E69D", "#35347C", "#FF674D", "#FF99CC", "#F6C48B", "#7994F5", "#832CF1", "#AD56DA", "#8D72E6", "#2FD058"]
    var categorySubTitle: String = ""
    
    private var category: TrackerCategoryModel? = nil {
        didSet {
            isButtonEnabled()
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        adjustElements()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    
    // MARK: adjustElements is used for setting up all elements
    func adjustElements() {
        setLabel()
        setSearchTrackerField()
        setupTrackerButtons()
        setupCollection()
        setupLowerButtons()
        setupScrollView()
    }
    
    // MARK: ScrollView
    
    func setupScrollView() {
                
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    // MARK: Set Functions
    func setLabel() {
        infoLabel.text = "Новая привычка"
        infoLabel.textColor = UIColor(named: "ypBlackDay")
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),
            infoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    func setSearchTrackerField() {
        searchTrackerField.backgroundColor = UIColor(named: "ypBackgroundDay")
        searchTrackerField.placeholder = "Введите название трекера"
        searchTrackerField.layer.cornerRadius = 10
        searchTrackerField.clipsToBounds = true
        searchTrackerField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        let leftInsetView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: searchTrackerField.frame.height))
        searchTrackerField.leftView = leftInsetView
        searchTrackerField.leftViewMode = .always
        
        searchTrackerField.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(searchTrackerField)
        
        NSLayoutConstraint.activate([
            searchTrackerField.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 38),
            searchTrackerField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            searchTrackerField.widthAnchor.constraint(equalToConstant: 343),
            searchTrackerField.heightAnchor.constraint(equalToConstant: 75),
        ])
    }
    
    func setupTrackerButtons() {
        categoryButton.setTitle("Категория", for: .normal)
        scheduleButton.setTitle("Расписание", for: .normal)
        
        categoryButton.layer.cornerRadius = 10
        scheduleButton.layer.cornerRadius = 10
        categoryButton.clipsToBounds = true
        scheduleButton.clipsToBounds = true
        
        categoryButton.contentHorizontalAlignment = .left
        scheduleButton.contentHorizontalAlignment = .left
        categoryButton.setImage(UIImage(named: "CheckArrow"), for: .normal)
        scheduleButton.setImage(UIImage(named: "CheckArrow"), for: .normal)
        
        categoryButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 343 - 31, bottom: 0, right: 0)
        scheduleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 343 - 31, bottom: 0, right: 0)
        categoryButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        scheduleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        // Set the corner radius only to the top corners of categoryButton
        categoryButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
         // Set the corner radius only to the bottom corners of scheduleButton
        scheduleButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        scheduleButton.addTarget(self, action: #selector(presentScheduleViewController), for: .touchUpInside)
        categoryButton.addTarget(self, action: #selector(presentCreatingCategoryViewController), for: .touchUpInside)
        
        categoryButton.backgroundColor = UIColor(named: "ypBackgroundDay")
        scheduleButton.backgroundColor = UIColor(named: "ypBackgroundDay")
        
        categoryButton.setTitleColor(.black, for: .normal)
        scheduleButton.setTitleColor(.black, for: .normal)
        
        separatorView.backgroundColor = UIColor(named: "ypGrey")
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorView)
        
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        scheduleButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(categoryButton)
        contentView.addSubview(scheduleButton)
        
        NSLayoutConstraint.activate([
            categoryButton.topAnchor.constraint(equalTo: searchTrackerField.bottomAnchor, constant: 24),
            categoryButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            categoryButton.widthAnchor.constraint(equalToConstant: 343),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            
            separatorView.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 0),
            separatorView.centerXAnchor.constraint(equalTo: categoryButton.centerXAnchor),
            separatorView.widthAnchor.constraint(equalToConstant: 311),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            
            scheduleButton.widthAnchor.constraint(equalToConstant: 343),
            scheduleButton.heightAnchor.constraint(equalToConstant: 75),
            scheduleButton.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 0),
            scheduleButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    func setupCollection() {
        emojiCollectionView.allowsMultipleSelection = false
        colorCollectionView.allowsMultipleSelection = false
        
        setupColors()
        layoutColors()
        setupEmojies()
        layoutEmojies()
        setupTextLabels()
    }
    
    func setupTextLabels() {
        emojiLabel.text = "Emoji"
        emojiLabel.font = UIFont.boldSystemFont(ofSize: 19)
        emojiLabel.textColor = UIColor(named: "ypBlackDay")
        
        colorLabel.text = "Цвет"
        colorLabel.font = UIFont.boldSystemFont(ofSize: 19)
        colorLabel.textColor = UIColor(named: "ypBlackDay")
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(emojiLabel)
        contentView.addSubview(colorLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: 32),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            emojiLabel.widthAnchor.constraint(equalToConstant: 52),
            emojiLabel.heightAnchor.constraint(equalToConstant: 18),
            colorLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 220),
            colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            colorLabel.widthAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    func setupLowerButtons() {
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(UIColor(named: "ypRed"), for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.layer.borderColor = UIColor(named: "ypRed")?.cgColor
        cancelButton.layer.borderWidth = 2.0
        cancelButton.layer.cornerRadius = 10
        cancelButton.clipsToBounds = true
        
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.white, for: .normal)
        createButton.backgroundColor = UIColor(named: "ypGrey")
        createButton.layer.cornerRadius = 10
        createButton.clipsToBounds = true
        createButton.isEnabled = false
        
        
        cancelButton.addTarget(self, action: #selector(cancelCreation), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createNewTracker), for: .touchUpInside)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cancelButton)
        contentView.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 46),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: 161),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),
            
            createButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 46),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: 161),
            createButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),
        ])
        
    }
    
    @objc func presentCreatingCategoryViewController() {
        let categoryVC = CategoryViewController(delegate: self, selectedCategory: category)
        present(categoryVC, animated: true, completion: nil)
    }
    
    @objc func presentScheduleViewController() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.delegate = self
        present(scheduleVC, animated: true, completion: nil)
    }
    
    @objc func cancelCreation() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func createNewTracker() { 
        // Cоздание трекера
        let newTracker = Tracker(
            id: UUID(),
            label: searchTrackerField.text ?? "Мой Трекер",
            color: selectedColor,
            emoji: selectedEmoji,
            dailySchedule: trackerDays
        )

        delegate?.createTracker(newTracker, categoryName: category?.name ?? "Без категории")
        let rootViewController = self.presentingViewController?.presentingViewController
        dismiss(animated: true)
        NotificationCenter.default.post(name: .thirdViewControllerDidDismiss, object: nil)
    }
    
    @objc func textFieldDidChange() {
        isButtonEnabled()
    }
    
    
    func isButtonEnabled() {
        if let searchText = searchTrackerField.text, !searchText.isEmpty && trackerDate != "" && selectedEmoji != "" && selectedColor != .gray {
            createButton.isEnabled = true
            createButton.backgroundColor = UIColor(named: "ypBlackDay")
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = UIColor(named: "ypGrey")
        }
    }
    
}


// MARK: - Emoji Collection

extension CreatingHabitViewController {
    
    func setupEmojies() {
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        
        emojiCollectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        emojiCollectionView.register(SupplementaryView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: "header")
    }
    
    func layoutEmojies() {
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiCollectionView)
        NSLayoutConstraint.activate([
            emojiCollectionView.topAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: 32),
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == emojiCollectionView {
            // Получаем выбранную ячейку
            guard let cell = emojiCollectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell else { return }
            cell.selectionView.isHidden = false
            selectedEmoji = emojies[indexPath.row]
        } else {
            guard let cell = colorCollectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell else { return }
            cell.selectionView.layer.borderColor = UIColor(hex: colors[indexPath.row])?.withAlphaComponent(0.6).cgColor
            
            cell.selectionView.isHidden = false
            selectedColor = UIColor(hex: colors[indexPath.row]) ?? UIColor(named: "ypGrey")!
        }
        isButtonEnabled()

    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            // Получаем выбранную ячейку
            guard let cell = emojiCollectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell else { return }
            cell.selectionView.isHidden = true
            selectedEmoji = emojies[indexPath.row]
        } else {
            guard let cell = colorCollectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell else { return }
            cell.selectionView.isHidden = true
            selectedColor = UIColor(hex: colors[indexPath.row]) ?? UIColor(named: "ypGrey")!
        }
    }
}

extension CreatingHabitViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emojies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EmojiCollectionViewCell
            cell?.titleLabel.text = emojies[indexPath.row]
            return cell!
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorCollectionViewCell
            let hexColor = colors[indexPath.row]
            let buttonColor = UIColor(hex: hexColor)
            cell?.colorButton.backgroundColor = buttonColor
            return cell!
        }
    }
}

extension CreatingHabitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 6, height: 38)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
}

// MARK: - Color Collection

extension CreatingHabitViewController {
    
    func setupColors() {
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        
        colorCollectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
        colorCollectionView.register(SupplementaryView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: "header")
    }
    
    func layoutColors() {
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorCollectionView)
        NSLayoutConstraint.activate([
            colorCollectionView.topAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: 270),
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

// Метод делегата, изменяющий кнопку расписания
extension CreatingHabitViewController: ScheduleViewControllerDelegate {
    func didUpdateSchedule(selectedDays: [WeekDay]) {
        let selectedDaysStrings = selectedDays.map { $0.shortName }
        let daysString = selectedDaysStrings.joined(separator: ", ")
        trackerDate = daysString
        trackerDays = selectedDays
        isButtonEnabled()
        
        guard daysString.isEmpty == false else {
            scheduleButton.titleLabel?.numberOfLines = 1
            scheduleButton.setTitle("Расписание", for: .normal)
            return
        }
        
        scheduleButton.tintColor = UIColor.clear
        let firstLine = NSAttributedString(string: "Расписание", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "ypBlackDay")])
        let secondLine = NSAttributedString(string: "\n\(daysString)", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "ypGrey")])
        let title = NSMutableAttributedString(attributedString: firstLine)
        title.append(secondLine)
        
        scheduleButton.titleLabel?.numberOfLines = 0
        
        scheduleButton.setAttributedTitle(title, for: .normal)
        scheduleButton.setTitle(title.string, for: .normal)
    }
}

extension CreatingHabitViewController: CategoryListViewModelDelegate {
    func createCategory(category: TrackerCategoryModel) {
        self.category = category
        let categoryString = category.name
        categorySubTitle = categoryString
        isButtonEnabled()
        updateCategoryButton()
    }
    
    func updateCategoryButton() {
        guard categorySubTitle != "" else {
            categoryButton.titleLabel?.numberOfLines = 1
            categoryButton.setTitle("Категория", for: .normal)
            return
        }
        
        //categoryButton.tintColor = UIColor.clear
        let firstLine = NSAttributedString(string: "Категория", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "ypBlackDay") ?? .black])
        let secondLine = NSAttributedString(string: "\n\(categorySubTitle)", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "ypGrey") ?? .black])
        let title = NSMutableAttributedString(attributedString: firstLine)
        title.append(secondLine)
        
        categoryButton.titleLabel?.numberOfLines = 0
        
        categoryButton.setAttributedTitle(title, for: .normal)
        categoryButton.setTitle(title.string, for: .normal)
    }
}

extension Notification.Name {
    static let thirdViewControllerDidDismiss = Notification.Name("ThirdViewControllerDidDismiss")
}

