
import UIKit
import Firebase

class PlayerListScreen: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    var playerList: [Player] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadPlayerList()
    }
    
    func loadPlayerList() {
        db.collection(K.Fstore.collectionName)
            //.order(by: K.Fstore.location)
            .addSnapshotListener { (querySnapshot, error) in
                
                self.playerList = []
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let playerName = data[K.Fstore.fullName] as? String, let playerImage = data[K.Fstore.profileImageURL] as? String, let playerLocation = data[K.Fstore.location] as? String {
                                let newPlayer = Player(name: playerName, image: playerImage, location: playerLocation)
                                self.playerList.append(newPlayer)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: self.playerList.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                    }
                }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
    
    do {
        try Auth.auth().signOut()
    } catch let signOutError as NSError {
        print ("Error signing out: %@", signOutError)
    }
        (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
    }
    
    
}

extension PlayerListScreen: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let player = playerList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! PlayerListCell
        cell.setPlayerCell(player: player)
        
        return cell
    }
}
