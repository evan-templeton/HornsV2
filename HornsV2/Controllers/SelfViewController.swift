
import UIKit
import FirebaseAuth
import Firebase
import SDWebImage

class SelfViewController: UIViewController {
    
    let appDelegate = AppDelegate()
    let db = Firestore.firestore()
    
    var myImage: String?
    var myName: String = ""
    var myLocation: String = ""
    let myEmail = (Auth.auth().currentUser!.email!)
    let welcomeVC = WelcomeViewController()
    
    var myHornList: [Horn] = []
    var myMouthpieceList: [Mouthpiece] = []
    
    @IBOutlet weak var myNameLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myLocationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addHornButton: UIButton!
    @IBOutlet weak var addMouthpieceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "🎺Profile"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupUI()
        loadMyInfo()
        loadMyHorns()
        loadMyMouthpieces()
    }
    
    func setupUI() {
        addHornButton.layer.cornerRadius = 5
        addMouthpieceButton.layer.cornerRadius = 5
    }
    
    func loadMyInfo() {
        
        db.collection(K.Fstore.collectionName).document(myEmail)
            .getDocument { (querySnapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let data = querySnapshot?.data() {
                        if let playerName = data[K.Fstore.fullName] as? String,
                            let myImageString = data[K.Fstore.profileImageURL] as? String,
                            let myLocation = data[K.Fstore.location] as? String
                        {
                            DispatchQueue.main.async {
                                self.myNameLabel.text = playerName
                                self.myImageView.loadImage(myImageString)
                                self.myLocationLabel.text = myLocation
                            }
                            
                        }
                    }
                }
        }
    }
    
    func loadMyHorns() {
        
        db.collection(K.Fstore.collectionName).document(myEmail).collection(K.Fstore.Horn.collectionName)
            .addSnapshotListener { (querySnapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let hornBrand = data[K.Fstore.Horn.hornBrand] as? String,
                                let hornModel = data[K.Fstore.Horn.hornModel] as? String,
                                let hornFinish = data[K.Fstore.Horn.hornFinish] as? String,
                                let hornRole = data[K.Fstore.Horn.hornRole] as? String {
                                let newHorn = Horn(brand: hornBrand, model: hornModel, finish: hornFinish, role: hornRole)
                                self.myHornList.append(newHorn)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
        }
    }
    
    func loadMyMouthpieces() {
        db.collection(K.Fstore.collectionName).document(myEmail).collection(K.Fstore.Mouthpiece.collectionName)
        .addSnapshotListener { (querySnapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let mouthpieceBrand = data[K.Fstore.Mouthpiece.mouthpieceBrand] as? String,
                                let mouthpieceModel = data[K.Fstore.Mouthpiece.mouthpieceModel] as? String,
                                let mouthpieceFinish = data[K.Fstore.Mouthpiece.mouthpieceFinish] as? String {
                                let newMouthpiece = Mouthpiece(brand: mouthpieceBrand, model: mouthpieceModel, finish: mouthpieceFinish)
                                self.myMouthpieceList.append(newMouthpiece)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addHornSegue" {
            let destinationVC = segue.destination as! AddHornViewController
            destinationVC.email = myEmail
        } else {
            let destinationVC = segue.destination as! AddMouthpieceViewController
            destinationVC.email = myEmail
        }
        
    }
    
    @IBAction func addHornPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "addHornSegue", sender: self)
    }
    
    @IBAction func addMouthpiecePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "addMouthpieceSegue", sender: self)
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
//            appDelegate.configureInitialViewController()
            self.navigationController?.popToViewController(welcomeVC, animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

extension SelfViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Horns"
        } else {
            return "Mouthpieces"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return myHornList.count
        } else {
            return myMouthpieceList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let horn = myHornList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "myHornCell", for: indexPath) as! myHornCell
            cell.setHornCell(horn: horn)
            return cell
        } else {
            let mouthpiece = myMouthpieceList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "myMouthpieceCell", for: indexPath) as! myMouthpieceCell
            cell.setMouthpieceCell(mouthpiece: mouthpiece)
            return cell
        }
    }
}
