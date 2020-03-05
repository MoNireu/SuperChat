//
//  FriendChatContinueTableViewCell.swift
//  SuperChat
//
//  Created by MoNireu on 2020/03/03.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit

class FriendChatContinueTableViewCell: UITableViewCell {

    @IBOutlet var content: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var chatBubble: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chatBubble.image = UIImage(named: "FriendChatBubbleContinue")?.stretchableImage(withLeftCapWidth: 15, topCapHeight: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
