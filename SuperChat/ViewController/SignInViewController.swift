//
//  SignInViewController.swift
//  SuperChat
//
//  Created by MoNireu on 2020/03/11.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit
import FirebaseAuth

enum RegisterStatus: String {
    case signedIn = "로그아웃"
    case signedOut = "로그인"
}


class SignInViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var signInBtn: UIButton!
    
    var handle: AuthStateDidChangeListenerHandle?
    var registerStatus: RegisterStatus?
    var appdelegate = UIApplication.shared.delegate as? AppDelegate
    
    @IBAction func signIn(_ sender: Any) {
        checkRegister()
        
        switch registerStatus {
        case .signedIn:
            try! Auth.auth().signOut()
            print("signed out")
            checkRegister()
        case .signedOut:
            let email = emailTextField.text
            let password =  passwordTextField.text
            
            if email != nil && password != nil {
                Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                    if user != nil {    // 로그인 성공
                        print(user?.user.email)
//                        let uid = user?.user.uid
                        let uid = "monireu"
                        self.getDocumentFrom(uid) {
                            if let setProfileVC = self.storyboard?.instantiateViewController(identifier: "setProfileViewController") as? SetProfileViewController {
                                setProfileVC.modalPresentationStyle = .fullScreen
                                self.present(setProfileVC, animated: true)
                            }
                        }
                    } else {            // 로그인 실패
                        print(error)
                        self.errorAlert("로그인에 실패했습니다.\n다시 로그인해주세요.")
                    }
                    self.checkRegister()
                }
            }
        default:
            return
        }
        checkRegister()
    }
    
    @IBAction func signUp(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkRegister()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
        }
    }
    
    func checkRegister() {
        // Signed In
        if Auth.auth().currentUser != nil {
            registerStatus = .signedIn
            signInBtn.setTitle(registerStatus?.rawValue, for: .normal)
        } else {
            registerStatus = .signedOut
            signInBtn.setTitle(registerStatus?.rawValue, for: .normal)
        }
    }
    
    func getDocumentFrom(_ uid: String, complete: @escaping () -> ()) {
        let docRef = self.appdelegate?.db?.collection("Users").document(uid)
        
        docRef?.getDocument { (document, error) in
            if let document = document, document.exists {
                //                print(document.data())
                let result = document.data()
                let account = AccountVO()
                account.email = result!["email"] as? String
                account.name = result!["name"] as? String
                account.statusMsg = result!["statusMsg"] as? String
                account.profileImg = result!["profileImg"] as? UIImage
                account.backgroundImg = result!["backgroundImg"] as? UIImage
                account.chatRoom = result!["chatRoom"] as? [String]
                
                self.appdelegate?.myAccount = account
                
                complete()
                
                print(account.email)
                print(account.name)
                print(account.statusMsg)
                print(account.profileImg)
                print(account.backgroundImg)
                print(account.chatRoom)
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

