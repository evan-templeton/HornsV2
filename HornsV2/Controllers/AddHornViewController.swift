
import UIKit
import Firebase

class AddHornViewController: UIViewController {
    
    let db = Firestore.firestore()
    var email: String?
    
    @IBOutlet weak var hornMakeTextField: UITextField!
    @IBOutlet weak var hornModelTextField: UITextField!
    @IBOutlet weak var hornFinishTextField: UITextField!
    @IBOutlet weak var hornRoleTextField: UITextField!
    @IBOutlet weak var addHornButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func addHornPressed(_ sender: UIButton) {
        addHorn()
    }
    
    func setupUI() {
        addHornButton.layer.cornerRadius = 5
    }
    
    func addHorn() {
        if let hornBrand = self.hornMakeTextField.text,
            let hornModel = self.hornModelTextField.text,
            let hornFinish = self.hornFinishTextField.text,
            let hornRole = self.hornRoleTextField.text {
            db.collection(K.Fstore.collectionName).document(email!).collection(K.Fstore.Horn.collectionName)
                .addDocument(data: [
                    K.Fstore.Horn.hornBrand: hornBrand,
                    K.Fstore.Horn.hornModel: hornModel,
                    K.Fstore.Horn.hornFinish: hornFinish,
                    K.Fstore.Horn.hornRole: hornRole
                ]) { (error) in
                    if let e = error {
                        print(e.localizedDescription)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                        print("Successfully added horn to user \(self.email!)")
                    }
            }
        }
    }
}
