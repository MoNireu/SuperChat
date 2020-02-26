//
//  ChatRoomToolBar.swift
//  SuperChat
//
//  Created by MoNireu on 2020/02/26.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit

class ChatRoomToolBar: UIView {

    
    let addBtn = UIButton()
    let textField = UITextField()
    let sendBtn = UIButton()

    let space: CGFloat = 10
    let itemSize: CGFloat = 35
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
//        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addBtn.frame    = CGRect(x: space, y: 0, width: itemSize, height: itemSize)
        addBtn.center.y = self.frame.height / 2
        addBtn.layer.borderWidth = 1
        addBtn.layer.borderColor = UIColor.red.cgColor
        addBtn.layer.cornerRadius = itemSize / 2.7
        self.addSubview(addBtn)
        
        sendBtn.frame    = CGRect(x: self.frame.width - (space + itemSize), y: 0, width: itemSize, height: itemSize)
        sendBtn.center.y = self.frame.height / 2
        sendBtn.layer.borderWidth = 1
        sendBtn.layer.borderColor = UIColor.blue.cgColor
        sendBtn.layer.cornerRadius = itemSize / 2.7
        self.addSubview(sendBtn)
        
        let textFieldX     = addBtn.frame.width + (space * 2)
        let textFieldWidth = sendBtn.frame.minX - space - textFieldX
        
        textField.frame = CGRect(x: textFieldX, y: 0, width: textFieldWidth, height: itemSize)
        textField.center.y = self.frame.height / 2
        textField.font = .systemFont(ofSize: 10)
        textField.placeholder = "메시지를 입력하세요."
        textField.borderStyle = .roundedRect
        self.addSubview(textField)
        
    }
}
