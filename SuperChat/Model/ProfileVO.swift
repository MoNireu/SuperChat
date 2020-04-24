//
//  ProfileVO.swift
//  SuperChat
//
//  Created by MoNireu on 2020/04/21.
//  Copyright © 2020 monireu. All rights reserved.
//

import Foundation
import UIKit

class ProfileVO: Encodable, Decodable {
    var id: String?
    var name: String?
    var statusMsg: String?
    var profileImg: String?
    var backgroundImg: String?
}
