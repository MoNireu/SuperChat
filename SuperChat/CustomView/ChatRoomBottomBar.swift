//
//  ChatRoomToolBar.swift
//  SuperChat
//
//  Created by MoNireu on 2020/02/26.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit

class ChatRoomBottomBar: UIView, UITextFieldDelegate {

    @IBOutlet var addBtn: UIButton!
    @IBOutlet var messageField: UITextField!
    @IBOutlet var sendBtn: UIButton!
    
    
//
//    override func layoutSubviews() {
//        print("run")
//        messageField.placeholder = "메시지를 입력하세요."
//    }
//
//    func changePH() {
//        messageField.placeholder = "변경"
//        print("change")
//    }
//
    func setup() {
        messageField.placeholder = "메시지를 입력하세요."
        messageField.delegate = self
        addKeyboardNotifications()
    }
    
    
    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            
            if self.superview?.frame.origin.y == 0 {
                self.superview?.frame.origin.y -= keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.superview?.frame.origin.y = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
