//
//  SignInViewController.swift
//  SuperChat
//
//  Created by MoNireu on 2020/03/11.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit
import FirebaseAuth


class SignInViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var signInBtn: UIButton!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var actIndicator: UIActivityIndicatorView!
    
    var handle: AuthStateDidChangeListenerHandle?
    var appdelegate = UIApplication.shared.delegate as? AppDelegate
    let accountUtils = AccountUtils()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actIndicator.hidesWhenStopped = true
        
        emailTextField.delegate    = self
        passwordTextField.delegate = self
        
        emailTextField.clearButtonMode    = .whileEditing
        passwordTextField.clearButtonMode = .whileEditing
        
        signInBtn.makeButtonRound()
        signUpBtn.makeButtonRound()
        
        passwordTextField.text = "000000" // TestCode
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func signIn(_ sender: Any) {
        actIndicator.startAnimating()
        let email = emailTextField.text
        let password =  passwordTextField.text
        
        if email != nil && password != nil {
            Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                if user != nil {    // 로그인 성공
                    
                    guard let uid = user?.user.uid else {return}
                    
                    
                    self.accountUtils.getDocumentFrom(uid) {
                        if let setProfileVC = self.storyboard?.instantiateViewController(identifier: "setProfileViewController") {
                            setProfileVC.modalPresentationStyle = .fullScreen
                            self.actIndicator.stopAnimating()
                            self.present(setProfileVC, animated: true)
                        }
                        
                    }
                } else {            // 로그인 실패
                    print(error) // TestCode
                    self.actIndicator.stopAnimating()
                    self.errorAlert("로그인에 실패했습니다.\n다시 시도해주세요.")
                }
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        if let signUpVC = storyboard?.instantiateViewController(identifier: "signUpViewController") {
            signUpVC.modalPresentationStyle = .automatic
            self.present(signUpVC, animated: true)
        }
    }
    
    
    
//    func getUserID(_ userID: String, complete: @escaping () -> ()) {
//        guard userID != nil else {return}
//
//        let docRef = self.appdelegate?.db?.collection("Users").document(userID)
//
//        docRef?.getDocument { (document, error) in
//            if let document = document, document.exists {
//
//                let result  = document.data()
//                let account = AccountVO()
//
//                account.id            = userID
//                account.email         = result!["email"] as? String
//                account.name          = result!["name"] as? String
//                account.statusMsg     = result!["statusMsg"] as? String
//                if let profileImgString = result!["profileImg"] as? String {
//                    let profileImgData = Data(base64Encoded: profileImgString)
//                    let profileImg = UIImage(data: profileImgData!)
//                    account.profileImg = profileImg
//                }
//                if let backgroundImgString = result!["backgroundImg"] as? String {
//                    let backgroundImgData = Data(base64Encoded: backgroundImgString)
//                    let backgroundImg = UIImage(data: backgroundImgData!)
//                    account.backgroundImg = backgroundImg
//                }
//
//                self.appdelegate?.myAccount = account
//
//                complete()
//
//                print(account.email)            // TestCode
//                print(account.name)             // TestCode
//                print(account.statusMsg)        // TestCode
//                print(account.profileImg)       // TestCode
//                print(account.backgroundImg)    // TestCode
//            } else {
//                print("ERROR!")
//            }
//        }
//    }
}


extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            signIn(self)
        default:
            return false
        }
        return false
    }
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

