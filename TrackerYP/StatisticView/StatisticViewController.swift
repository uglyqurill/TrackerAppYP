//import UIKit
//
//final class StatisticViewController: UIViewController {
//    //тут будет статистика
//}

import UIKit

final class StatisticViewController: UIViewController {
    //тут будет статистика
    let textLabel = UITextField()
    
    override func viewDidLoad() {
        textLabel.text = "Привет, ревьюер! :)"
        textLabel.tintColor = .black
        //textLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        view.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
