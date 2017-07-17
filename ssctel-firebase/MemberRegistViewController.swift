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

    var nameTextField: UITextField? = nil

    //処理対象メンバー
    var memberInfo: (member: Member, indexPathRow: Int)!

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
        guard let name = nameTextField?.text else { return }
        if name.characters.count < 1 { return }

        //登録or更新処理
        if updateFlag {
            update()
        } else {
            create()
        }
    }

    private func create() {
        //新規登録
        self.ref.child((Auth.auth().currentUser?.uid)!)
            .childByAutoId()
            .setValue(["user": (Auth.auth().currentUser?.uid)!,"name": nameTextField!.text!, "date": ServerValue.timestamp()])
                navigationController?.popViewController(animated: true)
    }

    private func update() {
        ref.child((Auth.auth().currentUser?.uid)!)
            .child("\(self.memberInfo.member.key)")
            .updateChildValues([
                "user": (Auth.auth().currentUser?.uid)!,
                "name": nameTextField!.text!,
                "date": ServerValue.timestamp()
                ])
        memberInfo.member.name = (self.nameTextField?.text)!
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
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "PersonalData") as? MemberRegistTableViewCell else {
            return UITableViewCell()
        }
        self.nameTextField = cell.nameTextField
        cell.nameTextField.delegate = self
        cell.selectionStyle = .none

        cell.nameTextField.text = memberInfo.member.name
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
        return true
    }
}
