import UIKit

class TrackersViewController: UIViewController, CreateTrackerVCDelegate {
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    private let trackerStore = TrackerStore()
    
    private let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 140))
    private let navItem = UINavigationItem()
    private let navItem2 = UINavigationItem()
    private let label = UILabel(frame: CGRect(x: 0, y: 40, width: 254, height: 41))
    private let plusButton = UIButton(type: .system)
    private let hoopImage = UIImage(named: "StarHoop")
    private let thinkImage = UIImage(named: "ThinkngEmoji")
    private var centreImageView = UIImageView()
    private let qustionLabel = UILabel()
    private let mainLabel = NSLocalizedString("trackerTitle", comment: "Text displayed as a title of main view")
    private let searchLabel = NSLocalizedString("search", comment: "Text for search placeholder")
    private var selectedFilter: Filter?
    
    //аналитика
    private let analyticsService = AnalyticsService()
    private var tapPlusCount = 0
    private var tapFilterButton = 0
    private var tapEditButton = 0
    private var tapDeleteButton = 0
    
    private var currentDate: Int?
    private var searchText: String = ""
    private var categories: [TrackerCategoryModel] = [] //все категории
    private var pinnedTrackers: [Tracker] = []
    private var visibleCategories: [TrackerCategoryModel] = [] //категории, которые отображается при поиске и/или изменении дня недели
    private var completedTrackers: [TrackerRecord] = [] //трекеры, которые были «выполнены» в выбранную дату
    
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TrackersCollectionViewCell.self,
                                forCellWithReuseIdentifier: "trackerCell")
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = Locale (identifier: "ru Ru")
        picker.calendar.firstWeekday = 2
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.clipsToBounds = true
        picker.backgroundColor = .ypDatePickerColor
        picker.layer.cornerRadius = 10
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        picker.setValue(UIColor.black, forKey: "textColor")

        return picker
    }()
    
    private lazy var searchField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.backgroundColor = UIColor(named: "ypBackground")
        textField.textColor = UIColor(named: "ypBlack")
        textField.placeholder = searchLabel
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        return textField
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Фильтры", for: .normal)
        button.backgroundColor = UIColor(named: "ypBlue")
        button.layer.cornerRadius = 16
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(filtersButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteBlack
        analyticsService.report(event: "open", params: ["Screen" : "Main"])
        
        // Create the navigation bar
        setupNavBar()
        // Create the second line
        setupSecondLineNavBar()
        // Create the third line
        setupSearchField()
        
        completedTrackers = trackerRecordStore.trackerRecords
        setDayOfWeek()
        updateCategories(with: trackerCategoryStore.trackerCategories)
        setupTrackers()
        setupCentre()
        setupFilterButton()
        trackerCategoryStore.delegate = self
        centreImageView.isHidden = true
        qustionLabel.isHidden = true
        filterButton.isHidden = true
        reloadPlaceholder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.report(event: "close", params: ["Screen" : "Main"])
        print("Event: close")
    }
    
    func setupNavBar() {
        plusButton.addTarget(self, action: #selector(presentModalViewController), for: .touchUpInside)
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        navBar.backgroundColor = .ypWhiteBlack
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.tintColor = .ypBlackWhite
        
        view.addSubview(navBar)
        navBar.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            navBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            navBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            plusButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            plusButton.widthAnchor.constraint(equalToConstant: 19),
            plusButton.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func setupSecondLineNavBar() {
        label.text = mainLabel
        label.font = UIFont(name: "HelveticaNeue", size: 34)
        label.font = UIFont.boldSystemFont(ofSize: 34)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label and date picker to the navigation bar
        navBar.addSubview(label)
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 13),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            label.heightAnchor.constraint(equalToConstant: 41),
            datePicker.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func setupSearchField() {
        // Add the search field to the navigation bar
        view.addSubview(searchField)
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 7),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func setupCentre() {
        centreImageView.image = hoopImage
        centreImageView.isHidden = false
        centreImageView.translatesAutoresizingMaskIntoConstraints = false
        
        qustionLabel.text = "Что будем отслеживать?"
        qustionLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        qustionLabel.textAlignment = .center
        qustionLabel.isHidden = false
        qustionLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(centreImageView)
        view.addSubview(qustionLabel)
        
        NSLayoutConstraint.activate([
            centreImageView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 230),
            centreImageView.heightAnchor.constraint(equalToConstant: 80),
            centreImageView.widthAnchor.constraint(equalToConstant: 80),
            centreImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            qustionLabel.topAnchor.constraint(equalTo: centreImageView.bottomAnchor, constant: 8),
            qustionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qustionLabel.widthAnchor.constraint(equalToConstant: 343)
        ])

    }
    
    func setupFilterButton() {
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114)
        ])
    }
    
    private func setDayOfWeek() {
        let components = Calendar.current.dateComponents([.weekday], from: Date())
        currentDate = components.weekday
    }
    
    func reloadData() {
        dateChanged()
    }
    
    private func updateCategories(with categories: [TrackerCategoryModel]) {
        var newCategories: [TrackerCategoryModel] = []
        var pinnedTrackers: [Tracker] = []
        for category in categories {
            var newTrackers: [Tracker] = []
            for tracker in category.visibleTrackers(filterString: searchText, pin: nil) {
                guard let schedule = tracker.dailySchedule else { return }
                let scheduleInts = schedule.map { $0.numberOfDay }
                if let day = currentDate, scheduleInts.contains(day) {
                    if selectedFilter == .completed {
                        if !completedTrackers.contains(where: { record in
                            record.idTracker == tracker.id &&
                            record.date.yearMonthDayComponents == datePicker.date.yearMonthDayComponents
                        }) {
                            continue
                        }
                    }
                    if selectedFilter == .uncompleted {
                        if completedTrackers.contains(where: { record in
                            record.idTracker == tracker.id &&
                            record.date.yearMonthDayComponents == datePicker.date.yearMonthDayComponents
                        }) {
                            continue
                        }
                    }
                    if tracker.pinned == true {
                        pinnedTrackers.append(tracker)
                    } else {
                        newTrackers.append(tracker)
                    }
                }
            }
            if newTrackers.count > 0 {
                let newCategory = TrackerCategoryModel(name: category.name, trackers: newTrackers)
                newCategories.append(newCategory)
            }
        }
        visibleCategories = newCategories
        self.pinnedTrackers = pinnedTrackers
        collectionView.reloadData()
        reloadPlaceholder()
    }
    
    private func reloadPlaceholder() {
        if visibleCategories.isEmpty {
            setupCentre()
        } else {
            centreImageView.isHidden = true
            qustionLabel.isHidden = true
            filterButton.isHidden = false
        }
    }
    
    func setupTrackers() {
        // Define categories and trackers

        collectionView.backgroundColor = .ypWhiteBlack
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)

        // Add constraints to collection view

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 34),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    @objc func presentModalViewController() {
        tapPlusCount += 1
        print(trackerRecordStore.self)
        let creatingTrackerVC = CreatingTrackerViewController()
        creatingTrackerVC.delegate = self
        creatingTrackerVC.view.backgroundColor = .ypWhiteBlack
        analyticsService.report(event: "click", params: ["Screen" : "Main", "add_track" : tapPlusCount])
        present(creatingTrackerVC, animated: true, completion: nil)
    }
    
    @objc private func dateChanged() {
        collectionView.reloadData()
        let components = Calendar.current.dateComponents([.weekday], from: datePicker.date)
        if let day = components.weekday {
            currentDate = day
            updateCategories(with: trackerCategoryStore.trackerCategories)
            reloadPlaceholder()
        }
    }
    
    
    @objc func textFieldChanged() {
        searchText = searchField.text ?? ""
        visibleCategories = trackerCategoryStore.predicateFetch(label: searchText)
        if visibleCategories.isEmpty {
            centreImageView.isHidden = false
            qustionLabel.isHidden = false
            filterButton.isHidden = true
            centreImageView.image = thinkImage
            qustionLabel.text = "Ничего не найдено"
        } else {
            centreImageView.isHidden = true
            qustionLabel.isHidden = true
            filterButton.isHidden = false
        }
        collectionView.reloadData()
    }
    
    @objc func filtersButtonAction() {
        tapFilterButton += 1
        analyticsService.report(event: "click", params: ["Screen" : "Main", "filter" : tapFilterButton])
    }

    func createTracker(
        _ tracker: Tracker, categoryName: String
    ) {
        var categoryToUpdate: TrackerCategoryModel?
        let categories: [TrackerCategoryModel] = trackerCategoryStore.trackerCategories
        for i in 0..<categories.count {
            if categories[i].name == categoryName {
                categoryToUpdate = categories[i]
            }
        }
        if categoryToUpdate != nil {
            try? trackerCategoryStore.addTracker(tracker, to: categoryToUpdate!)
        } else {
            let newCategory = TrackerCategoryModel(name: categoryName, trackers: [tracker])
            categoryToUpdate = newCategory
            try? trackerCategoryStore.addNewTrackerCategory(categoryToUpdate!)
        }
        updateCategories(with: trackerCategoryStore.trackerCategories)
        dismiss(animated: true)
    }
}

extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = visibleCategories.count
        collectionView.isHidden = count == 0 && pinnedTrackers.count == 0
        return count + 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        
        if section == 0 {
            return pinnedTrackers.count
        } else {
            return visibleCategories[section - 1].visibleTrackers(filterString: searchText, pin: false).count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as! TrackersCollectionViewCell
        cell.delegate = self
        let tracker: Tracker
        if indexPath.section == 0 {
            tracker = pinnedTrackers[indexPath.row]
        } else {
            tracker = visibleCategories[indexPath.section - 1].visibleTrackers(filterString: searchText, pin: false)[indexPath.row]
        }
        
        let isCompletedToday = completedTrackers.contains(where: { record in
            record.idTracker == tracker.id &&
            record.date.yearMonthDayComponents == datePicker.date.yearMonthDayComponents
        })
        
        let completedDays = completedTrackers.filter { $0.idTracker == tracker.id }.count
        cell.configure(with: tracker,
                       isCompletedToday: isCompletedToday,
                       indexPath: indexPath,
                       completedDays: completedDays)
        
        cell.setTrackerColor(tracker.color ?? .gray)
        cell.setTrackerId(tracker.id)
        cell.setTrackerName(tracker.label)
        cell.setTrackerCheckButtonColor(tracker.color ?? .gray)
        cell.setTrackerEmoji(tracker.emoji ?? ":)")
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as! SupplementaryView
        
        // Set up the header view here
        headerView.titleLabel.text = visibleCategories[indexPath.section - 1].name
        return headerView
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date,
                                                    inSameDayAs: datePicker.date)
            return trackerRecord.idTracker == id && isSameDay
        }
    }

}

extension TrackersViewController {
    func deleteTracker(_ tracker: Tracker) {
        try? self.trackerStore.deleteTracker(tracker)
    }
    
    private func actionSheet(trackerToDelete: Tracker) {
        let alert = UIAlertController(title: "Уверены, что хотите удалить трекер?",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Удалить",
                                      style: .destructive) { [weak self] _ in
            self?.deleteTracker(trackerToDelete)
        })
        alert.addAction(UIAlertAction(title: "Отменить",
                                      style: .cancel) { _ in
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func makeContextMenu(_ indexPath: IndexPath) -> UIMenu {
        let tracker: Tracker
        if indexPath.section == 0 {
            tracker = pinnedTrackers[indexPath.row]
        } else {
            tracker = visibleCategories[indexPath.section - 1].visibleTrackers(filterString: searchText, pin: false)[indexPath.row]
        }
        let pinTitle = tracker.pinned == true ? "Открепить" : "Закрепить"
        let pin = UIAction(title: pinTitle, image: nil) { [weak self] action in
            try? self?.trackerStore.togglePinTracker(tracker)
        }
        
        let rename = UIAction(title: "Редактировать", image: nil) { [weak self] action in
            let editTrackerVC = CreatingHabitViewController()
            editTrackerVC.editTracker = tracker
            editTrackerVC.editTrackerDate = self?.datePicker.date ?? Date()
            self?.tapEditButton += 1
            self?.analyticsService.report(event: "click", params: ["Screen" : "Main", "edit" : self?.tapEditButton])
            self?.present(editTrackerVC, animated: true)
        }
        
        let delete = UIAction(title: "Удалить", image: nil, attributes: .destructive) { [weak self] action in
            self?.actionSheet(trackerToDelete: tracker)
            self?.tapDeleteButton += 1
            self?.analyticsService.report(event: "click", params: ["Screen" : "Main", "delete" : self?.tapDeleteButton])
        }
        return UIMenu(children: [pin, rename, delete])
    }
}

extension TrackersViewController: TrackersCollectionViewCellDelegate {
    
    func completedTracker(id: UUID, at indexPath: IndexPath) {
        if let index = completedTrackers.firstIndex(where: { record in
            record.idTracker == id &&
            record.date.yearMonthDayComponents == datePicker.date.yearMonthDayComponents
        }) {
            completedTrackers.remove(at: index)
            try? trackerRecordStore.deleteTrackerRecord(with: id)
        } else {
            completedTrackers.append(TrackerRecord(idTracker: id, date: datePicker.date))
            try? trackerRecordStore.addNewTrackerRecord(TrackerRecord(idTracker: id, date: datePicker.date))
        }
        collectionView.reloadData()
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date,
                                                    inSameDayAs: datePicker.date)
            try? trackerRecordStore.deleteTrackerRecord(with: id)
            return trackerRecord.idTracker == id && isSameDay
        }
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 167, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 && pinnedTrackers.count == 0 {
            return .zero
        }
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return CGSize(width: collectionView.bounds.width, height: 50)
        
//        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

extension TrackersViewController: TrackerCategoryStoreDelegate {
    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
        visibleCategories = trackerCategoryStore.trackerCategories
        collectionView.reloadData()
    }
}

extension TrackersViewController: TrackerRecordStoreDelegate {
    func store(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate) {
        completedTrackers = trackerRecordStore.trackerRecords
        collectionView.reloadData()
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(
         _ collectionView: UICollectionView,
         contextMenuConfigurationForItemAt indexPath: IndexPath,
         point: CGPoint
     ) -> UIContextMenuConfiguration? {
         let identifier = "\(indexPath.row):\(indexPath.section)" as NSString
         return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) {
             suggestedActions in
              return self.makeContextMenu(indexPath)
         }
     }
    
    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let identifier = configuration.identifier as? String else { return nil }
        let components = identifier.components(separatedBy: ":")
        print(identifier)
        guard let rowString = components.first,
              let sectionString = components.last,
              let row = Int(rowString),
              let section = Int(sectionString) else { return nil }
        let indexPath = IndexPath(row: row, section: section)
                
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackersCollectionViewCell else { return nil }
        
        return UITargetedPreview(view: cell.menuView)
    }
}

