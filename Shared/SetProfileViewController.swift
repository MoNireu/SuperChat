//
//  SetProfileViewController.swift
//  SuperChat
//
//  Created by MoNireu on 2020/03/16.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit
import FirebaseAuth

class SetProfileViewController: UIViewController {

    
    var myAccount: MyAccountVO?
    let CHAR_LIMIT = 30
    let STATUS_MSG_PLACEHOLDER = "상태 메시지를 입력하세요."
    
    @IBOutlet var profileImgView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var statusMsgTextField: UITextView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var finishBtn: UIButton!
    @IBOutlet var charCountLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addKeyboardNotifications()
        
        // UI init
        profileImgView.makeImageRound()
        profileImgView.contentMode = .scaleAspectFill
        
        nameTextField.placeholder       = "이름을 입력하세요."
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.cornerRadius = 5.0
        
        statusMsgTextField.textColor          = .lightGray
        statusMsgTextField.layer.borderColor  = UIColor.lightGray.cgColor
        statusMsgTextField.delegate           = self
        statusMsgTextField.layer.borderWidth  = 1.0
        statusMsgTextField.layer.cornerRadius = 5.0
        statusMsgTextField.sizeToFit()
        
        finishBtn.layer.cornerRadius = finishBtn.frame.height / 2
        finishBtn.backgroundColor = .systemBlue
        finishBtn.setTitleColor(.white, for: .normal)
        
        activityIndicator.stopAnimating()
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(selectImg(_:)))
        profileImgView.addGestureRecognizer(tapGestureRecognizer)
        
        // Data init
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        myAccount = appdelegate?.myAccount
        profileImgView.image    = strDataToImg(strData: (myAccount?.profileImg)!)
        nameTextField.text      = myAccount?.name
        statusMsgTextField.text = myAccount?.statusMsg
        if statusMsgTextField.text.isEmpty {
            statusMsgTextField.text = STATUS_MSG_PLACEHOLDER
            charCountLbl.text = "0/\(CHAR_LIMIT)"
        }
        else {
            charCountLbl.text = "\(statusMsgTextField.text.count)/\(CHAR_LIMIT)"
        }
        charCountLbl.textColor = .systemGray
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let error {
            errorAlert(error.localizedDescription)
        }
        
        self.dismiss(animated: true)
    }
    
    @IBAction func finish(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let userDefaultsUtils = UserDefaultsUtils()
        
        activityIndicator.startAnimating()
        
        var profileImg: UIImage?
        if profileImgView.image == UIImage(named: "default_user_profile") {
            print("default Image!")
            profileImg = nil
        }
        else {
            profileImg = profileImgView.image
        }
        
        print(profileImg)
        print(UIImage(named: "default_user_profile"))
        
//        let dateFormat = DateFormatter().dateFormat
//        dateFormat = "yyyyMMdd"
        print(Date())
        
        let userRef = appDelegate?.db?.collection("Users").document(myAccount!.id!)
        userRef?.updateData([
            "name" : nameTextField.text!,
            "statusMsg" : statusMsgTextField.text ?? "",
            "profileImg" : profileImg?.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? "",
            "latestUpdate" : Date()
        ]) { error in
            if error == nil {   // Success
                
                self.myAccount?.name       = self.nameTextField.text
                self.myAccount?.statusMsg  = self.statusMsgTextField.text
                self.myAccount?.profileImg = self.getImgStringDataFrom(img: self.profileImgView.image!)
                
                appDelegate?.myAccount = self.myAccount
                userDefaultsUtils.saveMyAccount()
                
                self.activityIndicator.stopAnimating()
                
                let pvc = self.presentingViewController
                
                self.presentingViewController?.dismiss(animated: true) {
                    if let tabBarController = self.storyboard?.instantiateViewController(identifier: "tabBarController") {
                        tabBarController.modalPresentationStyle = .fullScreen
                        tabBarController.modalTransitionStyle = .coverVertical
                        pvc?.view.window?.rootViewController = tabBarController
                    }
                }
            } else { // Fail
                self.activityIndicator.stopAnimating()
                self.errorAlert("프로필 설정 도중 문제가 발생했습니다.\n다시 시도해주세요.")
                print(error)
            }
        }
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
    
    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            
            if self.view.frame.origin.y == 0 {
                guard statusMsgTextField.isFirstResponder else {return}
                
                let keyboardY = self.view.frame.height - keyboardHeight - 20
                let activatedTVBottom = (statusMsgTextField?.frame.origin.y)! + (statusMsgTextField?.frame.height)!
                let interval = keyboardY - activatedTVBottom
                
                print(keyboardY)
                print(activatedTVBottom)
                print(interval)
                
                if  interval > 0 {
                    return
                }
                else {
                    self.view.frame.origin.y += interval
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    

}

extension SetProfileViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentCharCount = textView.text.count + (text.count - range.length)
        charCountLbl.text = "\(currentCharCount)/\(CHAR_LIMIT)"
        charCountLbl.sizeToFit()
        
        charCountLbl.textColor = (currentCharCount < CHAR_LIMIT) ? .systemGray : .systemRed
        
        return currentCharCount < CHAR_LIMIT
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == STATUS_MSG_PLACEHOLDER {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = STATUS_MSG_PLACEHOLDER
        }
    }
}

extension SetProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel")
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        picker.dismiss(animated: true) {
            if let selectedImg = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.profileImgView.image = selectedImg
            }
        }
        
        
    }
}
