//
//  TableViewCell.swift
//  ssctel-firebase
//
//  Created by tkwatanabe on 2017/07/14.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import UIKit

class MemberDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemValue: UILabel!

    var name: String? {
        didSet {
            itemName.text = name
        }
    }

    var value: String? {
        didSet {
            itemValue.text = value
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
