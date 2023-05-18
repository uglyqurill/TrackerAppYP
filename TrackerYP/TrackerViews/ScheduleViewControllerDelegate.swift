import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didUpdateSchedule(selectedDays: [String])
}

final class CreatingHabitViewController: UIViewController, UICollectionViewDelegate {
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
    
    var trackerDate = ""
    var selectedEmoji = ""
    var selectedColor: UIColor = .gray

    let emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let emojies = [ "🙂", "🏓", "❤️", "🐕", "🤔", "😪", "🥇", "🥦", "🙌", "😡", "👨‍🎓", "🥹", "🔥", "⏰", "🛌", "🎂", "👨‍💻", "📚"]
    
    let colors = ["#FD4C49", "#FF881E", "#007BFA", "#6E44FE", "#33CF69", "#E66DD4", "#F9D4D4", "#34A7FE", "#46E69D", "#35347C", "#FF674D", "#FF99CC", "#F6C48B", "#7994F5", "#832CF1", "#AD56DA", "#8D72E6", "#2FD058"]
    
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
        searchTrackerField.borderStyle = .roundedRect
        searchTrackerField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        searchTrackerField.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(searchTrackerField)
        
        NSLayoutConstraint.activate([
            searchTrackerField.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 38),
            searchTrackerField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            searchTrackerField.widthAnchor.constraint(equalToConstant: 343),
            searchTrackerField.heightAnchor.constraint(equalToConstant: 75)
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
        
        categoryButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 343 - 16, bottom: 0, right: 0)
        scheduleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 343 - 16, bottom: 0, right: 0)
        
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
        
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        scheduleButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(categoryButton)
        contentView.addSubview(scheduleButton)
        
        NSLayoutConstraint.activate([
            categoryButton.topAnchor.constraint(equalTo: searchTrackerField.bottomAnchor, constant: 24),
            categoryButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            categoryButton.widthAnchor.constraint(equalToConstant: 343),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            
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
        createButton.addTarget(self, action: #selector(createTracker), for: .touchUpInside)
        
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
        // Функция для категорий
    }
    
    @objc func presentScheduleViewController() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.delegate = self
        present(scheduleVC, animated: true, completion: nil)
    }
    
    @objc func cancelCreation() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func createTracker() {
        // Cоздание трекера
        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true)
    }
    
    @objc func textFieldDidChange() {
        if let searchText = searchTrackerField.text, !searchText.isEmpty {
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
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 29),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -29),
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
            cell.selectionView.isHidden = false
            selectedColor = UIColor(hex: colors[indexPath.row]) ?? UIColor(named: "ypGrey")!
        }

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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SupplementaryView
            headerView.titleLabel.text = "Emojis"
            
            return headerView
        default:
            fatalError("Unexpected element kind")
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
        12
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
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 29),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -29),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 192)
        ])
    }
}

// Метод делегата, изменяющий кнопку расписания
extension CreatingHabitViewController: ScheduleViewControllerDelegate {
    func didUpdateSchedule(selectedDays: [String]) {
        let daysString = selectedDays.joined(separator: ", ")
        trackerDate = daysString
        
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
