//
//  MemberDetailViewController.swift
//  ssctel-firebase
//
//  Created by tkwatanabe on 2017/07/14.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import UIKit
import Firebase

class MemberDetailViewController: UIViewController {

    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var call2Button: UIButton!
    @IBOutlet weak var call3Button: UIButton!
    @IBOutlet weak var smsButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var kana: UILabel!
    @IBOutlet weak var name: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiInit()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //一覧から選択されたデータを取得する
        guard let _ = DataManager.sharedInstance.memberInfo else {
            return
        }
        // 画像設定
        photo.image = DataManager.sharedInstance.memberInfo!.member.image
        //名前設定
        name.text = DataManager.sharedInstance.memberInfo!.member.name
        //カナ設定
        kana.text = DataManager.sharedInstance.memberInfo!.member.kana
        //電話番号設定
        if DataManager.sharedInstance.memberInfo!.member.internalPhoneNumber == nil || DataManager.sharedInstance.memberInfo!.member.internalPhoneNumber!.characters.count < 1 {
            callButton.isEnabled = false
            callButton.backgroundColor = UIColor.lightGray
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - IBAction
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        //戻る
        navigationController?.popViewController(animated: true)
    }

    // 編集ボタンタップ時処理(管理者権限)
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        //self.performSegue(withIdentifier: "PushConfigToEdit", sender: self)
    }

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
    }

    @IBAction func callButtonTapped(_ sender: UIButton) {
        guard let tel = DataManager.sharedInstance.memberInfo!.member.internalPhoneNumber else {
            return
        }
        let url = NSURL(string: "tel://\(tel)")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url as URL)
        } else {
            UIApplication.shared.openURL(url as URL)
        }
    }

    // MARK: - Application Logic
    private func uiInit() {
        photo.image = UIImage(named: "woman")
        photo.layer.borderColor = UIColor.lightGray.cgColor
        photo.layer.borderWidth = 1
        name.layer.cornerRadius = 5
        favoriteButton.layer.cornerRadius = 5
        callButton.layer.cornerRadius = 5
        call2Button.layer.cornerRadius = 5
        call3Button.layer.cornerRadius = 5
        smsButton.layer.cornerRadius = 5
        emailButton.layer.cornerRadius = 5
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}

// MARK: - UITableViewDataSource
extension MemberDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes.count - 2 //氏名、カナを省く為
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberDetailItem") as! MemberDetailTableViewCell
        let attribute = attributes[indexPath.row + 2] //氏名、カナを省く為
        switch attribute {
        case .company:
            cell.itemName.text = MemberAttributes.company.itemName
            cell.itemValue.text = DataManager.sharedInstance.memberInfo!.0.company?.name
        case .group:
            cell.itemName.text = MemberAttributes.group.itemName
            cell.itemValue.text = DataManager.sharedInstance.memberInfo!.0.group?.name
        case .internalPhoneNumber:
            cell.itemName.text = MemberAttributes.internalPhoneNumber.itemName
            cell.itemValue.text = DataManager.sharedInstance.memberInfo!.0.internalPhoneNumber
        case .externalPhoneNumber:
            cell.itemName.text = MemberAttributes.externalPhoneNumber.itemName
            cell.itemValue.text = DataManager.sharedInstance.memberInfo!.0.externalPhoneNumber
        case .sheetPhoneNumber:
            cell.itemName.text = MemberAttributes.sheetPhoneNumber.itemName
            cell.itemValue.text = DataManager.sharedInstance.memberInfo!.0.sheetPhoneNumber
        case .shortMailAddress:
            cell.itemName.text = MemberAttributes.shortMailAddress.itemName
            cell.itemValue.text = DataManager.sharedInstance.memberInfo!.0.shortMailAddress
        case .emailAddress:
            cell.itemName.text = MemberAttributes.emailAddress.itemName
            cell.itemValue.text = DataManager.sharedInstance.memberInfo!.0.emailAddress
        default:
            break
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MemberDetailViewController: UITableViewDelegate {
}
