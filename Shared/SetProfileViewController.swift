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
            "statusMsg" : statusMsgTextField.text ?? "",
            "profileImg" : profileImg.image?.jpegData(compressionQuality: 0.5)?.base64EncodedString()
        ]) { error in
            if error == nil {   // Success
                appDelegate?.myAccount = self.myAccount
                appDelegate?.saveMyAccount()
                self.myAccount?.name = self.nameTextField.text
                self.myAccount?.statusMsg = self.statusMsgTextField.text
                self.myAccount?.profileImg = self.profileImg.image
                
                let pvc = self.presentingViewController
                
                self.presentingViewController?.dismiss(animated: true) {
                    if let tabBarController = self.storyboard?.instantiateViewController(identifier: "tabBarController") {
                        tabBarController.modalPresentationStyle = .fullScreen
                        tabBarController.modalTransitionStyle = .coverVertical
                        pvc?.view.window?.rootViewController = tabBarController
                    }
                }
            } else { // Fail
                self.errorAlert("프로필 설정 도중 문제가 발생했습니다.\n다시 시도해주세요.")
                print(error)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UI init
        profileImg.makeRoundImage()
        profileImg.contentMode = .scaleToFill
        
        nameTextField.placeholder       = "이름을 입력하세요."
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.cornerRadius = 5.0
        
        statusMsgTextField.text               = "상태 메시지를 입력해주세요."
        statusMsgTextField.textColor          = .lightGray
        statusMsgTextField.layer.borderColor  = UIColor.lightGray.cgColor
        statusMsgTextField.layer.borderWidth  = 1.0
        statusMsgTextField.layer.cornerRadius = 5.0
        statusMsgTextField.sizeToFit()
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(selectImg(_:)))
        profileImg.addGestureRecognizer(tapGestureRecognizer)
        
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
    
    @objc func selectImg(_ sender: Any) {
        let imgPicker = UIImagePickerController()
        imgPicker.allowsEditing = true
        imgPicker.delegate = self
        let alert = UIAlertController(title: "프로필 사진 설정", message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "카메라", style: .default) { _ in
            imgPicker.sourceType = .camera
            self.present(imgPicker, animated: true)
        }
        let photoLibrary = UIAlertAction(title: "포토 라이브러리", style: .default) { _ in
            imgPicker.sourceType = .photoLibrary
            self.present(imgPicker, animated: true)
        }
        let savedPhotosAlbum = UIAlertAction(title: "저장된 앨범", style: .default) { _ in
            imgPicker.sourceType = .savedPhotosAlbum
            self.present(imgPicker, animated: true)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(camera)
        alert.addAction(photoLibrary)
        alert.addAction(savedPhotosAlbum)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }

}

extension SetProfileViewController: UITextFieldDelegate {
    
}

extension SetProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel")
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        picker.dismiss(animated: true) {
            if let selectedImg = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.profileImg.image = selectedImg
            }
        }
        
        
    }
}
