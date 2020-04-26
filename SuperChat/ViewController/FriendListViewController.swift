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
    var friendProfileList: [ProfileVO]?
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello from viewcon") //TestCode
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let userDefaultsUtil = UserDefaultsUtils()
        appdelegate?.myAccount = userDefaultsUtil.fetchMyAccount()
        
        myAccount = appdelegate?.myAccount
        print("myaccount name = \(myAccount?.name)") // Test
        
        loadFriendProfileList() {
            self.tableView.reloadData()
            
            // UserDefaults에 FriendProfileList저장.
            let plist = UserDefaults.standard
            do {
                let encoder = JSONEncoder()
                let friendProfileListData = try encoder.encode(self.friendProfileList)
                plist.set(friendProfileListData, forKey: "friendProfileListData")
            }
            catch let error{
                print(error.localizedDescription)
            }
            
//            // UserDefaults에서 FriendProfileList 불러오기.
//            let friendProfileListData = plist.value(forKey: "friendProfileListData") as? Data
//            let decoder = JSONDecoder()
//            let ud_friendProfileList = try! decoder.decode([ProfileVO].self, from: friendProfileListData!)
//            print(ud_friendProfileList)
            
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
            searchUserVC.superView = self
            self.present(searchUserVC, animated: true)
        }
    }
    
    
    func loadFriendProfileList(completion: (() -> Void)? = nil) {
        var cnt = 0
        if let friends = appdelegate?.myAccount?.friendList {
            friendProfileList = [ProfileVO]()
            for friend in friends {
                if friend.value == true {
                    downloadFriendProfile(id: friend.key) { profile in
                        self.friendProfileList?.append(profile)
                        print("Info: Append Friend Profile in FriendList")
                        cnt += 1
                        cnt == friends.count ? completion?() : ()
                    }
                }
            }
        }
    }
    
    // TODO: Last Update 확인 기능 추가하기.
    func downloadFriendProfile(id: String, completion: ((ProfileVO) -> Void)? = nil) {
        let friendID = appdelegate?.db?.collection("Users").document(id)
        friendID?.getDocument() { (doc, error) in
            if doc != nil, doc?.exists == true { //success
                guard let data = doc?.data() else {return}
                
                let friendProfile = ProfileVO()
                
                friendProfile.id            = id
                friendProfile.name          = data["name"] as? String
                friendProfile.statusMsg     = data["statusMsg"] as? String
                friendProfile.profileImg    = data["profileImg"] as? String
                friendProfile.backgroundImg = data["backgroundImg"] as? String
                
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
        return friendProfileList!.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myAccountTableViewCell", for: indexPath) as? MyAccountTableViewCell
            let myAccount = appdelegate?.myAccount
            cell?.profileImg.image = getProfileImageFrom(strData: (myAccount?.profileImg)!)
            cell?.name.text        = myAccount?.name!
            cell?.statMsg.text     = myAccount?.statusMsg!
            cell?.isSelected       = false
            
            return cell!
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendTableViewCell", for: indexPath) as? FriendListTableViewCell
            let row = indexPath.row - 1
            cell?.profileImg.image = getProfileImageFrom(strData: (friendProfileList?[row].profileImg)!)
            cell?.name.text        = friendProfileList?[row].name
            cell?.statMsg.text     = friendProfileList?[row].statusMsg ?? ""
            cell?.isSelected       = false
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var selectedAccount: ProfileVO?
        if indexPath.row == 0 {
            selectedAccount = myAccount
        } else {
            selectedAccount = friendProfileList?[indexPath.row - 1]
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
