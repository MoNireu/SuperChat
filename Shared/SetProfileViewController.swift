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
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UI init
        profileImg.makeRoundImage()
        nameTextField.placeholder = "이름을 입력하세요."
        statusMsgTextField.text = "상태 메시지를 입력해주세요."
        statusMsgTextField.textColor = .lightGray
        statusMsgTextField.layer.borderColor = UIColor.lightGray.cgColor
        statusMsgTextField.layer.borderWidth = 1.0
        statusMsgTextField.layer.cornerRadius = 2
        
        // Data init
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        myAccount = appdelegate?.myAccount
        profileImg.image        = myAccount?.profileImg ?? UIImage(named: "default_user_profile")
        nameTextField.text      = myAccount?.name
        statusMsgTextField.text = myAccount?.statusMsg
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
