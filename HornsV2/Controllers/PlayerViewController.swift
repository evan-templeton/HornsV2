
import UIKit
import SDWebImage
import Firebase

class PlayerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var playerImage: String?
    var playerName: String = ""
    var playerLocation: String = ""
    var playerEmail: String = ""
    
    let db = Firestore.firestore()
    
    var playerHornList: [Horn] = []
    var playerMouthpieceList: [Mouthpiece] = []
    
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerLocationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        playerImageView.loadImage(playerImage)
        playerNameLabel.text = playerName
        playerLocationLabel.text = playerLocation
        
        loadPlayerHorns()
        loadPlayerMouthpieces()
    }
    
    func loadPlayerHorns() {
        db.collection(K.Fstore.collectionName).document(playerEmail).collection(K.Fstore.Horn.collectionName)
            //.order(by: K.Fstore.location)
            .getDocuments { (querySnapshot, error) in
                
                if let e = error {
                    print("There was an issue retrieving horn data from Firestore. \(e.localizedDescription)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let hornBrand = data[K.Fstore.Horn.hornBrand] as? String,
                                let hornModel = data[K.Fstore.Horn.hornModel] as? String,
                                let hornFinish = data[K.Fstore.Horn.hornFinish] as? String,
                                let hornRole = data[K.Fstore.Horn.hornRole] as? String {
                                let newHorn = Horn(brand: hornBrand, model: hornModel, finish: hornFinish, role: hornRole)
                                self.playerHornList.append(newHorn)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
        }
    }
    
    func loadPlayerMouthpieces() {
        db.collection(K.Fstore.collectionName).document(playerEmail).collection(K.Fstore.Mouthpiece.collectionName)
            .getDocuments { (querySnapshot, error) in
                
                if let e = error {
                    print("There was an error retrieving mouthpiece data from Firestore. \(e.localizedDescription)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let mouthpieceBrand = data[K.Fstore.Mouthpiece.mouthpieceBrand] as? String,
                                let mouthpieceModel = data[K.Fstore.Mouthpiece.mouthpieceModel] as? String,
                                let mouthpieceFinish = data[K.Fstore.Mouthpiece.mouthpieceFinish] as? String {
                                let newMouthpiece = Mouthpiece(brand: mouthpieceBrand, model: mouthpieceModel, finish: mouthpieceFinish)
                                self.playerMouthpieceList.append(newMouthpiece)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return playerHornList.count
        } else {
            return playerMouthpieceList.count
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let horn = playerHornList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: K.hornCellIdentifier, for: indexPath) as! PlayerHornCell
            cell.setHornCell(horn: horn)
            return cell
        } else {
            let mouthpiece = playerMouthpieceList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: K.mouthpieceCellIdentifier, for: indexPath) as! PlayerMouthpieceCell
            cell.setMouthpieceCell(mouthpiece: mouthpiece)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Horns"
        } else {
            return "Mouthpieces"
        }
    }
    
}
