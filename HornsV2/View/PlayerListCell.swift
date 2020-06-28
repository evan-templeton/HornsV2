
import UIKit
import SDWebImage

class PlayerListCell: UITableViewCell {

    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerLocationLabel: UILabel!
    
    func setPlayerCell(player:Player) {
        self.playerImageView.loadImage(player.image)
        playerNameLabel.text = player.name
        playerLocationLabel.text = player.location
    }

}
