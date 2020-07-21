
import UIKit
import FirebaseAuth
import Firebase
import GooglePlaces

class SignUpViewController: UIViewController, UITextFieldDelegate, HornBrandDelegate {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var hornBrandTextField: UITextField!
    @IBOutlet weak var hornModelTextField: UITextField!
    @IBOutlet weak var hornFinishTextField: UITextField!
    @IBOutlet weak var hornRoleTextField: UITextField!
    @IBOutlet weak var mouthpieceBrandTextField: UITextField!
    @IBOutlet weak var mouthpieceModelTextField: UITextField!
    @IBOutlet weak var mouthpieceFinishTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var image: UIImage? = nil
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    @IBAction func cityFieldPressed(_ sender: UITextField) {
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.addressComponents.rawValue))!
        autoCompleteController.placeFields = fields
        
        let filter = GMSAutocompleteFilter()
        filter.type = .region
        autoCompleteController.autocompleteFilter = filter
        
        present(autoCompleteController, animated: true, completion: nil)
        
    }
    
    @IBAction func hornBrandPressed(_ sender: UITextField) {
        
        hornBrandTextField.endEditing(true)
        let vc = self.storyboard!.instantiateViewController(withIdentifier: K.VCID.HORN_BRAND) as! HornBrandAutoCompleteSearchController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didChooseBrand(_ brand: String) {
        hornBrandTextField.text = brand
        hornBrandTextField.resignFirstResponder()
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if validateFields() {
            signUp()
        }
    }
    
    func validateFields() -> Bool {
        
        guard let fullName = fullNameTextField.text, !fullName.isEmpty else {
            errorLabel.text = K.Error.ENTER_NAME
            return false
        }
        guard let email = emailTextField.text, !email.isEmpty else {
            errorLabel.text = K.Error.ENTER_EMAIL
            return false
        }
        guard let city = cityTextField.text, !city.isEmpty else {
            errorLabel.text = K.Error.ENTER_CITY
            return false
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            errorLabel.text = K.Error.CREATE_PASSWORD
            return false
        }
        guard let hornBrand = hornBrandTextField.text, !hornBrand.isEmpty else {
            errorLabel.text = K.Error.ENTER_BRAND
            return false
        }
        guard let hornModel = hornModelTextField.text, !hornModel.isEmpty else {
            errorLabel.text = K.Error.ENTER_MODEL
            return false
        }
        guard let hornFinish = hornFinishTextField.text, !hornFinish.isEmpty else {
            errorLabel.text = K.Error.ENTER_FINISH
            return false
        }
        guard let hornRole = hornRoleTextField.text, !hornRole.isEmpty else {
            errorLabel.text = K.Error.ENTER_ROLE
            return false
        }
        guard let mouthpieceBrand = mouthpieceBrandTextField.text, !mouthpieceBrand.isEmpty else {
            errorLabel.text = K.Error.ENTER_BRAND
            return false
        }
        guard let mouthpieceModel = mouthpieceModelTextField.text, !mouthpieceModel.isEmpty else {
            errorLabel.text = K.Error.ENTER_MODEL
            return false
        }
        guard let mouthpieceFinish = mouthpieceFinishTextField.text, !mouthpieceFinish.isEmpty else {
            errorLabel.text = K.Error.ENTER_FINISH
            return false
        }
        return true
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
            errorLabel.text = K.Error.ADD_IMAGE
            return
        }
        
        //compresses image
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        if let email = emailTextField.text?.lowercased(), let password = passwordTextField.text {
            //Creates new user in Firebase Auth
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if error != nil {
                    self.errorLabel.text! = "error creating user Auth. Please try again."
                    
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
                            if let metaImageURL = url?.absoluteString,
                                let fullName = self.fullNameTextField.text,
                                let email = self.emailTextField.text,
                                let location = self.cityTextField.text,
                                let hornBrand = self.hornBrandTextField.text,
                                let hornModel = self.hornModelTextField.text,
                                let hornFinish = self.hornFinishTextField.text,
                                let hornRole = self.hornRoleTextField.text,
                                let mouthpieceBrand = self.mouthpieceBrandTextField.text,
                                let mouthpieceModel = self.mouthpieceModelTextField.text,
                                let mouthpieceFinish = self.mouthpieceFinishTextField.text {
                                //sends user info to Firebase
                                self.db.collection(K.Fstore.collectionName).document(email).setData([
                                    K.Fstore.fullName: fullName,
                                    K.Fstore.email: email,
                                    K.Fstore.profileImageURL: metaImageURL,
                                    K.Fstore.location: location
                                ]) { (error) in
                                    if let e = error {
                                        self.errorLabel.text = K.Error.USER_ADD_FAIL
                                        print(e.localizedDescription)
                                    } else {
                                        print(K.Fstore.USER_ADD_SUCCESS)
                                        
                                        self.db.collection(K.Fstore.collectionName).document(email).collection(K.Fstore.Horn.collectionName).addDocument(data: [
                                            K.Fstore.Horn.hornBrand: hornBrand,
                                            K.Fstore.Horn.hornModel: hornModel,
                                            K.Fstore.Horn.hornFinish: hornFinish,
                                            K.Fstore.Horn.hornRole: hornRole
                                        ]) { (error) in
                                            if let e = error {
                                                self.errorLabel.text = "error adding horn to account. Please try again."
                                                print(e.localizedDescription)
                                            } else {
                                                print("Successfully added horn to user \(email)")
                                                
                                                self.db.collection(K.Fstore.collectionName).document(email).collection(K.Fstore.Mouthpiece.collectionName).addDocument(data: [
                                                    K.Fstore.Mouthpiece.mouthpieceBrand: mouthpieceBrand,
                                                    K.Fstore.Mouthpiece.mouthpieceModel: mouthpieceModel,
                                                    K.Fstore.Mouthpiece.mouthpieceFinish: mouthpieceFinish
                                                ]) { (error) in
                                                    if let e = error {
                                                        self.errorLabel.text = "error adding mouthpiece to account. Please try again."
                                                        print(e.localizedDescription)
                                                    } else {
                                                        print("successfully added mouthpiece to user \(email)")
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
        
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - GMSAutocomplete

extension SignUpViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        if let city = place.name, let state = place.addressComponents![2].shortName {
            cityTextField.text = "\(city), \(state)"
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
