//
//  ProfileViewController.swift
//  SuperChat
//
//  Created by MoNireu on 2020/02/25.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var backgroundImg: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var statMsg: UILabel!
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    let appdelegate = UIApplication.shared.delegate as? AppDelegate
    var accountVO: ProfileVO?
    var ref: DatabaseReference!
    
    weak var delegate: FriendListViewController?
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.tableView.reloadData()
        }
    }
    
    @IBAction func openChatRoom(_ sender: Any) {
        if let chatRoomVC = self.storyboard?.instantiateViewController(identifier: "chatRoomVC") as? ChatRoomViewController {
            chatRoomVC.accountVO = self.accountVO
            chatRoomVC.myAccount = delegate?.myAccount
            
            
            
            self.dismiss(animated: false) {
                self.delegate?.navigationController!.pushViewController(chatRoomVC, animated: true)
                self.delegate?.hidesBottomBarWhenPushed = false
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = appdelegate?.ref
        
        profileImg.makeImageRound()
        button1.imageView?.makeImageRound()
        button2.imageView?.makeImageRound()
        button3.imageView?.makeImageRound()
        
        profileImg.image       = accountVO?.profileImg ?? UIImage(named: "default_user_profile.png")
        profileImg.contentMode = .scaleAspectFill
        
        backgroundImg.image       = accountVO?.backgroundImg ?? UIImage(named: "DongDong.JPG")
        backgroundImg.contentMode = .scaleAspectFill
        backgroundImg.alpha       = 0.75
        
        name.text = accountVO?.name
        name.sizeToFit()
        
        statMsg.text     = accountVO?.statusMsg
        statMsg.sizeToFit()
        statMsg.center.x = self.view.frame.width / 2
        statMsg.center.y = profileImg.frame.minY / 2
        
        let swipeGesture = UISwipeGestureRecognizer()
        swipeGesture.direction = .down
        swipeGesture.addTarget(self, action: #selector(dismiss(_:)))
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func dismiss(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.tableView.reloadData()
        }
    }
}
