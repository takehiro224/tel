//
//  LoginViewController.swift
//  ssctel-firebase
//
//  Created by tkwatanabe on 2017/07/12.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        emailTextField.keyboardType = .alphabet
        emailTextField.text = "tkwatanabe@shinwart.co.jp"
        passwordTextField.delegate = self
        passwordTextField.text = "tkwatanabe"
        passwordTextField.isSecureTextEntry = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - アプリケーションロジック

    //ログイン失敗処理
    fileprivate func loginFailed() {
        let alert = UIAlertController(title: "失敗", message: "ログインに失敗しました", preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .default, handler: nil)
        )
        self.present(alert, animated: true, completion: nil)
    }

    //ログインボタンタップ処理
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                if let _ = user {
                    self.performSegue(withIdentifier: "toContents", sender: self)
                }
            } else {
                self.loginFailed()
            }
        }
    }

    @IBAction func backToLogin(segue: UIStoryboardSegue) {}

}

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {

    //エンター処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}