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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var kana: UILabel!
    @IBOutlet weak var name: UILabel!

    //処理対象メンバー
    var memberInfo: (member: Member, indexPathRow: Int)!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiInit()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //一覧から選択されたデータを取得する
        guard let mem = DataManager.sharedInstance.memberInfo else {
            return
        }
        self.memberInfo = mem
        //名前設定
        name.text = memberInfo.member.name
        //カナ設定
        kana.text = memberInfo.member.kana
        //電話番号設定
        if memberInfo.member.internalPhoneNumber == nil {
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
        self.performSegue(withIdentifier: "PushToEdit", sender: self)
    }

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
    }

    @IBAction func callButtonTapped(_ sender: UIButton) {
        guard let tel = memberInfo.member.internalPhoneNumber else {
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
            cell.itemName.text = MemberAttributes.company.rawValue
            cell.itemValue.text = self.memberInfo.0.company
        case .group:
            cell.itemName.text = MemberAttributes.group.rawValue
            cell.itemValue.text = self.memberInfo.0.group
        case .internalPhoneNumber:
            cell.itemName.text = MemberAttributes.internalPhoneNumber.rawValue
            cell.itemValue.text = self.memberInfo.0.internalPhoneNumber
        case .externalPhoneNumber:
            cell.itemName.text = MemberAttributes.externalPhoneNumber.rawValue
            cell.itemValue.text = self.memberInfo.0.externalPhoneNumber
        case .sheetPhoneNumber:
            cell.itemName.text = MemberAttributes.sheetPhoneNumber.rawValue
            cell.itemValue.text = self.memberInfo.0.sheetPhoneNumber
        case .shortMailAddress:
            cell.itemName.text = MemberAttributes.shortMailAddress.rawValue
            cell.itemValue.text = self.memberInfo.0.shortMailAddress
        case .emailAddress:
            cell.itemName.text = MemberAttributes.emailAddress.rawValue
            cell.itemValue.text = self.memberInfo.0.emailAddress
        default:
            break
        }

        return cell
    }

}

// MARK: - UITableViewDelegate
extension MemberDetailViewController: UITableViewDelegate {
}
