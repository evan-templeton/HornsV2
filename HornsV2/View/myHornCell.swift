
import UIKit

class myHornCell: UITableViewCell {

    @IBOutlet weak var hornBrandAndModelLabel: UILabel!
    @IBOutlet weak var hornFinishLabel: UILabel!
    @IBOutlet weak var hornRoleLabel: UILabel!
    
    func setHornCell(horn: Horn) {
        hornBrandAndModelLabel.text = "\(horn.brand) \(horn.model)"
        hornFinishLabel.text = horn.finish
        hornRoleLabel.text = horn.role
    }
}
