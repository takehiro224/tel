//
//  Members.swift
//  ssctel-firebase
//
//  Created by tkwatanabe on 2017/07/13.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import Foundation
import Firebase

enum GroupInfo: Int {
    case bs = 0
    case sd = 1
    case logi = 2

    var name: String {
        switch self {
        case .bs:
            return ""
        case .sd:
            return ""
        case .logi:
            return ""
        }
    }
}

//MARK: - 従業員データ
struct Member {

    var key: String
    var name: String
    var phoneNumber: String?
//    var group: Int

//    var id: Int
//    var password: String
//    var lastName: String
//    var firstName: String
//    var lastNameKana: String
//    var firstNameKana: String
//    var group1: String
//    var group2: String
//    var internalPhoneNumber: String
//    var externalPhoneNumber: String
//    var sheetPhoneNumber: String
//    var shortMailAddress: String
//    var emailAddress: String
//    var status: String

    init(key: String, name: String, phoneNumber tel: String?) {
        self.key = key
        self.name = name
        self.phoneNumber = tel
    }

}

//MARK: - 所属グループデータ
struct Group {
    var name: String
    var members: [Member]
}

//MARK: - 内部用データ作成
class DataManager {
    
    //処理対象メンバー
    var memberInfo: (member: Member, indexPathRow: Int)?

    //全メンバー情報
    var members: [Member] = []

    static let sharedInstance = DataManager()

    private init() {}

    //全グループ情報

    //読み込み
    public func load(snapshots: DataSnapshot) {
        //クリア
        self.members.removeAll()
        //変換処理
        for member in snapshots.children {
            //取得したデータをDataSnapshot型に格納
            let dataSnapshot = member as! DataSnapshot
            //DataSnapshotから辞書型データに変換
            let data = dataSnapshot.value as! [String: AnyObject]
            members.append(
                Member(
                    key: String(describing: dataSnapshot.key),
                    name: String(describing: data["name"]!),
                    phoneNumber: data["phoneNumber"] != nil ? String(describing: data["phoneNumber"]!) : nil
                )
            )
        }
    }
    
    public func choiceMember(_ indexPath: IndexPath) {
        self.memberInfo = (members[indexPath.row], indexPath.row)
    }
    
    public func updateMemberData(_ memberInfo: (Member, Int)) {
        self.memberInfo = memberInfo
        self.members[memberInfo.1] = memberInfo.0
    }
}

enum UserAttribute {
    //    var group: Int

    //    var id: Int
    //    var password: String
    //    var lastName: String
    //    var firstName: String
    //    var lastNameKana: String
    //    var firstNameKana: String
    //    var group1: String
    //    var group2: String
    //    var internalPhoneNumber: String
    //    var externalPhoneNumber: String
    //    var sheetPhoneNumber: String
    //    var shortMailAddress: String
    //    var emailAddress: String
    //    var status: String
    case id
    case key
    case name
}
