//
//  FriendRequestTableTableViewController.swift
//  SuperChat
//
//  Created by MoNireu on 2020/04/29.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit


class FriendRequestViewController: UIViewController {

    let appdelegate  = UIApplication.shared.delegate as? AppDelegate
    let actIndicator = UIActivityIndicatorView()
    var friendRequestDic: [String : ProfileVO]?
    weak var friendListVC_Delegate: FriendListViewController?
    @IBOutlet var noFriendReqestLbl: UILabel!
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI settings
        tableView.delegate   = self
        tableView.dataSource = self
        
        actIndicator.hidesWhenStopped = true
        actIndicator.center.x         = self.view.center.x
        actIndicator.center.y         = self.view.center.y
        self.view.addSubview(actIndicator)
        self.view.bringSubviewToFront(actIndicator)
        noFriendReqestLbl.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        
        downloadFriendRequest()
        
        //Test Code Below
        let friendListVC = FriendListViewController()
        print(friendListVC.friendProfileDic)
    }
    
    
    func downloadFriendRequest() {
        actIndicator.startAnimating()
        let db = appdelegate?.db
        
        // 친구요청 불러오기
        let colRef = db!.collection("Users").document((appdelegate?.myAccount?.id)!).collection("friends").whereField("isFriend", isEqualTo: false)
        colRef.getDocuments { (col, error) in
            guard error == nil else {print(error?.localizedDescription); return}
            
            if let docs = col?.documents {
                // 친구 요청이 존재하는지 확인
                guard docs.count != 0 else {
                    // 요청이 없을 경우
                    self.noFriendReqestLbl.isHidden = false
                    self.actIndicator.stopAnimating()
                    return
                }
                
                self.friendRequestDic = [String : ProfileVO]()
                let accountUtils = AccountUtils()
                var docCnt = 0
                for doc in docs {
                    accountUtils.downloadFriendProfile(id: doc.documentID, isNew: true) { (profileVO) in
                        self.friendRequestDic?.updateValue(profileVO!, forKey: doc.documentID)
                        docCnt += 1
                        print("Friend Request!") //Test
                        // 마지막 데이터 일 경우
                        if docCnt == docs.count{
                            self.actIndicator.stopAnimating()
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        
    }
}

    // MARK: - Table view data source

extension FriendRequestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(friendRequestDic?.count ?? 0)
        return friendRequestDic?.count ?? 0
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendRequestCell", for: indexPath) as? FriendRequestTableViewCell
        let data = Array(friendRequestDic!.values)[indexPath.row]
        
        cell?.profileImg.image     = strDataToImg(strData: data.profileImg!)
        cell?.name.text            = data.name
        cell?.id                   = data.id
        cell?.acceptFriendComplete = {
            self.friendRequestDic?.removeValue(forKey: data.id!)
            tableView.reloadData()
        }
        
        return cell!
    }
}

