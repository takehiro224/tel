//
//  GroupSelectViewController.swift
//  ssctel-firebase
//
//  Created by tkwatanabe on 2017/07/20.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import UIKit

class GroupSelectViewController: UIViewController {

    //テーブルビュー
    @IBOutlet weak var tableView: UITableView!
    //決定ボタン
    @IBOutlet weak var allSelectButton: UIBarButtonItem!
    //全選択フラグ
    var allSelectFlag = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = true
        allSelectFlag = true
        allSelectButton.title = "全解除"
        DataManager.sharedInstance.clearSelectGroup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - IBAction
    //キャンセルボタンタップ処理
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        allSelectFlag = false
        navigationController?.popViewController(animated: true)
    }

    //全選択ボタンタップ処理
    @IBAction func allSelectButtonTapped(_ sender: UIBarButtonItem) {
        if allSelectFlag {
            for i in 0 ..< DataManager.sharedInstance.companyInfo.count {
                DataManager.sharedInstance.companyInfo[i].check = "No"
            }
            for i in 0 ..< DataManager.sharedInstance.groupInfo.count {
                DataManager.sharedInstance.groupInfo[i].check = "No"
            }
            allSelectFlag = false
            allSelectButton.title = "全選択"
        } else {
            for i in 0 ..< DataManager.sharedInstance.companyInfo.count {
                DataManager.sharedInstance.companyInfo[i].check = "Yes"
            }
            for i in 0 ..< DataManager.sharedInstance.groupInfo.count {
                DataManager.sharedInstance.groupInfo[i].check = "Yes"
            }
            allSelectFlag = true
            allSelectButton.title = "全解除"
        }
        tableView.reloadData()
    }

    //完了ボタンタップ処理
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        DataManager.sharedInstance.selectGroupMembers()
        allSelectFlag = false
        navigationController?.popViewController(animated: true)
    }
}


extension GroupSelectViewController: UITableViewDataSource {

    //セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    //セクションヘッダータイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "事業部"
        } else {
            return "部署"
        }
    }

    //セル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return DataManager.sharedInstance.companyNames.count
        } else {
            return DataManager.sharedInstance.groupNames.count
        }
    }

    //セル内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupSelectItemCell") as! GroupSelectItemTableViewCell
        //共通設定
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            cell.groupNameLabel.text = DataManager.sharedInstance.companyValues[indexPath.row]
            cell.accessoryType = DataManager.sharedInstance.companyInfo[indexPath.row].check == "Yes" ? .checkmark : .none
        } else {
            cell.groupNameLabel.text = DataManager.sharedInstance.groupValues[indexPath.row]
            cell.accessoryType = DataManager.sharedInstance.groupInfo[indexPath.row].check == "Yes" ? .checkmark : .none
        }
        return cell
    }
}

extension GroupSelectViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let check = DataManager.sharedInstance.companyInfo[indexPath.row].check == "Yes" ? "No" : "Yes"
            DataManager.sharedInstance.companyInfo[indexPath.row].check = check
            tableView.cellForRow(at: indexPath)?.accessoryType = check == "Yes" ? .checkmark : .none
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            let check = DataManager.sharedInstance.groupInfo[indexPath.row].check == "Yes" ? "No" : "Yes"
            DataManager.sharedInstance.groupInfo[indexPath.row].check = check
            tableView.cellForRow(at: indexPath)?.accessoryType = check == "Yes" ? .checkmark : .none
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

}
