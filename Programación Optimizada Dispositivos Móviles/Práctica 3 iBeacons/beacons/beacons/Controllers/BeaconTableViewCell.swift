//
//  BeaconTableViewCell.swift
//  beacons
//
//  Created by Yaser  on 10/5/21.
//

import UIKit

class BeaconTableViewCell: UITableViewCell {

    @IBOutlet weak var identity: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var signal: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var accuracy: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
