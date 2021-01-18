
import UIKit

class PlayerHornCell: UITableViewCell {
    
    @IBOutlet weak var playerHornLabel: UILabel!
    @IBOutlet weak var playerHornRoleLabel: UILabel!
    @IBOutlet weak var playerHornFinishLabel: UILabel!
    
    func setHornCell(horn: Horn) {
        playerHornLabel.text = "\(horn.brand) \(horn.model)"
        playerHornFinishLabel.text = horn.finish
        playerHornRoleLabel.text = horn.role
    }
}
