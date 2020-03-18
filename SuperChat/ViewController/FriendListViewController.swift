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
    
    var myAccount: AccountVO?
    var friendList: [AccountVO]?
    
    
    @IBOutlet var tableView: UITableView!
    @IBAction func signOut(_ sender: Any) {
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.isSignedIn = false
        
        try! Auth.auth().signOut()
        
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("FriendListVC is Presented by \(self.presentingViewController)") // TestCode
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        
        let friendListData = FriendListData()
        myAccount = friendListData.myAccount()
        friendList = [AccountVO]()
        friendList?.append(myAccount!)
        friendList?.append(contentsOf: friendListData.data())

        tableView.reloadData()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.hidesBottomBarWhenPushed = true
    }
}

extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myAccountTableViewCell", for: indexPath) as? MyAccountTableViewCell
            
            cell?.profileImg.image = friendList?[indexPath.row].profileImg ?? UIImage(named: "default_user_profile.png")
            cell?.name.text        = friendList?[indexPath.row].name
            cell?.statMsg.text     = friendList?[indexPath.row].statusMsg ?? ""
            cell?.isSelected       = false
            
            return cell!
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendTableViewCell", for: indexPath) as? FriendListTableViewCell
            
            cell?.profileImg.image = friendList?[indexPath.row].profileImg ?? UIImage(named: "default_user_profile.png")
            cell?.name.text        = friendList?[indexPath.row].name
            cell?.statMsg.text     = friendList?[indexPath.row].statusMsg ?? ""
            cell?.isSelected       = false
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = friendList?[indexPath.row]
        
        if let profileVC = self.storyboard?.instantiateViewController(identifier: "profileVC") as? ProfileViewController {
            
            profileVC.accountVO = row
            profileVC.delegate = self
            
            profileVC.modalPresentationStyle = .fullScreen
            self.present(profileVC, animated: true)
            
            tableView.cellForRow(at: indexPath)?.isSelected = false
        }
    }
    
}
