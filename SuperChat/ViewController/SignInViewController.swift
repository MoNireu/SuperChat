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
    @IBOutlet var actIndicator: UIActivityIndicatorView!
    
    var handle: AuthStateDidChangeListenerHandle?
    var appdelegate = UIApplication.shared.delegate as? AppDelegate
    
    @IBAction func signIn(_ sender: Any) {
        actIndicator.startAnimating()
        let email = emailTextField.text
        let password =  passwordTextField.text
        
        if email != nil && password != nil {
            Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                if user != nil {    // 로그인 성공
                    
                    guard let uid = user?.user.uid else {return}
                    
                    
                    self.getDocumentFrom(uid) {
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actIndicator.hidesWhenStopped = true
        print("SignInViewDidLoad!!!") // TestCode
        emailTextField.text = "coreahr@naver.com" //TestCode
        passwordTextField.text = "123456" // TestCode
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getDocumentFrom(_ uid: String, complete: @escaping () -> ()) {
        let uidRef = self.appdelegate?.db?.collection("UID").document(uid)
        var userID: String?
        uidRef?.getDocument { (document, error) in
            if let document = document, document.exists {
                let result = document.data()
                userID = result?["id"] as? String ?? nil
                self.getUserID(userID!, complete: complete)
            } else {
                self.errorAlert(error as? String)
            }
        }
    }
    
    func getUserID(_ userID: String, complete: @escaping () -> ()) {
        
        guard userID != nil else {return}
        
        let docRef = self.appdelegate?.db?.collection("Users").document(userID)
        
        docRef?.getDocument { (document, error) in
            if let document = document, document.exists {
                
                let result  = document.data()
                let account = AccountVO()
                
                account.id            = userID
                account.email         = result!["email"] as? String
                account.name          = result!["name"] as? String
                account.statusMsg     = result!["statusMsg"] as? String
                account.profileImg    = result!["profileImg"] as? UIImage
                account.backgroundImg = result!["backgroundImg"] as? UIImage
                account.chatRoom      = result!["chatRoom"] as? [String]
                
                self.appdelegate?.myAccount = account
                
                complete()
                
                print(account.email)            // TestCode
                print(account.name)             // TestCode
                print(account.statusMsg)        // TestCode
                print(account.profileImg)       // TestCode
                print(account.backgroundImg)    // TestCode
                print(account.chatRoom)         // TestCode
            } else {
                print("ERROR!")
            }
        }
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

