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

    var inputTextField: UITextField? = nil
    var textFields: [String: UITextField] = [:]

    //処理対象メンバー
    var memberInfo: (member: Member, indexPathRow: Int)!

    //更新フラグ
    var updateFlag = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let mem = DataManager.sharedInstance.memberInfo {
            //更新
            //更新フラグ
            updateFlag = true
            saveButton.title = "更新"
            self.memberInfo = mem
            return
        } else {
            //新規
            saveButton.title = "登録"
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
        //戻る
        navigationController?.popViewController(animated: true)
    }

    //Save処理
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {

        //早期離脱
        guard let nameTextField =  textFields[MemberAttributes.name.rawValue], let name = nameTextField.text else {
            return
        }
        if name.characters.count < 1 { return }

        //登録or更新処理
        if updateFlag {
            update()
        } else {
            create()
        }
    }

    //新規登録処理
    private func create() {
        let params = QueryCondition.queryParams(textFieldsData: self.textFields)
        self.ref.child((Auth.auth().currentUser?.uid)!)
            .childByAutoId()
            .setValue(params)
        navigationController?.popViewController(animated: true)
    }

    //更新処理
    private func update() {
        let params = QueryCondition.queryParams(textFieldsData: self.textFields)
        ref.child((Auth.auth().currentUser?.uid)!)
            .child("\(self.memberInfo.member.key!)")
            .updateChildValues(params)
        memberInfo.member.name = self.textFields[MemberAttributes.name.rawValue]?.text ?? "no name"
        DataManager.sharedInstance.updateMemberData(memberInfo)
        navigationController?.popViewController(animated: true)
    }

    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}

// MARK: - UITableViewDataSource
extension MemberRegistViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "PersonalData") as? MemberRegistTableViewCell else {
            return UITableViewCell()
        }
        let atb = attributes[indexPath.row]
        var textField = UITextField()
        textField = cell.inputTextField
        self.textFields[atb.rawValue] = textField

        cell.inputTextField.delegate = self
        cell.selectionStyle = .none
        cell.inputTextField.placeholder = atb.itemName

        //更新の場合
        if updateFlag {
            switch atb {
            case .name:
                cell.inputTextField.text = memberInfo.member.name
            case .kana:
                cell.inputTextField.text = memberInfo.member.kana
            case .company:
                cell.inputTextField.text = memberInfo.member.company?.name
            case .group:
                cell.inputTextField.text = memberInfo.member.group?.name
            case .internalPhoneNumber:
                cell.inputTextField.text = memberInfo.member.internalPhoneNumber
            case .externalPhoneNumber:
                cell.inputTextField.text = memberInfo.member.externalPhoneNumber
            case .sheetPhoneNumber:
                cell.inputTextField.text = memberInfo.member.sheetPhoneNumber
            case .shortMailAddress:
                cell.inputTextField.text = memberInfo.member.shortMailAddress
            case .emailAddress:
                cell.inputTextField.text = memberInfo.member.emailAddress
            }
        } else {
            cell.inputTextField.text = nil
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension MemberRegistTableViewCell: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: - UITextFieldDelegate
extension MemberRegistViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print(textField.text ?? "no data")
        return true
    }
}
