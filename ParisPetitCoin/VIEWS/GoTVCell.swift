//
//  GoTVCell.swift
//  ParisPetitCoin
//
//  Created by fred on 29/04/2021.
//

import UIKit

class GoTVCell: UITableViewCell {

    @IBOutlet weak var goButton: UIButton!

    var button: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func goButtonPressed(sender: UIButton) {
        if let goButton = self.button {
            goButton()
        }
    }
}
