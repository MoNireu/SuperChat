//
//  ChatRoomVO.swift
//  SuperChat
//
//  Created by MoNireu on 2020/02/24.
//  Copyright © 2020 monireu. All rights reserved.
//

import Foundation

class ChatRoomVO {
    var name: String?
    var chatRommID: String?
    var isGroupChat: Bool?
    var lastChat: String?
    var lastChatTime: String?
    var member: [AccountVO]?
    var chat: [ChatVO]?
}
