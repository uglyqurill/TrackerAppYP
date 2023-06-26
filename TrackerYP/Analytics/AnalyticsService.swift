import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "a9c17a30-fd1e-4799-8a88-d01c8a1fc6fd") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: String, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func didTapTrackerOnMain() {
        report(event: "click", params: ["Screen": "Main", "item": "track"])
    }
    
    func didTapAddTrackerOnMain() {
        report(event: "click", params: ["Screen": "Main", "item": "add_track"])
    }
    
    func didTapFilterOnMain() {
        report(event: "click", params: ["Screen": "Main", "item": "filter"])
    }
    
    func didChooseEditOnMain() {
        report(event: "click", params: ["Screen": "Main", "item": "edit"])
    }
    
    func didChooseDeleteOnMain() {
        report(event: "click", params: ["Screen": "Main", "item": "delete"])
    }
}
