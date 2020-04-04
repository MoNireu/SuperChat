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
}

class SearchUserViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    let appdelegate = UIApplication.shared.delegate as? AppDelegate
    var searchFriendResultList = [SearchFriendResult]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        searchBar.delegate = self
        searchBar.placeholder = "상대방의 아이디를 입력해주세요."
        searchBar.autocapitalizationType = .none
    }

}

extension SearchUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchFriendResultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchUserCell") as? SearchUserTableViewCell
        cell!.name.text = searchFriendResultList.first?.name
        cell!.profileImg.image = searchFriendResultList.first?.profileImg ?? UIImage(named: "default_user_profile")
        
        
        return cell!
    }
}

extension SearchUserViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            let ref = appdelegate?.db?.collection("Users").document(searchBar.text!)
            ref?.getDocument(completion: { (doc, error) in
                if doc!.exists {
                    let result = doc?.data()
                    
                    let name = result?["name"] as? String
                    
                    let profileImgData = result?["profileImg"] as? String
                    let profileImgString = Data(base64Encoded: profileImgData!)
                    let profileImg = UIImage(data: profileImgString!)
                    
                    let searchFriendResult = SearchFriendResult(name: name!, profileImg: profileImg!)
                    
                    self.searchFriendResultList.append(searchFriendResult)
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty {
            searchFriendResultList.removeAll()
            tableView.reloadData()
        }
    }
}
