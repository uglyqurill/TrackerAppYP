import UIKit

class OnboardingViewController: UIPageViewController {
    
    lazy var pages: [UIViewController] = {
        let blueView = UIViewController()
        let blueImage = UIImage(named: "OnboardingBlue")
        let blueImageView = UIImageView(image: blueImage)
        blueImageView.translatesAutoresizingMaskIntoConstraints = false
        blueView.view.addSubview(blueImageView)
        
        var labelBlue = UILabel()
        labelBlue.text = "Отслеживайте только то, что хотите"
        labelBlue.translatesAutoresizingMaskIntoConstraints = false
        labelBlue.font = UIFont.boldSystemFont(ofSize: 32)
        labelBlue.textAlignment = .center
        labelBlue.numberOfLines = 2
        labelBlue.tintColor = UIColor(named: "ypBlack")
        blueView.view.addSubview(labelBlue)
        
        NSLayoutConstraint.activate([
            blueImageView.topAnchor.constraint(equalTo: blueView.view.topAnchor),
            blueImageView.bottomAnchor.constraint(equalTo: blueView.view.bottomAnchor),
            blueImageView.leadingAnchor.constraint(equalTo: blueView.view.leadingAnchor),
            blueImageView.trailingAnchor.constraint(equalTo: blueView.view.trailingAnchor),
            labelBlue.topAnchor.constraint(equalTo: blueView.view.topAnchor, constant: 432),
            labelBlue.leadingAnchor.constraint(equalTo: blueView.view.leadingAnchor, constant: 16),
            labelBlue.trailingAnchor.constraint(equalTo: blueView.view.trailingAnchor, constant: -16)
        ])

        let redView = UIViewController()
        let redImage = UIImage(named: "OnboardingRed")
        let redImageView = UIImageView(image: redImage)
        redImageView.translatesAutoresizingMaskIntoConstraints = false
        redView.view.addSubview(redImageView)
        
        var labelRed = UILabel()
        labelRed.text = "Даже если это \nне литры воды и йога"
        labelRed.font = UIFont.boldSystemFont(ofSize: 32)
        labelRed.textAlignment = .center
        labelRed.numberOfLines = 2
        labelRed.tintColor = UIColor(named: "ypBlack")
        labelRed.translatesAutoresizingMaskIntoConstraints = false
        redView.view.addSubview(labelRed)
        
        NSLayoutConstraint.activate([
            redImageView.topAnchor.constraint(equalTo: redView.view.topAnchor),
            redImageView.bottomAnchor.constraint(equalTo: redView.view.bottomAnchor),
            redImageView.leadingAnchor.constraint(equalTo: redView.view.leadingAnchor),
            redImageView.trailingAnchor.constraint(equalTo: redView.view.trailingAnchor),
            labelRed.topAnchor.constraint(equalTo: redView.view.topAnchor, constant: 432),
            labelRed.leadingAnchor.constraint(equalTo: redView.view.leadingAnchor, constant: 16),
            labelRed.trailingAnchor.constraint(equalTo: redView.view.trailingAnchor, constant: -16)
        ])
        return [blueView, redView]
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = UIColor(named: "ypBlackDay")
        pageControl.pageIndicatorTintColor = UIColor(named: "ypBackgroundDay")
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    lazy var onboardingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вот это технологии!", for: .normal)
        button.backgroundColor = UIColor(named: "ypBlackDay")
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(dismissOnboarding), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        let transitionStyle: UIPageViewController.TransitionStyle = .scroll
        let navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal
        let options: [UIPageViewController.OptionsKey: Any]? = nil
        super.init(transitionStyle: transitionStyle,
                   navigationOrientation: navigationOrientation,
                   options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        if let first = pages.first {
            setViewControllers([first],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        view.addSubview(onboardingButton)
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            onboardingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            onboardingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            onboardingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            onboardingButton.heightAnchor.constraint(equalToConstant: 60),
            pageControl.bottomAnchor.constraint(equalTo: onboardingButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func dismissOnboarding() {
        let tabBarViewController = TabBarViewController()
        tabBarViewController.awakeFromNib()
        tabBarViewController.modalPresentationStyle = .fullScreen
        present(tabBarViewController, animated: true)
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return nil
        }
        
        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currrentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currrentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
