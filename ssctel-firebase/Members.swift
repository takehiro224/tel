//
//  Members.swift
//  ssctel-firebase
//
//  Created by tkwatanabe on 2017/07/13.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import Foundation
import Firebase

enum GroupName: Int {
    case bs = 0
    case sd = 1
    case logi = 2

    var name: String {
        switch self {
        case .bs:
            return "B.P.S"
        case .sd:
            return "SD"
        case .logi:
            return "SI東日本ロジスティクス"
        }
    }
}

//MARK: - 従業員データ
struct Member {

    //uid
    var key: String
    //名前
    var name: String
    //電話番号
    var phoneNumber: String?
    //ステータス
    var status: String
    //グループ名
    var group: Int

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

    //イニシャライザ
    init(key: String,
         name: String,
         phoneNumber tel: String?,
         status: String,
         group: Int) {
        self.key = key
        self.name = name
        self.phoneNumber = tel
        self.status = status
        self.group = group
    }

}

//MARK: - 所属グループデータ
struct Group {
    var name: String
    var members: [Member]
}

//MARK: - 内部用データ作成
class DataManager {
    
    //Databaseのルート
    let ref = Database.database().reference()
    
    //処理対象メンバー
    var memberInfo: (member: Member, indexPathRow: Int)?

    //全メンバー情報
    var members: [Member] = []
    
    //グループ情報
    var groupNames: [String: String] = [:]

    //シングルトン
    static let sharedInstance = DataManager()
    private init() {}
    
    public func loadGroup(snapshots: DataSnapshot) {
    }

    //読み込み
    public func load(snapshots: DataSnapshot) {
        //クリア
        self.members.removeAll()
        //変換処理
        for member in snapshots.children {
            //取得したデータをDataSnapshot型に格納
            let dataSnapshot = member as! DataSnapshot
            print(dataSnapshot.key)
            print(dataSnapshot.value)
            //DataSnapshotから辞書型データに変換
            let data = dataSnapshot.value as! [String: AnyObject]
            members.append(
                Member(
                    key: String(describing: dataSnapshot.key),
                    name: String(describing: data["name"]!),
                    phoneNumber: data["phoneNumber"] != nil ? String(describing: data["phoneNumber"]!) : nil,
                    status: String(describing: data["status"]),
                    group: 1
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
