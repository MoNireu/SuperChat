//
//  MyAccountTableViewCell.swift
//  SuperChat
//
//  Created by MoNireu on 2020/02/24.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit

class MyAccountTableViewCell: UITableViewCell {

    
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var statMsg: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImg.makeImageRound()
        profileImg.contentMode = .scaleAspectFill
        name.sizeToFit()
        statMsg.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
