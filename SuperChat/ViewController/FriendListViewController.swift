//
//  FriendListViewController.swift
//  SuperChat
//
//  Created by MoNireu on 2020/02/24.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit
import FirebaseAuth


class FriendListViewController: UIViewController {
    
    let appdelegate = UIApplication.shared.delegate as? AppDelegate
    
    var myAccount: MyAccountVO? = {
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        return appdelegate?.myAccount
    }()
    var friendList: [ProfileVO]?
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello from viewcon") //TestCode
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        appdelegate?.myAccount = appdelegate?.fetchMyAccount()
        
        myAccount = appdelegate?.myAccount
        print("myaccount name = \(myAccount?.name)")
        
        loadFriendList() {
            print("FriendList Element num = \(self.friendList?.count)")
            self.tableView.reloadData()
            
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.hidesBottomBarWhenPushed = true
    }
    
    
    @IBAction func signOut(_ sender: Any) {
        appdelegate?.isSignedIn = false
        
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
        
        appdelegate?.removeMyAccount()
        
        guard self.presentingViewController == nil else {
            self.dismiss(animated: true)
            return
        }
        
        let currentVC = self
        self.dismiss(animated: true) {
            let signInVC = self.storyboard?.instantiateViewController(identifier: "signInViewController")
            currentVC.view.window?.rootViewController = signInVC
        }
    }
    
    @IBAction func searchUser(_ sender: Any) {
        if let searchUserVC = self.storyboard?.instantiateViewController(identifier: "searchUserVC") as? SearchUserViewController {
            searchUserVC.modalPresentationStyle = .automatic
            self.present(searchUserVC, animated: true)
        }
    }
    
    
    func loadFriendList(completion: (() -> Void)? = nil) {
        var cnt = 0
        if let friends = appdelegate?.myAccount?.friendList {
            friendList = [ProfileVO]()
            for friend in friends {
                if friend.value == true {
                    downloadFriendProfile(id: friend.key) { profile in
                        self.friendList?.append(profile)
                        print("Info: Append Friend Profile in FriendList")
                        cnt += 1
                        cnt == friends.count ? completion?() : ()
                    }
                }
            }
        }
    }
    
    func downloadFriendProfile(id: String, completion: ((ProfileVO) -> Void)? = nil) {
        
        let friendID = appdelegate?.db?.collection("Users").document(id)
        friendID?.getDocument() { (doc, error) in
            if doc != nil, doc?.exists == true { //success
                guard let data = doc?.data() else {return}
                
                let friendProfile = ProfileVO()
                
                friendProfile.id        = id
                friendProfile.name      = data["name"] as? String
                friendProfile.statusMsg = data["statusMsg"] as? String
                
                if let profileImgString = data["profileImg"] as? String {
                    if let profileImgData = Data(base64Encoded: profileImgString) {
                        friendProfile.profileImg = UIImage(data: profileImgData)
                    }
                }
                else {
                    friendProfile.profileImg = UIImage(named: "default_user_profile")
                }
                
                
                if let backgroundImgString = data["backgroundImg"] as? String {
                    if let backgroundImgData = Data(base64Encoded: backgroundImgString) {
                        friendProfile.backgroundImg = UIImage(data: backgroundImgData)
                    }
                }
                else {
                    friendProfile.profileImg = UIImage(named: "default_user_profile")
                }
                
                completion?(friendProfile)
            }
            else {
                print("ERROR: downloadFriendProfile() - \(error?.localizedDescription)")
            }
        }
    }
}



extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList!.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myAccountTableViewCell", for: indexPath) as? MyAccountTableViewCell
            let myAccount = appdelegate?.myAccount
            cell?.profileImg.image = myAccount?.profileImg ?? UIImage(named: "default_user_profile.png")
            cell?.name.text        = myAccount?.name!
            cell?.statMsg.text     = myAccount?.statusMsg!
            cell?.isSelected       = false
            
            return cell!
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendTableViewCell", for: indexPath) as? FriendListTableViewCell
            let row = indexPath.row - 1
            cell?.profileImg.image = friendList?[row].profileImg ?? UIImage(named: "default_user_profile.png")
            cell?.name.text        = friendList?[row].name
            cell?.statMsg.text     = friendList?[row].statusMsg ?? ""
            cell?.isSelected       = false
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var selectedAccount: ProfileVO?
        if indexPath.row == 0 {
            selectedAccount = myAccount
        } else {
            selectedAccount = friendList?[indexPath.row - 1]
        }
        
        if let profileVC = self.storyboard?.instantiateViewController(identifier: "profileVC") as? ProfileViewController {
            
            profileVC.accountVO = selectedAccount
            profileVC.delegate = self
            
            profileVC.modalPresentationStyle = .fullScreen
            self.present(profileVC, animated: true)
            
            tableView.cellForRow(at: indexPath)?.isSelected = false
        }
    }
    
}
