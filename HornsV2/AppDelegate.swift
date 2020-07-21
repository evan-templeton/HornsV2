
import UIKit
import FirebaseAuth
import Firebase
import IQKeyboardManagerSwift
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        GMSPlacesClient.provideAPIKey("AIzaSyCzUaC4lHNFOgx2i6A1oUfv_YQY5NBPv-M")
        configureInitialViewController()
        
        return true
    }
    
    func configureInitialViewController() {
        var initialVC: UIViewController
        let storyBoard = UIStoryboard(name: "Welcome", bundle: nil)
        if Auth.auth().currentUser != nil {
            initialVC = storyBoard.instantiateViewController(identifier: "TabBarVC")
        } else {
            initialVC = storyBoard.instantiateViewController(identifier: "WelcomeVC")
        }
        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
}

