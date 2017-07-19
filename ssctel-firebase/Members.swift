//
//  Members.swift
//  ssctel-firebase
//
//  Created by tkwatanabe on 2017/07/13.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import Foundation
import Firebase

public enum MemberAttributes: String {
    case name = "氏名"
    case kana = "フリカナ"
    case company = "事業部"
    case group = "部署"
    case internalPhoneNumber = "携帯内線番号"
    case externalPhoneNumber = "外線番号"
    case sheetPhoneNumber = "座席内線番号"
    case shortMailAddress = "SMS"
    case emailAddress = "Mail"

    var key: String {
        switch self {
        case .name:
            return "name"
        case .kana:
            return "kana"
        case .company:
            return "company"
        case .group:
            return "group"
        case .internalPhoneNumber:
            return "internalPhoneNumber"
        case .externalPhoneNumber:
            return "externalPhoneNumber"
        case .sheetPhoneNumber:
            return "sheetPhoneNumber"
        case .shortMailAddress:
            return "shortMailAddress"
        case .emailAddress:
            return "emailAddress"
        }
    }
}

public let attributes: [MemberAttributes] = [.name, .kana, .company, .group, .internalPhoneNumber, .externalPhoneNumber, .sheetPhoneNumber, .shortMailAddress, .emailAddress]

//MARK: - 従業員データ
struct Member {

    //uid
    var key: String
    //名前
    var name: String
    //kana
    var kana: String? = nil
    //カンパニー名
    var company: String? = nil
    //グループ名
    var group: (String, String)? = nil
    //携帯内線
    var internalPhoneNumber: String? = nil
    //外線
    var externalPhoneNumber: String? = nil
    //座席内線
    var sheetPhoneNumber: String? = nil
    //SMS
    var shortMailAddress: String? = nil
    //e-Mail
    var emailAddress: String? = nil
    //ステータス
    var status: String

    /**
     イニシャライザ

    - Parameters:
        - key: uid
        - name: 名前
        - kana: フリカナ
        - company: カンパニー
        - group: グループ
        - internalPhoneNumber: 電話番号
        - externalPhoneNumber: 外線
        - sheetPhoneNumber: 座席内線
        - shortMailAddress: sms
        - emailAddress: email
        - status: ステータス
     - throws: なし
    */
    init?(
        key: String,
        name: AnyObject?,
        kana: AnyObject?,
        company: AnyObject?,
        group: AnyObject?,
        internalPhoneNumber iTel: AnyObject?,
        externalPhoneNumber eTel: AnyObject?,
        sheetPhoneNumber sTel: AnyObject?,
        shortMailAddress sMail: AnyObject?,
        emailAddress eMail: AnyObject?,
        status: AnyObject?
        ) {
        //uid
        self.key = key
        //氏名
        guard let nameObject = name else { return nil }
        guard let name = nameObject as? String else {
            return nil
        }
        self.name = name
        //フリカナ
        if let kanaObject = kana, let kana = kanaObject as? String {
            self.kana = kana
        }
        //カンパニー名
        if let companyObject = company, let companyName = DataManager.sharedInstance.companyNames["\(companyObject)"] {
            self.company = companyName
        }
        //グループ名
        if let groupObject = group, let groupName = DataManager.sharedInstance.groupNames["\(groupObject)"] {
            self.group = ("\(groupObject)", groupName)
        }
        //電話番号
        if let iTelObject = iTel, let itel = iTelObject as? String { self.internalPhoneNumber = itel }
        //外線
        if let eTelObject = eTel, let etel = eTelObject as? String { self.externalPhoneNumber = etel }
        //座席内線
        if let sTelObject = sTel, let stel = sTelObject as? String { self.sheetPhoneNumber = stel }
        //SMS
        if let sMailObject = sMail, let smail = sMailObject as? String { self.shortMailAddress = smail }
        //E-Mail
        if let eMailObject = eMail, let email = eMailObject as? String { self.emailAddress = email }
        //ステータス
        if let statusObject = status, let status = statusObject as? String { self.status = status } else { self.status = "no status"}
    }

}

//MARK: - 内部用データ作成
class DataManager {

    //Databaseのルート
    let ref = Database.database().reference()
    
    //処理対象メンバー
    var memberInfo: (member: Member, indexPathRow: Int)?

    //全メンバー情報
    var members: [Member] = []
    
    //部署メンバー
    var selectedMembers: [Member] = []

    //カンパニー情報
    var companyNames: [String: String] = [:]

    //グループ情報
    var groupNames: [String: String] = [:]

    //シングルトン
    static let sharedInstance = DataManager()
    private init() {}

    //グループ情報読み込み処理
    public func loadGroupData() {
        //クリア
        self.groupNames.removeAll()
        ref.child("group_info")
            .observe(.value, with: { snapShots in
                var groups = snapShots.value as! [String: AnyObject]
                groups.removeValue(forKey: "user")
                for group in groups {
                    if let name = group.value as? String {
                        self.groupNames[group.key] = name
                    }
                }
                print(DataManager.sharedInstance.groupNames)
            })
    }

    //カンパニー情報読み込み処理
    public func loadCompanyData() {
        //クリア
        self.companyNames.removeAll()
        ref.child("company_info")
            .observe(.value, with: { snapShots in
                var groups = snapShots.value as! [String: AnyObject]
                groups.removeValue(forKey: "user")
                for group in groups {
                    if let name = group.value as? String {
                        self.companyNames[group.key] = name
                    }
                }
                print(DataManager.sharedInstance.companyNames)
            })
    }

    //読み込み
    public func load(snapshots: DataSnapshot) {
        //クリア
        self.members.removeAll()
        //変換処理
        for memberData in snapshots.children {
            //取得したデータをDataSnapshot型に格納
            let dataSnapshot = memberData as! DataSnapshot
            //DataSnapshotから辞書型データに変換
            guard let data = dataSnapshot.value as? [String: AnyObject] else {
                //Firebaseデータを辞書型に変換できない場合はエラーとし、離脱
                return
            }
            guard let member = Member(
                key: dataSnapshot.key,
                name: data["name"],
                kana: data["kana"],
                company: data["company"],
                group: data["group"],
                internalPhoneNumber: data["internalPhoneNumber"],
                externalPhoneNumber: data["externalPhoneNumber"],
                sheetPhoneNumber: data["sheetPhoneNumber"],
                shortMailAddress: data["shortMailAddress"],
                emailAddress: data["emailAddress"],
                status: data["status"])
                else {
                    return
            }
            members.append(member)
        }
    }
    
    public func choiceMember(_ indexPath: IndexPath) {
        self.memberInfo = (members[indexPath.row], indexPath.row)
    }
    
    public func updateMemberData(_ memberInfo: (Member, Int)) {
        self.memberInfo = memberInfo
        self.members[memberInfo.1] = memberInfo.0
    }
    
    public func selectGroupMembers(group: String) {
        self.selectedMembers.removeAll()
        self.selectedMembers = self.members.filter{ $0.group?.0 == group }
        for mem in self.selectedMembers {
            print(mem.name)
        }
    }
}

