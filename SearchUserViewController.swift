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

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var noSearchResultLbl: UILabel!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var addFriendBtn: UIButton!
    @IBOutlet var activiyIndicator: UIActivityIndicatorView!
    
    @IBAction func addFriend(sender: UIButton) {
        activiyIndicator.startAnimating()
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        let collectionRef = appdelegate?.db?.collection("Users").document((appdelegate?.myAccount?.id)!)
        collectionRef?.updateData(["friends.\(searchFriendResult?.id)" : ""]) { (error) in
            if error == nil { // Success
                appdelegate?.myAccount?.friends?.updateValue("\(self.searchFriendResult?.id)", forKey: "")
                self.activiyIndicator.stopAnimating()
                self.addFriendBtn.isEnabled = false
                self.addFriendBtn.layer.borderColor = UIColor.systemGray.cgColor
                self.addFriendBtn.backgroundColor = .systemGray
            }
            else {
                self.activiyIndicator.stopAnimating()
                print(error?.localizedDescription)
            }
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    let appdelegate = UIApplication.shared.delegate as? AppDelegate
    var searchFriendResult: SearchFriendResult?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.placeholder = "상대방의 아이디를 입력해주세요."
        searchBar.autocapitalizationType = .none
        
        profileImg.makeRoundImage()
        profileImg.contentMode = .scaleAspectFill
        
        // Make "AddFriend"Button round
        addFriendBtn.isEnabled = true
        addFriendBtn.layer.cornerRadius = addFriendBtn.frame.height / 1.9
        addFriendBtn.layer.borderColor = UIColor.systemBlue.cgColor
        addFriendBtn.backgroundColor = .systemBlue
        addFriendBtn.setTitleColor(.white, for: .normal)
        addFriendBtn.setTitle("   친구추가   ", for: .normal)
        addFriendBtn.setTitle("   추가완료   ", for: .disabled)
        
        hideResult()
        noSearchResultLbl.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }

    func showResult() {
        name.text        = searchFriendResult?.name
        profileImg.image = searchFriendResult?.profileImg ?? UIImage(named: "default_user_profile")
        
        name.isHidden         = false
        profileImg.isHidden   = false
        addFriendBtn.isHidden = false
    }
    
    func hideResult() {
        name.isHidden         = true
        profileImg.isHidden   = true
        addFriendBtn.isHidden = true
    }
}


extension SearchUserViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchFriendResult = nil
        hideResult()
        activiyIndicator.startAnimating()
        searchBar.resignFirstResponder()
        
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
                    
                    self.activiyIndicator.stopAnimating()
                    self.showResult()
                    
                }
                else {
                    self.activiyIndicator.stopAnimating()
                    self.noSearchResultLbl.isHidden = false
                }
            })
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        noSearchResultLbl.isHidden = true
        
        if searchBar.text!.isEmpty {
            addFriendBtn.isEnabled = true
            
            searchFriendResult = nil
            hideResult()
        }
    }
}
