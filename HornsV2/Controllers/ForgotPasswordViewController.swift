
import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetPasswordPressed(_ sender: UIButton) {
        
    }
    
    func setupUI() {
        resetPasswordButton.layer.cornerRadius = 5
    }
    
}
