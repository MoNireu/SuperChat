//
//  FriendRequestTableViewCell.swift
//  SuperChat
//
//  Created by MoNireu on 2020/04/29.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit

class FriendRequestTableViewCell: UITableViewCell {

    
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var addBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImg.makeImageRound()
        name.sizeToFit()
        
        addBtn.makeButtonRound()
        addBtn.setTitle("  친구추가  ", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func add(_ sender: Any) {
        
    }
    

}
