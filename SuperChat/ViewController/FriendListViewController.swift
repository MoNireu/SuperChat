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
    
    @IBOutlet var tableView: UITableView!
    let accountUtils = AccountUtils()
    
    
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
            print("teststsets")
            
            // UserDefaults에 FriendProfileList저장.
            let plist = UserDefaults.standard
            do {
                // 인코딩 후 저장
                let encoder = JSONEncoder()
                let friendProfileListData = try encoder.encode(self.friendProfileDic)
                plist.set(friendProfileListData, forKey: "friendProfileListData")
                
                // latestUpdate 시간 저장
                plist.set(Date(), forKey: "latestProfileUpdate")
            }
            catch let error{
                print(error.localizedDescription)
            }
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
    
    
    func loadFriendProfileList(completion: (() -> Void)? = nil) {
        var cnt = 0
        
        // UserDefaults에서 FriendProfileList 불러오기.
        let plist = UserDefaults.standard
        if let friendProfileListData = plist.value(forKey: "friendProfileListData") as? Data {
            let decoder = JSONDecoder()
            do {
                let ud_friendProfileList = try decoder.decode([String : ProfileVO].self, from: friendProfileListData)
                friendProfileDic = ud_friendProfileList
            } catch let error {
                print("UserDefaults load FriendProfileList ERROR: \(error.localizedDescription)")
            }
            
        }
        
        if let friends = appdelegate?.myAccount?.friendList {
            // friendProfileList 초기화
            if friendProfileDic == nil {
                friendProfileDic = [String: ProfileVO]()
            }
            
            for friend in friends {
                if friend.value == true {
                    print("$$$ here")
                    accountUtils.downloadFriendProfile(id: friend.key) { profile in
                        self.friendProfileDic?.updateValue(profile, forKey: friend.key)
                        print("Info: Append Friend Profile in FriendList")
                        cnt += 1
                        cnt == friends.count ? completion?() : ()
                    }
                }
            }
        }
    }
}



extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
