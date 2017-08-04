//
//  ConfigViewController.swift
//  ssctel-firebase
//
//  Created by tkwatanabe on 2017/07/13.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ConfigViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noButton: UIBarButtonItem!
    @IBOutlet weak var yesButton: UIBarButtonItem!

    var textFields: [UITextField]? = nil

    var observers = [NSObjectProtocol]()

    var companyData: (String, String)? = nil
    var groupData: (String, String)? = nil

    var testData: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.cornerRadius = 5
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 50
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = UIColor.white.cgColor
        tableView.bounces = false

        // 画面タップ時の処理を追加
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(self.onTap(_:)))
        self.view.addGestureRecognizer(tapGesture)

        // 画像を格納
        self.profileImage.image = DataManager.sharedInstance.loginUser?.image

        //
        self.companyData = (DataManager.sharedInstance.loginUser!.company!.code, DataManager.sharedInstance.loginUser!.company!.name)
        self.groupData = (DataManager.sharedInstance.loginUser!.group!.code, DataManager.sharedInstance.loginUser!.group!.name)
        testData = DataManager.sharedInstance.loginUser?.name
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.observers.append(NotificationCenter.default.addObserver(
            forName: .changeCompany,
            object: nil,
            queue: nil) { notification -> Void in
                guard let userInfo = notification.userInfo as? [String: Int], let choiceData = userInfo["choiceData"] else {
                    return
                }
                self.companyData = (String(choiceData), DataManager.sharedInstance.companyValues[choiceData])
                self.tableView.reloadData()
        })

        self.observers.append(NotificationCenter.default.addObserver(
            forName: .changeGroup,
            object: nil,
            queue: nil) { notification -> Void in
                guard let userInfo = notification.userInfo as? [String: Int], let choiceData = userInfo["choiceData"] else {
                    return
                }
                self.groupData = (String(choiceData), DataManager.sharedInstance.groupValues[choiceData])
                self.tableView.reloadData()
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
//        let nc = NotificationCenter.default
//        super.viewWillDisappear(animated)
//        print("view will disppear")
//        for observer in observers {
//            nc.removeObserver(observer)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    // MARK: - IBAction
    @IBAction func noButtonTapped(_ sender: UIBarButtonItem) {
        // 更新 入力前の状態に戻す
        testData = DataManager.sharedInstance.loginUser?.name
        self.companyData = (DataManager.sharedInstance.loginUser!.company!.code, DataManager.sharedInstance.loginUser!.company!.name)
        self.groupData = (DataManager.sharedInstance.loginUser!.group!.code, DataManager.sharedInstance.loginUser!.group!.name)
        self.tableView.reloadData()
        // TODO: 新規
        // TODO: 編集
    }

    @IBAction func yesButtonTapped(_ sender: UIBarButtonItem) {
        // TODO: 更新 入力した内容で更新をかける
        self.update()
        // TODO: 新規
        // TODO: 編集

    }

    // 画面タップ時処理
    func onTap(_ tapTestureRecognizer: UITapGestureRecognizer) {
        // キーボード以外をタップした際にキーボードを閉じる処理
        self.view.endEditing(true)
    }

    private func update() {
        let cells = tableView.visibleCells.map { $0 as? ConfigTableViewCell }
        for cell in cells {
            print(cell?.profileData.text ?? "no data")
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! GroupChoiceViewController
        if segue.identifier == "PushToChoiceCompany" {
            viewController.kindFlag = false
            viewController.checkPlace = Int(self.companyData!.0)
        } else if segue.identifier == "PushToChoiceGroup" {
            viewController.kindFlag = true
            viewController.checkPlace = Int(self.groupData!.0)
        }
        // ログアウト処理
//        do {
//            try Auth.auth().signOut()
//        } catch let error as NSError {
//            print("\(error.localizedDescription)")
//        }
    }

}

extension ConfigViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileItemCell") as! ConfigTableViewCell
        // TODO: アイコン設定
        cell.iconView.image = UIImage(named: "woman")
        // TODO: TextField設定
        cell.profileData.delegate = self
        //事業部、部署は遷移して選択するためタップを許可
        if attributes[indexPath.row] != .company && attributes[indexPath.row] != .group {
            cell.selectionStyle = .none
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        // TextFieldのPlacefolder設定
        cell.profileData.placeholder = attributes[indexPath.row].itemName
        // TextFieldのタグ付け
        cell.profileData.tag = attributes[indexPath.row].itemNumber
        // TextFieldの値を設定
        switch attributes[indexPath.row].itemNumber {
        case 0:
            cell.profileData.text = testData
        case 1:
            cell.profileData.text = DataManager.sharedInstance.loginUser?.kana
        case 2:
            cell.profileData.text = self.companyData?.1
        case 3:
            cell.profileData.text = self.groupData?.1
        case 4:
            cell.profileData.text = DataManager.sharedInstance.loginUser?.internalPhoneNumber
        case 5:
            cell.profileData.text = DataManager.sharedInstance.loginUser?.externalPhoneNumber
        case 6:
            cell.profileData.text = DataManager.sharedInstance.loginUser?.sheetPhoneNumber
        case 7:
            cell.profileData.text = DataManager.sharedInstance.loginUser?.shortMailAddress
        case 8:
            cell.profileData.text = DataManager.sharedInstance.loginUser?.emailAddress
        default:
            break
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ConfigViewController: UITableViewDelegate {
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    // セルタップ時処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: - UITextFieldDelegate
extension ConfigViewController: UITextFieldDelegate {

    //TextFieldで「検索」ボタンがタップされた時に実行されるメソッド
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //TextFieldの編集状態を終了し、キーボードを隠す処理
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField.tag == 0 {
            testData = textField.text
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 2 {
            print("事業部選択画面へ")
            performSegue(withIdentifier: "PushToChoiceCompany", sender: self)
            return false
        } else if textField.tag == 3 {
            print("部署選択画面へ")
            performSegue(withIdentifier: "PushToChoiceGroup", sender: self)
            return false
        }
        return true
    }
}
