
import UIKit
import Firebase

class AddMouthpieceViewController: UIViewController {
    
    var email: String?
    let db = Firestore.firestore()
    
    @IBOutlet weak var mouthpieceMakeTextField: UITextField!
    @IBOutlet weak var mouthpieceModelTextField: UITextField!
    @IBOutlet weak var mouthpieceFinishTextField: UITextField!
    @IBOutlet weak var addMouthpieceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    @IBAction func addMouthpiecePressed(_ sender: UIButton) {
        addMouthpiece()
    }
    
    func setupUI() {
        addMouthpieceButton.layer.cornerRadius = 5
    }
    
    func addMouthpiece() {
        if let mouthpieceBrand = self.mouthpieceMakeTextField.text,
            let mouthpieceModel = self.mouthpieceModelTextField.text,
            let mouthpieceFinish = self.mouthpieceFinishTextField.text {
            db.collection(K.Fstore.collectionName).document(email!).collection(K.Fstore.Mouthpiece.collectionName)
                .addDocument(data: [
                    K.Fstore.Mouthpiece.mouthpieceBrand: mouthpieceBrand,
                    K.Fstore.Mouthpiece.mouthpieceModel: mouthpieceModel,
                    K.Fstore.Mouthpiece.mouthpieceFinish: mouthpieceFinish
                ]) { (error) in
                    if let e = error {
                        print(e.localizedDescription)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                        print("Successfully added mouthpiece to user \(self.email!)")
                    }
            }
        }
    }
}
