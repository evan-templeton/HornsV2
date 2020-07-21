
import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetPasswordPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text?.lowercased(), email != "" else {
            errorLabel.text = "please enter your email"
            return
        }
        
        resetPassword(email: email, onSuccess: {
            self.view.endEditing(true)
            self.errorLabel.text = "Please check your email to reset your password"
        }) { (error) in
            self.errorLabel.text = "Error resetting your password. \(error)"
        }
        
    }
    
    func setupUI() {
        resetPasswordButton.layer.cornerRadius = 5
    }
    
    func resetPassword(email: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let e = error {
                onError(e.localizedDescription)
            } else {
                onSuccess()
            }
        }
    }
    
}
