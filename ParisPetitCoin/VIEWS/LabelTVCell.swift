//
//  LabelTVCell.swift
//  ParisPetitCoin
//
//  Created by fred on 29/04/2021.
//

import UIKit

class LabelTVCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
