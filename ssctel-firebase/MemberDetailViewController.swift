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
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var member: Member!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiInit()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        name.text = member.name
        if member.phoneNumber == nil {
            callButton.isEnabled = false
            callButton.backgroundColor = UIColor.lightGray
        }
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
        guard let tel = member.phoneNumber else {
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
        if segue.identifier == "PushToEdit" {
            guard let registViewController = segue.destination as? MemberRegistViewController else { return }
            registViewController.member = self.member
        }
    }

}

// MARK: - UITableViewDataSource
extension MemberDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}

// MARK: - UITableViewDelegate
extension MemberDetailViewController: UITableViewDelegate {
}
