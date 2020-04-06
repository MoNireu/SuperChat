//
//  SearchUserViewController.swift
//  SuperChat
//
//  Created by MoNireu on 2020/04/02.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit

struct SearchFriendResult {
    var name: String
    var profileImg: UIImage
    var id: String
}

class SearchUserViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var noSearchResultLbl: UILabel!
    
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    let appdelegate = UIApplication.shared.delegate as? AppDelegate
    var searchFriendResult: SearchFriendResult?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        searchBar.delegate = self
        searchBar.placeholder = "상대방의 아이디를 입력해주세요."
        searchBar.autocapitalizationType = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.becomeFirstResponder()
    }

}

extension SearchUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchFriendResult == nil {
            return 0
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchUserCell") as? SearchUserTableViewCell
        cell!.name.text = searchFriendResult?.name
        cell!.profileImg.image = searchFriendResult?.profileImg ?? UIImage(named: "default_user_profile")
        cell?.friendID = searchFriendResult?.id
        
        
        return cell!
    }
}

extension SearchUserViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            let ref = appdelegate?.db?.collection("Users").document(searchBar.text!)
            ref?.getDocument(completion: { (doc, error) in
                if doc!.exists { //Success
                    let result = doc?.data()
                    
                    let name = result?["name"] as? String
                    
                    let profileImgData   = result?["profileImg"] as? String
                    let profileImgString = Data(base64Encoded: profileImgData!)
                    let profileImg       = UIImage(data: profileImgString!)
                    
                    self.searchFriendResult = SearchFriendResult(name: name!, profileImg: profileImg!, id: searchBar.text!)
                    
//                    self.searchFriendResultList.append(searchFriendResult)
                    self.tableView.reloadData()
                }
                else {
                    self.noSearchResultLbl.isHidden = false
                }
            })
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        noSearchResultLbl.isHidden = true
        
        if searchBar.text!.isEmpty {
            let cell = tableView.cellForRow(at: [0, 0]) as? SearchUserTableViewCell
            cell?.addFriendBtn.isEnabled = true
            
            searchFriendResult = nil
            tableView.reloadData()
        }
    }
}
