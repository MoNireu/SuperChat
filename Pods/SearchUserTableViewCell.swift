//
//  SearchUserTableViewCell.swift
//  SuperChat
//
//  Created by MoNireu on 2020/04/02.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit

class SearchUserTableViewCell: UITableViewCell {

    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var name: UILabel!
    @IBAction func addFriend(sender: UIButton) {
        print("Add Friend")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImg.makeRoundImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
