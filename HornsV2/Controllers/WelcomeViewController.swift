
import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    @IBOutlet weak var signInGoogleButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var termsOfServiceLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "🎺Horns"
        
        setupUI()
        }

    
    func setupUI() {

        signInGoogleButton.layer.cornerRadius = 5
        createAccountButton.layer.cornerRadius = 5

    }
    
    @IBAction func createAccountPressed(_ sender: UIButton) {
    
        self.performSegue(withIdentifier: K.SegueID.CREATE_ACCOUNT, sender: self)
        
    }
}

