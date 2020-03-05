//
//  ChatDummyData.swift
//  SuperChat
//
//  Created by MoNireu on 2020/02/27.
//  Copyright © 2020 monireu. All rights reserved.
//

import Foundation


class ChatDummyData {
    var data = { () -> [ChatVO] in 
        var chatList = [ChatVO]()
        
        
        
        let chat002 = ChatVO()
        chat002.sender = "00010"
        chat002.content = "ㅇㅇ?"
        chat002.time = "10:29"
        chatList.append(chat002)
        
        let chat003 = ChatVO()
        chat003.sender = "00000"
        chat003.content = "이거 뭔가 허전해보이지 않니"
        chat003.time = "10:30"
        chatList.append(chat003)
        
        let chat004 = ChatVO()
        chat004.sender = "00010"
        chat004.content = "???"
        chat004.time = "10:30"
        chatList.append(chat004)
        
        let chat005 = ChatVO()
        chat005.sender = "00000"
        chat005.content = "말풍선 좀..."
        chat005.time = "10:31"
        chatList.append(chat005)
        
        let chat006 = ChatVO()
        chat006.sender = "00010"
        chat006.content = "ㅇㅋㅇㅋ"
        chat006.time = "10:32"
        chatList.append(chat006)
        
        let chat007 = ChatVO()
        chat007.sender = "00010"
        chat007.content = "ㄱㄷ"
        chat007.time = "10:32"
        chatList.append(chat007)
        
        let chat008 = ChatVO()
        chat008.sender = "00000"
        chat008.content = "나의 계절 아이즈원 영원토록 피에스타. 나의 계절 아이즈원 영원토록 피에스타. 나의 계절 아이즈원 영원토록 피에스타. 나의 계절 아이즈원 영원토록 피에스타."
        chat008.time = "10:39"
        chatList.append(chat008)
        
        let chat009 = ChatVO()
        chat009.sender = "00010"
        chat009.content = "이것은 내가 전송한 텍스트입니다. 이것은 내가 전송한 텍스트입니다.이것은 내가 전송한 텍스트입니다.이것은 내가 전송한 텍스트입니다.이것은 내가 전송한 텍스트입니다."
        chat009.time = "10:39"
        chatList.append(chat009)
        
        let chat010 = ChatVO()
        chat010.sender = "00010"
        chat010.content = "이것은 내가 전송한 텍스트입니다. 이것은 내가 전송한 텍스트입니다.이것은 내가 전송한 텍스트입니다.이것은 내가 전송한 텍스트입니다.이것은 내가 전송한 텍스트입니다."
        chat010.time = "10:39"
        chatList.append(chat010)
        
        let chat011 = ChatVO()
        chat011.sender = "00000"
        chat011.content = "나의 계절 아이즈원 영원토록 피에스타. 나의 계절 아이즈원 영원토록 피에스타. 나의 계절 아이즈원 영원토록 피에스타. 나의 계절 아이즈원 영원토록 피에스타."
        chat011.time = "10:39"
        chatList.append(chat011)
        
        let chat001 = ChatVO()
        chat001.sender = "00000"
        chat001.content = "동환아"
        chat001.time = "10:00"
        chatList.append(chat001)
        
        return chatList
    }
}
