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

    public static func queryParams(textFieldsData: [String: UITextField]) -> [AnyHashable : Any] {
        var params = [AnyHashable : Any]()
        //user
        params["user"] = (Auth.auth().currentUser?.uid)!
        //氏名
        if let name = textFieldsData[MemberAttributes.name.rawValue]?.text {
            params["name"] = name
        }
        //フリカナ
        if let kana = textFieldsData[MemberAttributes.kana.rawValue]?.text {
            params["kana"] = kana
        }
        //事業部
        if let company = textFieldsData[MemberAttributes.company.rawValue]?.text {
            params["company"] = company
        }
        //部署
        if let group = textFieldsData[MemberAttributes.group.rawValue]?.text {
            params["group"] = group
        }
        //携帯内線番号
        if let internalPhoneNumber = textFieldsData[MemberAttributes.internalPhoneNumber.rawValue]?.text {
            params["internalPhoneNumber"] = internalPhoneNumber
        }
        //外線番号
        if let externalPhoneNumber = textFieldsData[MemberAttributes.externalPhoneNumber.rawValue]?.text {
            params["externalPhoneNumber"] = externalPhoneNumber
        }
        //座席内線番号
        if let sheetPhoneNumber = textFieldsData[MemberAttributes.sheetPhoneNumber.rawValue]?.text {
            params["sheetPhoneNumber"] = sheetPhoneNumber
        }
        //SMS
        if let shortMailAddress = textFieldsData[MemberAttributes.shortMailAddress.rawValue]?.text {
            params["shortMailAddress"] = shortMailAddress
        }
        //E-Mail
        if let emailAddress = textFieldsData[MemberAttributes.emailAddress.rawValue]?.text {
            params["emailAddress"] = emailAddress
        }
        params["date"] = ServerValue.timestamp()

        return params
    }
}
