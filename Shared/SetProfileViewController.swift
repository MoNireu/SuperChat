//
//  SetProfileViewController.swift
//  SuperChat
//
//  Created by MoNireu on 2020/03/16.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit

class SetProfileViewController: UIViewController {

    
    var myAccount: AccountVO?
    
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var statusMsgTextField: UITextView!
    
    @IBAction func finishSetting(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let userRef = appDelegate?.db?.collection("Users").document(myAccount!.id!)
        userRef?.updateData([
            "name" : nameTextField.text,
            "statusMsg" : statusMsgTextField.text
        ])
        
        let pvc = self.presentingViewController
        
        self.presentingViewController?.dismiss(animated: true) {
            if let tabBarController = self.storyboard?.instantiateViewController(identifier: "tabBarController") {
                tabBarController.modalPresentationStyle = .fullScreen
                tabBarController.modalTransitionStyle = .coverVertical
                pvc?.view.window?.rootViewController = tabBarController
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UI init
        profileImg.makeRoundImage()
        
        nameTextField.placeholder       = "이름을 입력하세요."
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.layer.borderWidth = 1.0
        
        statusMsgTextField.text               = "상태 메시지를 입력해주세요."
        statusMsgTextField.textColor          = .lightGray
        statusMsgTextField.layer.borderColor  = UIColor.lightGray.cgColor
        statusMsgTextField.layer.borderWidth  = 1.0
        statusMsgTextField.layer.cornerRadius = 3
        statusMsgTextField.sizeToFit()
        
        // Data init
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        myAccount = appdelegate?.myAccount
        profileImg.image        = myAccount?.profileImg ?? UIImage(named: "default_user_profile")
        nameTextField.text      = myAccount?.name
        statusMsgTextField.text = myAccount?.statusMsg
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}
