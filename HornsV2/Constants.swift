
import Foundation

struct K {
    
    static let cellIdentifier = "ReusableCell"
    static let hornCellIdentifier = "ReusableHornCell"
    static let mouthpieceCellIdentifier = "ReusableMouthpieceCell"
    
    struct SegueID {
        static let CREATE_ACCOUNT = "CreateAccountSegue"
    }
    
    struct VCID {
        static let HORN_BRAND = "HornBrandVC"
        static let WELCOME_VC = "WelcomeVC"
    }
    
    struct Error {
        static let ENTER_NAME = "please enter your name"
        static let ENTER_EMAIL = "please enter your email"
        static let ENTER_CITY = "please enter your city"
        static let CREATE_PASSWORD = "please create a password"
        static let ENTER_BRAND = "please enter the brand"
        static let ENTER_MODEL = "please enter the model"
        static let ENTER_FINISH = "please enter the finish"
        static let ENTER_ROLE = "what is this horn mainly used for?"
        static let ADD_IMAGE = "please add a profile image"
        static let USER_ADD_FAIL = "there was an error adding user to Firebase"
    }

    struct Fstore {
        static let collectionName = "players"
        static let fullName = "fullName"
        static let profileImageURL = "profileImageURL"
        static let uid = "uid"
        static let email = "email"
        static let location = "location"
        static let USER_ADD_SUCCESS = "Successfully added user"
        
        struct Horn {
            static let collectionName = "horns"
            static let hornBrand = "hornBrand"
            static let hornModel = "hornModel"
            static let hornFinish = "hornFinish"
            static let hornRole = "hornRole"
        }
        
        struct Mouthpiece {
            static let collectionName = "mouthpieces"
            static let mouthpieceBrand = "mouthpieceBrand"
            static let mouthpieceModel = "mouthpieceModel"
            static let mouthpieceFinish = "mouthpieceFinish"
        }
}
}
