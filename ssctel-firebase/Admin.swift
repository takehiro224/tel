//
//  Admin.swift
//  ssctel-firebase
//
//  Created by tkwatanabe on 2017/07/19.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import Foundation
import UIKit
import Firebase

public struct QueryCondition {

    public static func queryParams() -> [AnyHashable : Any] {
        var params = [AnyHashable : Any]()
        //user
        params["user"] = (Auth.auth().currentUser?.uid)!
        //氏名
        if let name = DataManager.sharedInstance.memberInfo?.member.name {
            params["name"] = name
        }
        //フリカナ
        if let kana = DataManager.sharedInstance.memberInfo?.member.kana {
            params["kana"] = kana
        }
        //事業部
        if let company = DataManager.sharedInstance.memberInfo?.member.company {
            params["company"] = company.code
        }
        //部署
        if let group = DataManager.sharedInstance.memberInfo?.member.group {
            params["group"] = group.code
        }
        //携帯内線番号
        if let internalPhoneNumber = DataManager.sharedInstance.memberInfo?.member.internalPhoneNumber {
            params["internalPhoneNumber"] = internalPhoneNumber
        }
        //外線番号
        if let externalPhoneNumber = DataManager.sharedInstance.memberInfo?.member.externalPhoneNumber {
            params["externalPhoneNumber"] = externalPhoneNumber
        }
        //座席内線番号
        if let sheetPhoneNumber = DataManager.sharedInstance.memberInfo?.member.sheetPhoneNumber {
            params["sheetPhoneNumber"] = sheetPhoneNumber
        }
        //SMS
        if let shortMailAddress = DataManager.sharedInstance.memberInfo?.member.shortMailAddress {
            params["shortMailAddress"] = shortMailAddress
        }
        //E-Mail
        if let emailAddress = DataManager.sharedInstance.memberInfo?.member.emailAddress {
            params["emailAddress"] = emailAddress
        }
        params["date"] = ServerValue.timestamp()

        return params
    }
}
