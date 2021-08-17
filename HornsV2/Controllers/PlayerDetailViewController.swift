
import UIKit
import SDWebImage
import Firebase

class PlayerDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerLocationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var player: Player?
    private var db: Firestore?
    private var playerHornList: [Horn] = []
    private var playerMouthpieceList: [Mouthpiece] = []
    
    init(player: Player, db: Firestore) {
        self.player = player
        self.db = db
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadPlayerDetail()
        loadPlayerHorns()
        loadPlayerMouthpieces()
    }
    
    private func loadPlayerDetail() {
        playerImageView.loadImage(self.player?.image)
        playerNameLabel.text = player?.name
        playerLocationLabel.text = player?.location
    }
    
    func loadPlayerHorns() {
        guard let db = self.db, let player = self.player else { return }
        // Make these constants shorter
        db.collection(K.Fstore.collectionName).document(player.email).collection(K.Fstore.Horn.collectionName)
            .getDocuments { (querySnapshot, error) in
                
                if let error = error {
                    print("There was an issue retrieving horn data from Firestore. \(error.localizedDescription)")
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
        guard let db = self.db, let player = self.player else { return }
        db.collection(K.Fstore.collectionName).document(player.email).collection(K.Fstore.Mouthpiece.collectionName)
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
