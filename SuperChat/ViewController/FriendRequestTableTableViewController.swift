//
//  FriendRequestTableTableViewController.swift
//  SuperChat
//
//  Created by MoNireu on 2020/04/29.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit


class FriendRequestTableTableViewController: UITableViewController {

    let appdelegate  = UIApplication.shared.delegate as? AppDelegate
    let actIndicator = UIActivityIndicatorView()
    var friendRequestDic: [String : ProfileVO]?
    @IBOutlet var noFriendReqestLbl: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI settings
        actIndicator.hidesWhenStopped = true
        actIndicator.center.x = self.view.frame.width / 2
        actIndicator.center.y = self.view.frame.height / 2
        self.view.addSubview(actIndicator)
        self.view.bringSubviewToFront(actIndicator)
        noFriendReqestLbl.isHidden = true
        
        downloadFriendRequest()
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
                        self.friendRequestDic?.updateValue(profileVO, forKey: doc.documentID)
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

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendRequestDic?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
