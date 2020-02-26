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
    @IBOutlet var toolBar: UIToolbar!
    
    var accountVO: AccountVO?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.delegate   = self
//        tableView.dataSource = self
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = accountVO?.name
        self.tabBarController?.tabBar.isHidden = true
        
        let customToolBarView = ChatRoomToolBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: toolBar.frame.height))
        toolBar.addSubview(customToolBarView)
        
        customToolBarView.textField.inputAccessoryView = toolBar
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.largeTitleDisplayMode = .always
        self.tabBarController?.tabBar.isHidden = false
    }
    



}

//extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    }
//
//
//}
