//
//  ViewController.swift
//  ssctel-firebase
//
//  Created by tkwatanabe on 2017/07/12.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import UIKit
import Firebase

class MemberListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    //Databaseのルート
    let ref = Database.database().reference()


    //取得したFirebaseデータ
    var snap: DataSnapshot!

    //メンバー一時保存用
    var member: Member? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        //待ち受け状態にし、変更がある場合は反映する
        self.read()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Cellの高さを調節
//        tableView.estimatedRowHeight = 120
//        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //画面が非表示になった際にデータをクリアする
        ref.removeAllObservers()
        member = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //追加ボタンタップ処理
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toRegister", sender: self)
    }

    //Firebase Databaseからデータを読み込む
    private func read() {
        //eventTypeを「.value」にすることで何かしらの変化があった時に実行される
        ref.child((Auth.auth().currentUser?.uid)!)
            .observe(.value, with: { snapShots in
                if snapShots.children.allObjects is [DataSnapshot] {
                    self.snap = snapShots
                }
                self.reload(snap: self.snap)
            })
    }

    //読み込んだデータを表示する
    private func reload(snap: DataSnapshot) {
        if snap.exists() {
            DataManager.sharedInstance.load(snapshots: snap)
            //ローカルのDBにも反映
            ref.child((Auth.auth().currentUser?.uid)!).keepSynced(true)
            //テーブルのリロード
            self.tableView.reloadData()
        }
    }

    //timestampで保存されている時間を年月日の表示形式に変更する
    func getDate(number: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: number)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: date)
    }

    fileprivate func delete(deleteIndexPath indexPath: IndexPath) {
        //Firebaseデータ削除処理
        ref.child((Auth.auth().currentUser?.uid)!)
            .child(DataManager.sharedInstance.members[indexPath.row].key)
            .removeValue()
        //内部データ削除処理
        DataManager.sharedInstance.members.remove(at: indexPath.row)
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushMemberDetail" {
            //一般
        } else {
            //新規登録
        }
    }
}

//MARK: - UITableViewDataSource
extension MemberListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.sharedInstance.members.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "MemberListItem") as? MemberListTableViewCell else {
            return UITableViewCell()
        }
        //セルに表示するメンバーを取り出す
        let member = DataManager.sharedInstance.members[indexPath.row]
        //名前を取り出す
        cell.name.text = member.name
        return cell
    }
}

//MARK: - UITableViewDelegate
extension MemberListViewController: UITableViewDelegate {

    //セルタップ処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        member = DataManager.sharedInstance.members[indexPath.row]
        DataManager.sharedInstance.choiceMember(indexPath)
        //テーブルの選択状態を解除
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "PushMemberDetail", sender: self)
    }

    //セルの編集可否
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    //削除処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.delete(deleteIndexPath: indexPath)
            self.tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }
    }
}





