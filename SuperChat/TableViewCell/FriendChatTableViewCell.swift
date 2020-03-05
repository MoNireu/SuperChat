//
//  FriendChatTableViewCell.swift
//  SuperChat
//
//  Created by MoNireu on 2020/02/26.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit

class FriendChatTableViewCell: UITableViewCell {

    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var content: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var chatBubble: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImg.contentMode = .scaleAspectFill
        profileImg.makeRoundImage()
        
        chatBubble.image = UIImage(named: "FriendChatBubble")?.stretchableImage(withLeftCapWidth: 15, topCapHeight: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
