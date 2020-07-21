
import UIKit

class PlayerMouthpieceCell: UITableViewCell {
    
    @IBOutlet weak var playerMouthpieceBrandLabel: UILabel!
    @IBOutlet weak var playerMouthpieceFinishLabel: UILabel!
    
    func setMouthpieceCell(mouthpiece: Mouthpiece) {
        playerMouthpieceBrandLabel.text = "\(mouthpiece.brand) \(mouthpiece.model)"
        playerMouthpieceFinishLabel.text = mouthpiece.finish
    }
}
