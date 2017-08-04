//
//  MemberSearchTableViewCell.swift
//  ssctel-firebase
//
//  Created by tkwatanabe on 2017/07/12.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class MemberListTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var infoContainer: UIView!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var group: UILabel!

    @IBOutlet weak var nameX: NSLayoutConstraint!
    @IBOutlet weak var infoContainerX: NSLayoutConstraint!
    @IBOutlet weak var groupX: NSLayoutConstraint!

    var member = Member() {
        didSet {
            // URLがあれば写真を表示
            let fileName = member.key!
            let imageRef = storageRef.child("images/\(fileName).jpg")
            imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                if error == nil {
                    if data == nil {
                        self.photo.image = UIImage(named: "woman")
                    } else {
                        self.photo.image = UIImage(data: data!)
                    }
                } else {
                    //print(error!)
                }
            }

            // 名前
            if let name = member.name {
                self.name.text = name
            }

            // 事業部
            if let company = member.company {
                self.company.text = company.name
            }

            // 部署
            if let group = member.group {
                self.group.text = group.name
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        photo.image = UIImage(named: "woman")
        photo.layer.cornerRadius = photo.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
