//
//  MemberRegistViewController.swift
//  ssctel-firebase
//
//  Created by tkwatanabe on 2017/07/12.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import UIKit
import Firebase

class MemberRegistViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    let ref = Database.database().reference()

    // 更新フラグ
    var updateFlag = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let _ = DataManager.sharedInstance.memberInfo {
            //更新
            updateFlag = true
            saveButton.title = "更新"
            return
        } else {
            //新規
            saveButton.title = "登録"
            DataManager.sharedInstance.memberInfo = (member: Member(), indexPathRow: 0)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //キャンセルボタンタップ処理
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        //選択を解除
        DataManager.sharedInstance.unSelectCompany()
        DataManager.sharedInstance.unSelectGroup()
        //戻る
        navigationController?.popViewController(animated: true)
    }

    //Save処理
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {

        // TODO: 名前が未入力の場合は早期離脱

        //登録or更新処理
        if updateFlag {
            update()
        } else {
            create()
        }
        //選択を解除
        DataManager.sharedInstance.unSelectCompany()
        DataManager.sharedInstance.unSelectGroup()
    }

    //新規登録処理
    private func create() {
        let params = QueryCondition.queryParams()
        self.ref.child((Auth.auth().currentUser?.uid)!)
            .childByAutoId()
            .setValue(params)
        navigationController?.popViewController(animated: true)
    }

    //更新処理
    private func update() {
        let params = QueryCondition.queryParams()
        ref.child((Auth.auth().currentUser?.uid)!)
            .child("\(DataManager.sharedInstance.memberInfo!.member.key!)")
            .updateChildValues(params)
        DataManager.sharedInstance.updateMemberData(DataManager.sharedInstance.memberInfo!)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? GroupChoiceViewController else {
            return
        }
        if segue.identifier == "PushSelectCompany" {
            viewController.kindFlag = false
        } else {
            viewController.kindFlag = true
        }
    }
}

// MARK: - UITableViewDataSource
extension MemberRegistViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //メンバー登録用セルを取得
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "PersonalData") as? MemberRegistTableViewCell else {
            return UITableViewCell()
        }
        //列の設定
        let atb = attributes[indexPath.row]
        cell.inputTextField.tag = atb.itemNumber

        //事業部、部署は遷移して選択するためタップを許可
        if attributes[indexPath.row] != .company && attributes[indexPath.row] != .group {
            cell.selectionStyle = .none
            cell.inputTextField.delegate = self
        } else {
            cell.inputTextField.isEnabled = false
        }
        cell.inputTextField.placeholder = atb.itemName

        switch atb {
        case .name:
            cell.inputTextField.text = DataManager.sharedInstance.memberInfo!.member.name
        case .kana:
            cell.inputTextField.text = DataManager.sharedInstance.memberInfo!.member.kana
        case .company:
            cell.inputTextField.text = DataManager.sharedInstance.memberInfo!.member.company?.name
        case .group:
            cell.inputTextField.text = DataManager.sharedInstance.memberInfo!.member.group?.name
        case .internalPhoneNumber:
            cell.inputTextField.text = DataManager.sharedInstance.memberInfo!.member.internalPhoneNumber
        case .externalPhoneNumber:
            cell.inputTextField.text = DataManager.sharedInstance.memberInfo!.member.externalPhoneNumber
        case .sheetPhoneNumber:
            cell.inputTextField.text = DataManager.sharedInstance.memberInfo!.member.sheetPhoneNumber
        case .shortMailAddress:
            cell.inputTextField.text = DataManager.sharedInstance.memberInfo!.member.shortMailAddress
        case .emailAddress:
            cell.inputTextField.text = DataManager.sharedInstance.memberInfo!.member.emailAddress
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MemberRegistViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if attributes[indexPath.row] == .company {
            self.performSegue(withIdentifier: "PushSelectCompany", sender: self)
        } else if attributes[indexPath.row] == .group {
            self.performSegue(withIdentifier: "PushSelectGroup", sender: self)
        }
    }
}

// MARK: - UITextFieldDelegate
extension MemberRegistViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField.tag {
        case 0:
            DataManager.sharedInstance.memberInfo!.member.name = textField.text
        case 1:
            DataManager.sharedInstance.memberInfo!.member.kana = textField.text
        case 2:
            //DataManager.sharedInstance.memberInfo!.member.name = textField.text
            break
        case 3:
            //DataManager.sharedInstance.memberInfo!.member.name = textField.text
            break
        case 4:
            DataManager.sharedInstance.memberInfo!.member.internalPhoneNumber = textField.text
        case 5:
            DataManager.sharedInstance.memberInfo!.member.externalPhoneNumber = textField.text
        case 6:
            DataManager.sharedInstance.memberInfo!.member.sheetPhoneNumber = textField.text
        case 7:
            DataManager.sharedInstance.memberInfo!.member.shortMailAddress = textField.text
        case 8:
            DataManager.sharedInstance.memberInfo!.member.emailAddress = textField.text
        default:
            break
        }
        return true
    }
}

extension MemberRegistViewController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    }
}

