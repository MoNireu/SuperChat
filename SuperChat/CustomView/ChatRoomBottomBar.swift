//
//  ChatRoomToolBar.swift
//  SuperChat
//
//  Created by MoNireu on 2020/02/26.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit

class ChatRoomBottomBar: UIView, UITextViewDelegate {

    @IBOutlet var addBtn: UIButton!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var messageField: UITextView!
    
    weak var delegate: ChatRoomViewController?
    
    var msgHeightConst: NSLayoutConstraint?
    var oldMsgHeight: CGFloat?
    
    var newBarY: CGFloat?
    var oldBarY: CGFloat?
    var barYInterval: CGFloat?
    
    
    func setup() {
        messageField.delegate = self
        messageField.heightAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
        addKeyboardNotifications()
        messageField.translatesAutoresizingMaskIntoConstraints = false
        messageField.sizeToFit()
        messageField.isScrollEnabled = false
        msgHeightConst = messageField.heightAnchor.constraint(equalToConstant: 33)
        msgHeightConst!.isActive = true
    }
    
    override func layoutIfNeeded() {
        newBarY = self.frame.origin.y
        print("newBarY set")
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
                self.superview?.frame.origin.y -= keyboardHeight - (delegate?.emptyBar.frame.height)!
                oldBarY = self.frame.origin.y
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.superview?.frame.origin.y = 0
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        print(delegate?.tableView.contentOffset)
        changeTextViewHeight()
//        delegate?.scrollToBottom(animate: true)
//        delegate?.view.frame.origin.y  //TestCode
    }
    
    func changeTextViewHeight() {
        
        let fixedWidth = messageField.frame.width
        let newMsgSize = messageField.sizeThatFits(CGSize(width: fixedWidth, height: 100))
        
        let barWidth = self.frame.width
        
        guard newMsgSize.height < 100  else {
            self.messageField.isScrollEnabled = true
            print("scroll Enable")
            return
        }
        
        self.messageField.isScrollEnabled = false
        print("scroll Disable")
        
        
        //            self.msgHeightConst?.isActive = false
        //            self.msgHeightConst = self.messageField.heightAnchor.constraint(equalToConstant: newMsgSize.height)
        self.msgHeightConst?.constant = newMsgSize.height
        //            self.msgHeightConst?.isActive = true
        self.layoutIfNeeded()
//
        print("Old \(oldBarY) / New \(newBarY)")
        let barYInterval = oldBarY! - newBarY!
//        print("Interval : \(barYInterval)")
//        delegate?.tableView.frame.origin.y -= barYInterval
//        delegate?.tableView.contentOffset.y -= barYInterval
//        oldBarY = newBarY
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("End")
        self.messageField.isScrollEnabled = true
    }
    
    func textViewShouldReturn(_ textField: UITextField) -> Bool {
        print(messageField.frame.height)
        return true
    }
}
