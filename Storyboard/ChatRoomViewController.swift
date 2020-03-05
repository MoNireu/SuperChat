//
//  ChatRoomViewController.swift
//  SuperChat
//
//  Created by MoNireu on 2020/02/26.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit

class ChatRoomViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var bottomBar: ChatRoomBottomBar!
    
    
    var myAccount: AccountVO?
    var accountVO: AccountVO?
    var chatVO: [ChatVO]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate   = self
        tableView.dataSource = self
        
        // tableview setup
        tableView.separatorColor = .clear
        tableView.allowsSelection = false
        
        // set DummyData
        let chatDummyData = ChatDummyData()
        chatVO = chatDummyData.data()
        
        // NavigationController UI
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title                 = accountVO?.name
        self.tabBarController?.tabBar.isHidden    = true
        
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(endEditing(_:)))
        self.view.addGestureRecognizer(gestureRecognizer)
        
        // Custom ToolBar UI
        bottomBar.setup()
        scrollToBottom()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.largeTitleDisplayMode = .always
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    func scrollToBottom() {
         DispatchQueue.main.async {
             let lastIndex = IndexPath(item: self.chatVO!.count-1, section: 0)
             self.tableView.scrollToRow(at: lastIndex, at: .bottom, animated: false)
         }
     }
    
    // MARK: Action Methods
    @objc func endEditing(_ sender: UIGestureRecognizer) {
        bottomBar.endEditing(true)
    }
}

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatVO?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if chatVO?[indexPath.row].sender == myAccount?.id {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myChatCell") as? MyChatTableViewCell

            cell?.content.text = chatVO?[indexPath.row].content as? String
            cell?.content.sizeToFit()
            cell?.time.text    = chatVO?[indexPath.row].time
            
            if indexPath.row != 0, chatVO?[indexPath.row].sender == chatVO?[indexPath.row - 1].sender {
                cell?.continueChatBubble()
            }
            
            return cell!
        } else {
            switch indexPath.row != 0 && chatVO?[indexPath.row].sender == chatVO?[indexPath.row - 1].sender {
            case true:
                let cell = tableView.dequeueReusableCell(withIdentifier: "friendChatContinueCell") as? FriendChatContinueTableViewCell

                cell?.content.text = chatVO?[indexPath.row].content as? String
                cell?.content.sizeToFit()
                cell?.time.text    = chatVO?[indexPath.row].time
                
                return cell!
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "friendChatCell") as? FriendChatTableViewCell

                cell?.content.text = chatVO?[indexPath.row].content as? String
                cell?.content.sizeToFit()
                cell?.profileImg.image = accountVO?.profileImg ?? UIImage(named: "default_user_profile")
                cell?.name.text = accountVO?.name
                cell?.time.text    = chatVO?[indexPath.row].time
                
                return cell!
            }
        }
    }
}