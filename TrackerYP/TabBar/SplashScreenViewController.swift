import UIKit

final class SplashScreenViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBar = TabBarController()
        tabBar.awakeFromNib()
        window.rootViewController = tabBar
    }
}
