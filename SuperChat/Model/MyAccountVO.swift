//
//  Account.swift
//  SuperChat
//
//  Created by MoNireu on 2020/02/24.
//  Copyright © 2020 monireu. All rights reserved.
//

import Foundation
import UIKit

class MyAccountVO: ProfileVO{
    var email: String?
    var friendList: [String : Bool]? // [user_id : isFriend]
}
