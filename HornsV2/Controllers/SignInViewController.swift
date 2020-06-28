
import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signInPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "signInSegue", sender: self)
                }
            }
        }
    }
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        
    }
    
    func setupUI() {
        signInButton.layer.cornerRadius = 5
    }
    
}
