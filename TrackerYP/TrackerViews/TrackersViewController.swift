import UIKit

class TrackersViewController: UIViewController, ThirdViewControllerDelegate {
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 140))
    let navItem = UINavigationItem()
    let navItem2 = UINavigationItem()
    let label = UILabel(frame: CGRect(x: 0, y: 40, width: 254, height: 41))
    let plusButton = UIButton(type: .system)
    let centreImage = UIImage(named: "StarHoop")
    var centreImageView = UIImageView()
    let qustionLabel = UILabel()
    
    var currentDate: Int?
    var searchText: String = ""
    var categories: [TrackerCategory] = MockData.categories //все категории
    var visibleCategories: [TrackerCategory] = [] //категории, которые отображается при поиске и/или изменении дня недели
    var completedTrackers: [TrackerRecord] = [] //трекеры, которые были «выполнены» в выбранную дату
    
    
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
        picker.layer.cornerRadius = 10
        picker.tintColor = UIColor(named: "ypBlue")
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)

        return picker
    }()
    
    private lazy var searchField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.backgroundColor = UIColor(named: "ypBackground")
        textField.textColor = UIColor(named: "ypBlack")
        textField.placeholder = "Поиск"
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        return textField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .thirdViewControllerDidDismiss, object: nil)
        
        let navigationController = UINavigationController(rootViewController: TrackersViewController())
        view.backgroundColor = .white
        // Create the navigation bar
        setupNavBar()
        // Create the second line
        setupSecondLineNavBar()
        // Create the third line
        setupSearchField()
        
        //completedTrackers = try! self.trackerRecordStore.fetchTrackerRecord()
        
        setDayOfWeek()
        updateCategories()
        setupTrackers()
        //trackerCategoryStore.delegate = self
    }
    
    func setupNavBar() {
        plusButton.addTarget(self, action: #selector(presentModalViewController), for: .touchUpInside)
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        navBar.backgroundColor = .white
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.tintColor = .black
        
        view.addSubview(navBar)
        navBar.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            navBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            navBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            plusButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            plusButton.widthAnchor.constraint(equalToConstant: 19),
            plusButton.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func setupSecondLineNavBar() {
        label.text = "Трекеры"
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
        centreImageView.image = centreImage
        centreImageView.translatesAutoresizingMaskIntoConstraints = false
        
        qustionLabel.text = "Что будем отслеживать?"
        qustionLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        qustionLabel.textAlignment = .center
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
    
    private func setDayOfWeek() {
        let components = Calendar.current.dateComponents([.weekday], from: Date())
        currentDate = components.weekday
    }
    
    func reloadData() {
        dateChanged()
    }
    
    private func updateCategories() {
        var newCategories: [TrackerCategory] = []
        for category in categories {
            var newTrackers: [Tracker] = []
            for tracker in category.trackers {
                guard let schedule = tracker.dailySchedule else { return }
                let scheduleInts = schedule.map { $0.numberOfDay }
                if let day = currentDate, scheduleInts.contains(day) &&  (searchText.isEmpty || tracker.label.contains(searchText)) {
                    newTrackers.append(tracker)
                }
            }
            if newTrackers.count > 0 {
                let newCategory = TrackerCategory(name: category.name, trackers: newTrackers)
                newCategories.append(newCategory)
            }
        }
        visibleCategories = newCategories
        collectionView.reloadData()
        reloadPlaceholder()
    }
    
    private func reloadPlaceholder() {
        if categories.isEmpty {
            setupCentre()
        }
    }
    
    func setupTrackers() {
        // Define categories and trackers

        
        collectionView.backgroundColor = .white
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
    
    func thirdViewControllerDidDismiss(_ creatingHabitViewController: CreatingHabitViewController) {
        // Update the collection view
        categories = MockData.categories
        collectionView.reloadData()
        updateCategories()

    }
    
    @objc func handleNotification(_ notification: Notification) {
        // Update the collection view
        categories = MockData.categories
        collectionView.reloadData()
        updateCategories()
    }
    
    @objc func presentModalViewController() {
        let creatingTrackerVC = CreatingTrackerViewController()
        present(creatingTrackerVC, animated: true, completion: nil)
    }
    
    @objc private func dateChanged() {
        categories = MockData.categories
        collectionView.reloadData()
        let components = Calendar.current.dateComponents([.weekday], from: datePicker.date)
        if let day = components.weekday {
            currentDate = day
            updateCategories()
            //reloadVisibleCategories()
        }
    }
    
    @objc func textFieldChanged() {
        searchText = searchField.text ?? ""
        updateCategories()
    }
 
    private func reloadVisibleCategories() {
        let calendar = Calendar.current
        let filterWeekday = calendar.component(.weekday, from: datePicker.date)
        let filterText = (searchField.text ?? "").lowercased()
        
        visibleCategories = categories.map { category in
            let trackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty ||
                tracker.label.lowercased().contains(filterText)
                let dateCondition = tracker.dailySchedule?.contains { weekDay in
                    weekDay.numberOfDay == filterWeekday
                } == true
                
                return textCondition && (dateCondition != nil)
            }
            
            return TrackerCategory(
                name: category.name,
                trackers: trackers)
        }
        
        collectionView.reloadData()
    }
    
    func createTracker(
        _ tracker: Tracker, categoryName: String
    ) {
        var categoryToUpdate: TrackerCategory?
        let categories: [TrackerCategory] = trackerCategoryStore.trackerCategories
        for i in 0..<categories.count {
            if categories[i].name == categoryName {
                categoryToUpdate = categories[i]
            }
        }
        if categoryToUpdate != nil {
            try? trackerCategoryStore.addTracker(tracker, to: categoryToUpdate!)
        } else {
            let newCategory = TrackerCategory(name: categoryName, trackers: [tracker])
            categoryToUpdate = newCategory
            try? trackerCategoryStore.addNewTrackerCategory(categoryToUpdate!)
        }
        updateCategories()
        dismiss(animated: true)
    }
}

extension TrackersViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        reloadVisibleCategories()
        
        return true
    }
    
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Return the number of categories you want to display
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of trackers in the current category
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as! TrackersCollectionViewCell
        cell.delegate = self
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        
        let isCompletedToday = isTrackerCompletedToday(id: tracker.id)
        
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
        headerView.titleLabel.text = visibleCategories[indexPath.section].name
        
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

extension TrackersViewController: TrackersCollectionViewCellDelegate {
    func completedTracker(id: UUID, at indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(idTracker: id, date: datePicker.date)
        completedTrackers.append(trackerRecord)
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date,
                                                    inSameDayAs: datePicker.date)
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
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}

extension Date {
    var yearMonthDayComponents: DateComponents {
        Calendar.current.dateComponents([.year, .month, .day], from: self)
    }
}

extension TrackersViewController: TrackerCategoryStoreDelegate {
    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
        visibleCategories = trackerCategoryStore.trackerCategories
        collectionView.reloadData()
    }
}


