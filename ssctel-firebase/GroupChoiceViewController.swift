//
//  GroupChoiceViewController.swift
//  ssctel-firebase
//
//  Created by tkwatanabe on 2017/07/31.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import UIKit

extension Notification.Name {
    public static let changeCompany = Notification.Name("ChangeCompany")
    public static let changeGroup = Notification.Name("ChangeGroup")
}

class GroupChoiceViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!

    //事業部、部署判別フラグ
    var kindFlag = false
    var checkPlace: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = false
        self.navigationItem.title = kindFlag ? "部署選択" : "事業部選択"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - IBAction
    //キャンセルボタンタップ処理
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    //OKボタンタップ処理
    @IBAction func okButtonTapped(_ sender: UIBarButtonItem) {
        if !kindFlag {
            NotificationCenter.default.post(
                name: .changeCompany,
                object: self,
                userInfo: ["choiceData": checkPlace!]
            )
        } else {
            NotificationCenter.default.post(
                name: .changeGroup,
                object: self,
                userInfo: ["choiceData": checkPlace!]
            )
        }
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}

// MARK: - UITableViewDataSource
extension GroupChoiceViewController: UITableViewDataSource {

    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kindFlag == false ? DataManager.sharedInstance.companyKeys.count : DataManager.sharedInstance.groupKeys.count
    }

    // セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // カスタムセルを取得
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupChoiceCell") as? GroupChoiceTableViewCell else {
            return UITableViewCell()
        }
        // 選択できないように
        cell.selectionStyle = .none
        if self.checkPlace! == indexPath.row {
            cell.accessoryType = .checkmark
        }
        if !kindFlag {
            // 事業部の設定
            cell.name = DataManager.sharedInstance.companyValues[indexPath.row]
            return cell
        } else {
            // 部署の設定
            cell.name = DataManager.sharedInstance.groupValues[indexPath.row]
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension GroupChoiceViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for cell in tableView.visibleCells { cell.accessoryType = .none }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        self.checkPlace = indexPath.row
    }
}
