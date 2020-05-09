//
//  FriendRequestTableViewCell.swift
//  SuperChat
//
//  Created by MoNireu on 2020/04/29.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit

class FriendRequestTableViewCell: UITableViewCell {

    var id: String?
    var acceptFriendComplete: (() -> Void)?
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var acceptFriendBtn: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImg.makeImageRound()
        name.sizeToFit()
        
        acceptFriendBtn.makeButtonRound()
        acceptFriendBtn.backgroundColor = .systemBlue
        acceptFriendBtn.setTitleColor(.white, for: .normal)
        acceptFriendBtn.setTitle("  친구추가  ", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    @IBAction func acceptFriend(_ sender: UIButton) {
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        
        let docRef = appdelegate?.db?.collection("Users").document((appdelegate?.myAccount?.id)!).collection("friends").document(self.id!)
        docRef?.setData(["isFriend" : true]) { (error) in
            if error == nil { // Success
                sender.backgroundColor = .systemGray
                self.acceptFriendComplete?()
            }
            else {
                print("ERROR while add friend - \(error?.localizedDescription)")
            }
        }
    }
    

}
