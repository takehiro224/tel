//
//  MemberSearchTableViewCell.swift
//  ssctel-firebase
//
//  Created by tkwatanabe on 2017/07/12.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import UIKit

class MemberListTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var infoContainer: UIView!
    @IBOutlet weak var group: UILabel!

    @IBOutlet weak var nameX: NSLayoutConstraint!
    @IBOutlet weak var infoContainerX: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        photo.image = UIImage(named: "woman")
        photo.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
