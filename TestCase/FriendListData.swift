//
//  FriendListData.swift
//  SuperChat
//
//  Created by MoNireu on 2020/02/24.
//  Copyright © 2020 monireu. All rights reserved.
//

import Foundation
import UIKit

class FriendListData {
    var data = { () -> [AccountVO] in
        var list = [AccountVO]()
        
        
        let friend1 = AccountVO()
        friend1.id = "00013"
        friend1.name = "김동환"
        friend1.profileImg = nil
        friend1.statusMsg = "나는 대학의 노예다."
        list.append(friend1)
        
        let friend2 = AccountVO()
        friend2.id = "00014"
        friend2.name = "이원준"
        friend2.profileImg = nil
        friend2.statusMsg = "훈련소 ㅈ같다."
        list.append(friend2)
        
        let friend3 = AccountVO()
        friend3.id = "00015"
        friend3.name = "신동규"
        friend3.profileImg = UIImage(named: "DongDong.JPG")
        friend3.statusMsg = "딱대 ^^!바!"
        list.append(friend3)
        
        let izone1 = AccountVO()
        izone1.id = "00001"
        izone1.name = "권은비"
        izone1.profileImg = UIImage(named: "Eunbi.png")
        izone1.statusMsg = nil
        list.append(izone1)
        
        let izone2 = AccountVO()
        izone2.id = "00002"
        izone2.name = "사쿠라"
        izone2.profileImg = UIImage(named: "Sakura.png")
        izone2.statusMsg = nil
        list.append(izone2)
        
        let izone3 = AccountVO()
        izone3.id = "00003"
        izone3.name = "강혜원"
        izone3.profileImg = UIImage(named: "HaeWon.png")
        izone3.statusMsg = nil
        list.append(izone3)
        
        let izone4 = AccountVO()
        izone4.id = "00004"
        izone4.name = "최예나"
        izone4.profileImg = UIImage(named: "YeNa.png")
        izone4.statusMsg = "꽥꽥"
        list.append(izone4)
        
        let izone5 = AccountVO()
        izone5.id = "00005"
        izone5.name = "이채연"
        izone5.profileImg = UIImage(named: "ChaeYon.png")
        izone5.statusMsg = nil
        list.append(izone5)
        
        let izone6 = AccountVO()
        izone6.id = "00006"
        izone6.name = "김채원"
        izone6.profileImg = UIImage(named: "ChaeWon.png")
        izone6.statusMsg = nil
        list.append(izone6)
        
        let izone7 = AccountVO()
        izone7.id = "00007"
        izone7.name = "김민주"
        izone7.profileImg = UIImage(named: ".png")
        izone7.statusMsg = nil
        list.append(izone7)
        
        let izone8 = AccountVO()
        izone8.id = "00008"
        izone8.name = "야부키 나코"
        izone8.profileImg = UIImage(named: "Nako.png")
        izone8.statusMsg = nil
        list.append(izone8)
        
        let izone9 = AccountVO()
        izone9.id = "00009"
        izone9.name = "혼다 히토미"
        izone9.profileImg = UIImage(named: "Hitomi.png")
        izone9.statusMsg = nil
        list.append(izone9)
        
        let izone10 = AccountVO()
        izone10.id = "00010"
        izone10.name = "조유리"
        izone10.profileImg = UIImage(named: "YuRi.png")
        izone10.statusMsg = nil
        list.append(izone10)
        
        let izone11 = AccountVO()
        izone11.id = "00011"
        izone11.name = "안유진"
        izone11.profileImg = UIImage(named: "YuJin.png")
        izone11.statusMsg = nil
        list.append(izone11)
        
        let izone12 = AccountVO()
        izone12.id = "00012"
        izone12.name = "장원영"
        izone12.profileImg = UIImage(named: ".png")
        izone12.statusMsg = nil
        list.append(izone12)
        
        
        
        return list
    }

    
    var myAccount = { () -> AccountVO in
        let account = AccountVO()
        account.id = "00000"
        account.name = "김민석"
        account.profileImg = nil
        account.statusMsg = "아이즈원 ㅎㅇㅌ"
        return account
    }
}


