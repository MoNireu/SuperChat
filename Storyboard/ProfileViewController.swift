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

enum Status {
    case normal
    case edit
}

class ProfileViewController: UIViewController {
    
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var backgroundImg: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var statMsg: UILabel!
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var endEditBtn: UIButton!
    @IBOutlet var buttonStackView: UIStackView!
    
    let appdelegate = UIApplication.shared.delegate as? AppDelegate
    var ref: DatabaseReference!
    var accountVO: ProfileVO?
    
    var status: Status = .normal
    
    weak var delegate: FriendListViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = appdelegate?.ref
        
        endEditBtn.isHidden = true
        endEditBtn.addTarget(self, action: #selector(endEditMode(_:)), for: .touchUpInside)
        
        button1.imageView?.makeImageRound()
        button2.imageView?.makeImageRound()
        button3.imageView?.makeImageRound()
        
        button3.addTarget(self, action: #selector(startEditMode(_:)), for: .touchUpInside)
        
        backgroundImg.image       = self.strDataToImg(strData: accountVO?.backgroundImg)
        backgroundImg.contentMode = .scaleAspectFill
        backgroundImg.alpha       = 0.75
        backgroundImg.addGestureRecognizer(setGestureRecognizer())
        
        profileImg.makeImageRound()
        profileImg.addGestureRecognizer(setGestureRecognizer())
        profileImg.image       = self.strDataToImg(strData: accountVO?.profileImg)
        profileImg.contentMode = .scaleAspectFill
        self.view.bringSubviewToFront(profileImg)
        
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
    
    func setGestureRecognizer() -> UITapGestureRecognizer {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(showProfileImg(_:)))
        
        return tapRecognizer
    }
    
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.tableView.reloadData()
        }
    }
    
    @objc func startEditMode(_ sender: Any) {
        self.status = .edit
        
//        button1.isHidden = true
//        button2.isHidden = true
//        button3.isHidden = true
        buttonStackView.isHidden = true
        
        endEditBtn.isHidden = false
    }
    
    @objc func endEditMode(_ sender: Any) {
        self.status = .normal
        
//        button1.isHidden = false
//        button2.isHidden = false
//        button3.isHidden = false
        
        buttonStackView.isHidden = false
        
        endEditBtn.isHidden = true
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
    
    
    @objc func dismiss(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.tableView.reloadData()
        }
    }
    
    @objc func showProfileImg(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case profileImg:
            if let profileImgVC = storyboard?.instantiateViewController(identifier: "profileImgVC") as? ProfileImgViewController {
                profileImgVC.param_data = profileImg.image
                profileImgVC.modalPresentationStyle = .fullScreen
                self.present(profileImgVC, animated: true)
            }
        case backgroundImg:
            if let profileImgVC = storyboard?.instantiateViewController(identifier: "profileImgVC") as? ProfileImgViewController {
                profileImgVC.param_data = backgroundImg.image
                profileImgVC.modalPresentationStyle = .fullScreen
                self.present(profileImgVC, animated: true)
            }
        default:
            ()
        }
        
    }
}
