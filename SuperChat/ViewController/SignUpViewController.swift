//
//  SignUpViewController.swift
//  SuperChat
//
//  Created by MoNireu on 2020/03/18.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    let appdelegate = UIApplication.shared.delegate as? AppDelegate
    let defaultDocData = [
        "name" : "",
        "statusMsg" : "",
        "profileImg" : "",
        "backgroundImg" : ""
        ] as [String : Any?]
    
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordCheckTextField: UITextField!
    @IBOutlet var userIdTextField: UITextField!
    
    @IBOutlet var emailWarningLbl: UILabel!
    @IBOutlet var passwordWarningLbl: UILabel!
    @IBOutlet var passwordCheckWarningLbl: UILabel!
    @IBOutlet var userIdWarningLbl: UILabel!
    
    
    @IBOutlet var completeBtn: UIButton!
    @IBAction func complete(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            if error == nil { // success
                // create UID document including userID
                self.appdelegate?.db?.collection("UID").document((result?.user.uid)!).setData(["id" : self.userIdTextField.text!])
                // create Users document including default dictionary data
                self.appdelegate?.db?.collection("Users").document(self.userIdTextField.text!).setData(self.defaultDocData as [String : Any])
                self.infoAlert("회원가입에 성공했습니다.\n다시 로그인 해주세요.") {
                    self.dismiss(animated: true)
                }
            }
            else {
                print(error)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideLabel(emailWarningLbl)
        hideLabel(passwordCheckWarningLbl)
        hideLabel(userIdWarningLbl)
        
        emailTextField.delegate         = self
        passwordTextField.delegate      = self
        passwordCheckTextField.delegate = self
        userIdTextField.delegate        = self
        
        completeBtn.isEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func everyTextFieldFilled() -> Bool {
        if emailTextField.text!.isEmpty {return false}
        if passwordTextField.text!.isEmpty {return false}
        if passwordCheckTextField.text!.isEmpty {return false}
        if userIdTextField.text!.isEmpty {return false}
        
        return true
    }
    
    func everyTextFieldCorrect() -> Bool {
        if !emailWarningLbl.isHidden {return false}
        if passwordTextField.text!.count < 6 {return false}
        if !passwordCheckWarningLbl.isHidden {return false}
        if !userIdWarningLbl.isHidden {return false}
        
        
        return true
    }
    
    func hideLabel(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 10)
        label.sizeToFit()
        label.isHidden = true
    }
    
    func showLabel(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 10)
        label.sizeToFit()
        label.isHidden = false
    }
    
    func warnPassword(_ warn: Bool) {
        if warn {
            passwordWarningLbl.text = "  ⚠️ 비밀번호는 6자 이상으로 설정해주십시오."
            passwordWarningLbl.textColor = .systemRed
        } else {
            passwordWarningLbl.text = "  비밀번호는 6자 이상으로 설정해주십시오."
            passwordWarningLbl.textColor = .systemGray
        }
    }
}


extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if everyTextFieldFilled(), everyTextFieldCorrect() {
            completeBtn.isEnabled = true
        }
        
        switch textField {
        case emailTextField:
            guard !emailTextField.text!.isEmpty else {return}
            Auth.auth().fetchSignInMethods(forEmail: emailTextField.text!) { (result, error) in
                if result == nil { // Email does not exist
                    self.hideLabel(self.emailWarningLbl)
                } else { // Email already exist
                    self.showLabel(self.emailWarningLbl)
                }
            }
        case passwordTextField:
            guard !passwordTextField.text!.isEmpty else {
                warnPassword(false)
                return
            }
            if passwordTextField.text!.count < 6 {
                warnPassword(true)
            } else {
                warnPassword(false)
            }
        case passwordCheckTextField:
            guard !passwordCheckTextField.text!.isEmpty else {hideLabel(passwordCheckWarningLbl); return}
            if passwordTextField.text == passwordCheckTextField.text {
                hideLabel(passwordCheckWarningLbl)
            } else {
                showLabel(passwordCheckWarningLbl)
            }
        case userIdTextField:
            guard !userIdTextField.text!.isEmpty else {hideLabel(userIdWarningLbl); return}
            let docRef = appdelegate?.db?.collection("Users").document(userIdTextField.text!)
            docRef?.getDocument(){ (result, error) in
                if result!.exists { // UserID already exist
                    self.showLabel(self.userIdWarningLbl)
                } else {
                    self.hideLabel(self.userIdWarningLbl)
                }
            }
            
        default:
            return
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            hideLabel(emailWarningLbl)
        case passwordTextField:
            warnPassword(false)
        case passwordCheckTextField:
            hideLabel(passwordCheckWarningLbl)
        case userIdTextField:
            hideLabel(userIdWarningLbl)
        default:
            return
        }
    }
    
}