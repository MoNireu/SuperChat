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
    @IBOutlet var addFriendBtn: UIButton!
    @IBAction func addFriend(sender: UIButton) {
        print("Add Friend")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImg.makeRoundImage()
        addFriendBtn.layer.cornerRadius = addFriendBtn.frame.height / 1.9
        addFriendBtn.layer.borderColor = UIColor.systemBlue.cgColor
        addFriendBtn.backgroundColor = .systemBlue
        addFriendBtn.setTitleColor(.white, for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
