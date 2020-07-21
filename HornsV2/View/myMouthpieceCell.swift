
import UIKit

class myMouthpieceCell: UITableViewCell {
    
    @IBOutlet weak var mouthpieceBrandAndModelLabel: UILabel!
    @IBOutlet weak var mouthpieceFinishLabel: UILabel!

    func setMouthpieceCell(mouthpiece: Mouthpiece) {
        mouthpieceBrandAndModelLabel.text = "\(mouthpiece.brand) \(mouthpiece.model)"
        mouthpieceFinishLabel.text = "\(mouthpiece.finish)"
    }

}
