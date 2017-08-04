//
//  GroupChoiceTableViewCell.swift
//  ssctel-firebase
//
//  Created by tkwatanabe on 2017/07/31.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import UIKit

class GroupChoiceTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var nameLabel: UILabel!

    var name: String? {
        didSet {
            self.nameLabel.text = name
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
