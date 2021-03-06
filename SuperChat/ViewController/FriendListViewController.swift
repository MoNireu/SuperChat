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
    var friendProfileDic: [String : ProfileVO]?
    let accountUtils = AccountUtils()
    let userDefaultsUtils = UserDefaultsUtils()
    lazy var refreshControl = UIRefreshControl()
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView Delegate settings
        tableView.delegate = self
        tableView.dataSource = self
        
        // UI settings
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        appdelegate?.myAccount = userDefaultsUtils.fetchMyAccount()
        
        myAccount = appdelegate?.myAccount
        print("myaccount name = \(myAccount?.name)") // Test
        
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshFriendProfileList(_:)), for: .valueChanged)
        
        
        loadFriendProfileList() {
            self.tableView.reloadData()
            print("teststsets")
            
            self.userDefaultsUtils.saveFriendProfileList(self.friendProfileDic!)
        }
        
        
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
    
    
    @objc func refreshFriendProfileList(_ refreshControl: UIRefreshControl) {
        loadFriendProfileList() {
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            
            self.userDefaultsUtils.saveFriendProfileList(self.friendProfileDic!)
        }
    }
    
    func loadFriendProfileList(completion: (() -> Void)? = nil) {
        var cnt = 0
        
        self.friendProfileDic = self.userDefaultsUtils.fetchFriendProfileList()
        
        if let friendList = appdelegate?.myAccount?.friendList {
            // friendProfileList가 존재하지 않는다면 초기화
            if friendProfileDic == nil {
                friendProfileDic = [String: ProfileVO]()
            }
            
            print(friendList) //Test
            for friend in friendList {
                if friend.value == true {
                    print("$$$ here")
                    accountUtils.downloadFriendProfile(id: friend.key) { profile in
                        if let profile = profile {
                            self.friendProfileDic?.updateValue(profile, forKey: friend.key)
                            print("Info: Append Friend Profile in FriendList")
                        }
                        cnt += 1
                        print("cnt = \(cnt)\ncount = \(friendList.count)") //testcode
                        cnt == friendList.count ? completion?() : ()
                    }
                }
            }
        }
    }
}



extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(friendProfileDic?.count)
        return friendProfileDic != nil ? friendProfileDic!.count + 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myAccountTableViewCell", for: indexPath) as? MyAccountTableViewCell
            let myAccount = appdelegate?.myAccount
            cell?.profileImg.image = strDataToImg(strData: (myAccount?.profileImg)!)
            cell?.name.text        = myAccount?.name!
            cell?.statMsg.text     = myAccount?.statusMsg!
            cell?.isSelected       = false
            
            return cell!
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendTableViewCell", for: indexPath) as? FriendListTableViewCell
            let row = indexPath.row - 1
            let data = Array(friendProfileDic!.values).sorted(by: {$0.name! < $1.name!})[row]
            cell?.profileImg.image = strDataToImg(strData: (data.profileImg)!)
            cell?.name.text        = data.name //friendProfileList?[row].name
            cell?.statMsg.text     = data.statusMsg ?? ""
            cell?.isSelected       = false
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var selectedAccount: ProfileVO?
        if indexPath.row == 0 {
            selectedAccount = myAccount
        } else {
            selectedAccount = Array(friendProfileDic!.values).sorted(by: {$0.name! < $1.name!})[indexPath.row - 1]
        }
        
        if let profileVC = self.storyboard?.instantiateViewController(identifier: "profileVC") as? ProfileViewController {
            
            profileVC.accountVO = selectedAccount
            profileVC.delegate = self
            
            profileVC.modalPresentationStyle = .fullScreen
            self.present(profileVC, animated: true) {
                self.hidesBottomBarWhenPushed = true
            }
            
            tableView.cellForRow(at: indexPath)?.isSelected = false
        }
    }
    
}
