
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
        let storyBoard = UIStoryboard(name: "Welcome", bundle: nil)
        if Auth.auth().currentUser != nil {
            window?.rootViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarVC") as! UITabBarController
        } else {
            print("Success?")
            window?.rootViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! UINavigationController
        }
        window?.makeKeyAndVisible()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
}
