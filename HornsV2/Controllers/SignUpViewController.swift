
import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var image: UIImage? = nil
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        self.view.endEditing(true)
        validateFields()
        signUp()
    }
    
    
    
    func validateFields() {
        
        guard let fullName = fullNameTextField.text, !fullName.isEmpty else {
            errorLabel.text = "please enter your name"
            return
        }
        guard let email = emailTextField.text, !email.isEmpty else {
            errorLabel.text = "please enter your email address"
            return
        }
        guard let city = cityTextField.text, !city.isEmpty else {
            errorLabel.text = "please enter your city"
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            errorLabel.text = "please create a password"
            return
        }
    }
    
    func setupUI() {
        avatar.layer.cornerRadius = 40
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)
        signUpButton.layer.cornerRadius = 5
        
    }
    
    //MARK: - Sign Up Functionality
    
    func signUp() {
        
        guard let imageSelected = self.image else {
            errorLabel.text = "please add a profile image"
            return
        }
        
        //compresses image
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        //Creates new user in Firebase Auth
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
            if let e = error {
                self.errorLabel.text = e.localizedDescription
                return
            }
            //grabs user's uid from Auth, creates Firestore profile child with uid
            if let authData = authResult {
                let uid = authData.user.uid
                let storageRef = self.storage.reference(forURL: "gs://horns-cb5c4.appspot.com")
                let storageProfileRef = storageRef.child("profile").child(uid)
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                //puts compressed image inside storageProfileRef, the user's profile child
                storageProfileRef.putData(imageData, metadata: metadata) { (storageMetaData, error) in
                    if let e = error {
                        print(e.localizedDescription)
                        return
                    }
                    //grabs URL for the user's profile image
                    storageProfileRef.downloadURL { (url, error) in
                        if let e = error {
                            print(e.localizedDescription)
                            return
                        }
                        //metaImageURL is the user's image URL
                        if let metaImageURL = url?.absoluteString, let fullName = self.fullNameTextField.text, let email = self.emailTextField.text, let location = self.cityTextField.text {
                            //sends user's name, email, and image to Firebase
                            self.db.collection(K.Fstore.collectionName).addDocument(data: [
                                K.Fstore.fullName: fullName,
                                K.Fstore.email: email,
                                K.Fstore.profileImageURL: metaImageURL,
                                K.Fstore.location: location
                            ]) { (error) in
                                if let e = error {
                                    print("There was an issue saving data to Firestore. \(e)")
                                    self.errorLabel.text = "error creating account. Please try again."
                                } else {
                                    print("Successfully saved data.")
                                    self.performSegue(withIdentifier: "signUpSegue", sender: self)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: - ImagePickerControllerDelegate, UINavigationControllerDelegate

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            avatar.image = imageSelected
            image = imageSelected
        }
        
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            avatar.image = imageOriginal
            image = imageOriginal
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
