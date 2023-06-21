import UIKit

class TabBarViewController: UITabBarController {
    
    var window: UIWindow?
    let trackersLabel = NSLocalizedString("trackerTitle", comment: "Text displayed as a title of trackers tab bar item")
    let statisticsLabel = NSLocalizedString("statistics", comment: "Text displayed as a title of statistics tab bar item")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Проинициализируем свойство window:
        window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        UITabBar.appearance().backgroundColor = .ypWhiteBlack
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "ypBlue") ?? .blue], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "ypGrey") ?? .lightGray], for: .normal)
        
        let trackersVC = TrackersViewController()
        let statisticVC = StatisticViewController()
        
        // Установим изображение тени для таб-бара
        let separator = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 2))
        separator.backgroundColor = UIColor(named: "ypLightGrey")
        tabBar.addSubview(separator)


        
        // Настройка TabBarItems:
        trackersVC.tabBarItem = UITabBarItem(title: trackersLabel,
                                             image: UIImage(named: "CircleTabBar"),
                                             selectedImage: nil)
        statisticVC.tabBarItem = UITabBarItem(title: "Статистика",
                                              image: UIImage(named: "HareTabBar"),
                                              selectedImage: nil)
        
        // Добавление контроллеров в массив viewControllers:
        viewControllers = [trackersVC, statisticVC]
    }
}
