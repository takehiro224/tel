//
//  ConfigTableViewCell.swift
//  ssctel-firebase
//
//  Created by tkwatanabe on 2017/08/03.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import UIKit

class ConfigTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var profileData: UITextField!

    var companyKey: Int? = nil
    var groupKey: Int? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
