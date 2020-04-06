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
    
    var friendID: String?
    
    @IBAction func addFriend(sender: UIButton) {
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        let collectionRef = appdelegate?.db?.collection("Users").document((appdelegate?.myAccount?.id)!)
        collectionRef?.updateData(["friends.\(friendID!)" : ""]) { (error) in
            if error == nil { // Success
                appdelegate?.myAccount?.friends?.updateValue("\(self.friendID!)", forKey: "")
                self.addFriendBtn.isEnabled = false
                self.addFriendBtn.layer.borderColor = UIColor.systemGray.cgColor
                self.addFriendBtn.backgroundColor = .systemGray
            }
            else {
                print(error?.localizedDescription)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImg.makeRoundImage()
        profileImg.contentMode = .scaleAspectFill
        
        // Make "AddFriend"Button round
        addFriendBtn.isEnabled = true
        addFriendBtn.layer.cornerRadius = addFriendBtn.frame.height / 1.9
        addFriendBtn.layer.borderColor = UIColor.systemBlue.cgColor
        addFriendBtn.backgroundColor = .systemBlue
        addFriendBtn.setTitleColor(.white, for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        addFriendBtn.backgroundColor = .systemBlue
        // Configure the view for the selected state
    }

}
