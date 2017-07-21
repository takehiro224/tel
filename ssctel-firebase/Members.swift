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
    case name
    case kana
    case company
    case group
    case internalPhoneNumber
    case externalPhoneNumber
    case sheetPhoneNumber
    case shortMailAddress
    case emailAddress

    var itemName: String {
        switch self {
        case .name:
            return "氏名"
        case .kana:
            return "フリカナ"
        case .company:
            return "事業部"
        case .group:
            return "部署"
        case .internalPhoneNumber:
            return "携帯内線"
        case .externalPhoneNumber:
            return "外線"
        case .sheetPhoneNumber:
            return "座席内線"
        case .shortMailAddress:
            return "SMS"
        case .emailAddress:
            return "Mail"
        }
    }
}

public let attributes: [MemberAttributes] = [.name, .kana, .company, .group, .internalPhoneNumber, .externalPhoneNumber, .sheetPhoneNumber, .shortMailAddress, .emailAddress]

//MARK: - 従業員データ
public struct Member: CustomStringConvertible {

    //uid
    var key: String? = nil
    //名前
    var name: String? = nil
    //kana
    var kana: String? = nil
    //カンパニー名
    var company: (code: String, name: String)? = nil
    //グループ名
    var group: (code: String, name: String)? = nil
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
    var status: String? = nil

    // MARK: - CustomStringConvertible
    public var description: String {
        get {
            var string = "\nkey: \(key ?? "No Data")"
            string += "name: \(name ?? "No Data")\n"
            string += "kana: \(kana ?? "No Data")\n"
            string += "company: \(company?.name ?? "No Data")\n"
            string += "group: \(group?.name ?? "No Data")\n"
            string += "internalPhoneNumber: \(internalPhoneNumber ?? "No Data")\n"
            string += "externalPhoneNumber: \(externalPhoneNumber ?? "No Data")\n"
            string += "sheetPhoneNumber: \(sheetPhoneNumber ?? "No Data")\n"
            string += "shortMailAddress: \(shortMailAddress ?? "No Data")\n"
            string += "emailAddress: \(emailAddress ?? "No Data")\n"
            string += "status: \(status ?? "No Data")\n"

            return string
        }
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
    
    //絞り込み選択されたメンバー
    var selectedMembers: [Member] = []

    //事業部情報
    var companyNames: [String: String] = [:] {
        didSet {
            companyKeys.removeAll()
            companyValues.removeAll()
            companyKeys = [String](self.companyNames.keys)
            companyValues = [String](self.companyNames.values)
            companyInfo.removeAll()
            for i in 0 ..< companyNames.count {
                companyInfo.append((key: companyKeys[i], value: companyValues[i], check: "No"))
            }
        }
    }
    var companyKeys: [String] = []
    var companyValues: [String] = []
    var companyInfo: [(key: String, value: String, check: String)] = []

    //部署情報
    var groupNames: [String: String] = [:] {
        didSet {
            groupKeys.removeAll()
            groupValues.removeAll()
            groupKeys = [String](self.groupNames.keys)
            groupValues = [String](self.groupNames.values)
            groupInfo.removeAll()
            for i in 0 ..< groupNames.count {
                groupInfo.append((key: groupKeys[i], value: groupValues[i], check: "No"))
            }
        }
    }
    var groupKeys: [String] = []
    var groupValues: [String] = []
    var groupInfo: [(key: String, value: String, check: String)] = []

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
            })
    }

    // 読み込み
    public func load(snapshots: DataSnapshot) {
        // クリア
        self.members.removeAll()
        // 変換処理
        for memberData in snapshots.children {
            // 取得したデータをDataSnapshot型に格納
            guard let dataSnapshot = memberData as? DataSnapshot else {
                continue
            }
            // DataSnapshotから辞書型データに変換
            guard let data = dataSnapshot.value as? [String: AnyObject] else {
                // Firebaseデータを辞書型に変換できない場合はエラーとし、離脱
                continue
            }
            // 取得したデータをMemberオブジェクトに変換
            var member = Member()
            // uid
            member.key = dataSnapshot.key
            // 名前
            if let name = data["name"] as? String { member.name = name }
            // フリカナ
            if let kana = data["kana"] as? String { member.kana = kana }
            // 事業部(codeを取得し、codeと事業部名を登録する)
            if let companyCode = data["company"] as? String, let companyName = DataManager.sharedInstance.companyNames[companyCode] {
                member.company = (code: companyCode, name: companyName)
            }
            // 部署(codeを取得し、codeと部署名を登録する)
            if let groupCode = data["group"] as? String, let groupName = DataManager.sharedInstance.groupNames[groupCode] {
                member.group = (code: groupCode, name: groupName)
            }
            // 携帯内線
            if let tel1 = data["internalPhoneNumber"] as? String { member.internalPhoneNumber = tel1 }
            // 外線
            if let tel2 = data["externalPhoneNumber"] as? String { member.externalPhoneNumber = tel2 }
            // 座席内線
            if let tel3 = data["sheetPhoneNumber"] as? String { member.sheetPhoneNumber = tel3 }
            // SMS
            if let sms = data["shortMailAddress"] as? String { member.shortMailAddress = sms }
            // e-Mail
            if let email = data["emailAddress"] as? String { member.emailAddress = email }
            // ステータス
            if let status = data["status"] as? String { member.status = status }

            members.append(member)
        }
        members = members.sorted { $0.kana! < $1.kana! }
        selectedMembers = members
    }

    //メンバーを選択
    public func choiceMember(_ indexPath: IndexPath) {
        self.memberInfo = (selectedMembers[indexPath.row], indexPath.row)
    }

    //メンバー情報を更新
    public func updateMemberData(_ memberInfo: (Member, Int)) {
        self.memberInfo = memberInfo
        self.selectedMembers[memberInfo.1] = memberInfo.0
    }

    //部署選択処理
    public func selectGroupMembers() {
        self.selectedMembers.removeAll()
        //選択されている事業部のkeyを取得する
        let selectedCompanykey = DataManager.sharedInstance.companyInfo.filter { $0.check == "Yes" }.map { $0.key }
        //選択されている部署のkeyを取得する
        let selectedGroupKey = DataManager.sharedInstance.groupInfo.filter { $0.check == "Yes" }.map { $0.key }
        var selectedMember: [String: Member] = [:]
        //選択された事業部
        let companyMember = DataManager.sharedInstance.members.filter {selectedCompanykey.contains(($0.company?.code)!)}
        //
        let groupMember = DataManager.sharedInstance.members.filter { selectedGroupKey.contains(($0.group?.code)!)}

        //事業部
        for member in companyMember {
            selectedMember[member.key!] = member
        }
        for member in groupMember {
            selectedMember[member.key!] = member
        }
        for member in selectedMember {
            self.selectedMembers.append(member.value)
        }
        if self.selectedMembers.count == 0 {
            self.selectedMembers = self.members
        }
    }
}

