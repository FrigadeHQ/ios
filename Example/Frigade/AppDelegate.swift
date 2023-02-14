import UIKit
import Frigade

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FrigadeProvider.setup(configuration: .init(apiKey: "api_public_MCCFEY1DOUFF5UZ9RJ5Y00T4CI8N1TO110WM4NCA5M68J33S8Z446K3M81IZ7C3Z", userId: nil))
        return true
    }
}

