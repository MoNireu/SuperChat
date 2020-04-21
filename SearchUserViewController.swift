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
    var profileImg: UIImage?
    var id: String
}

class SearchUserViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var noSearchResultLbl: UILabel!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var addFriendBtn: UIButton!
    @IBOutlet var activiyIndicator: UIActivityIndicatorView!
    
    let appdelegate = UIApplication.shared.delegate as? AppDelegate
    
    weak var superView: FriendListViewController?
    var searchFriendResult: SearchFriendResult?
    var btnState: UIButton.State? {
        willSet(newValue) {
            let state = newValue
            if state == .normal {
                addFriendBtn.backgroundColor = .systemBlue
            }
            else {
                addFriendBtn.backgroundColor = .systemGray
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.placeholder = "상대방의 아이디를 입력해주세요."
        searchBar.autocapitalizationType = .none
        
        profileImg.makeImageRound()
        profileImg.contentMode = .scaleAspectFill
        
        // Make "AddFriend"Button round
        enableAddFriend()
        addFriendBtn.layer.cornerRadius = addFriendBtn.frame.height / 1.9
        addFriendBtn.layer.borderColor = UIColor.systemBlue.cgColor
        addFriendBtn.setTitleColor(.white, for: .normal)
        addFriendBtn.setTitle("   친구추가   ", for: .normal)
//        addFriendBtn.setTitle("   추가완료   ", for: .disabled)
        
        hideResult()
        noSearchResultLbl.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    
    @IBAction func addFriend(sender: UIButton) {
        activiyIndicator.startAnimating()
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        
        // Firebase: 나의 계정에 상대 추가
        let myDocRef = appdelegate?.db?.collection("Users").document((appdelegate?.myAccount?.id)!).collection("friends").document((searchFriendResult?.id)!)
        myDocRef?.setData(["isFriend" : true]) { (error) in
            if error == nil { // Success
                // Firebase: 상대 계정에 나를 추가
                let friendDocRef = appdelegate?.db?.collection("Users").document((self.searchFriendResult?.id)!).collection("friends").document((appdelegate?.myAccount?.id)!)
                friendDocRef?.setData(["isFriend" : false]) { (error) in
                    if error == nil { // Success
                        // UserDefualts에 저장
                        var userDefaultsFriendList = appdelegate?.myAccount?.friendList
                        guard userDefaultsFriendList != nil else {userDefaultsFriendList = [String : Bool](); return}
                        userDefaultsFriendList?.updateValue(true, forKey: self.searchFriendResult!.id)
                        appdelegate?.myAccount?.friendList = userDefaultsFriendList
                        print(self.searchFriendResult!.id)
                        print(appdelegate?.myAccount?.friendList)
                        print(appdelegate?.saveMyAccount())
                        
                        
                        self.activiyIndicator.stopAnimating()
                        self.disableAddFriend()
                    }
                    else {
                        self.errorAlert("친구 추가에 실패했습니다.")
                        print(error?.localizedDescription)
                    }
                }
            }
            else {
                self.errorAlert("친구 추가에 실패했습니다.")
                print(error?.localizedDescription)
            }
        }
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
//        self.superView = FriendListViewController()
        self.dismiss(animated: true) {
            self.superView!.loadFriendList() {
                self.superView!.tableView.reloadData()
            }
        }
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
    
    func noResult() {
        self.activiyIndicator.stopAnimating()
        self.noSearchResultLbl.isHidden = false
    }
    
    func enableAddFriend() {
        self.addFriendBtn.isEnabled = true
        self.btnState = self.addFriendBtn.state
    }
    
    func disableAddFriend() {
        self.addFriendBtn.isEnabled = false
        self.btnState = self.addFriendBtn.state
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
                    // 상세정보가 입력되지 않은 계정이라면 검색 불가
                    guard !name!.isEmpty else {self.noResult(); return}
                    // 이미 추가된 계정이라면 추가 불가
                    print(self.appdelegate?.myAccount?.friendList?["\(searchBar.text!)"])
                    print(self.appdelegate?.myAccount?.friendList)
                    if self.appdelegate?.myAccount?.friendList?["\(searchBar.text!)"] != nil {
                        self.disableAddFriend()
                    }
                    
                    let profileImgData   = result?["profileImg"] as? String
                    let profileImgString = Data(base64Encoded: profileImgData!)
                    let profileImg       = UIImage(data: profileImgString!)
                    
                    self.searchFriendResult = SearchFriendResult(name: name!, profileImg: profileImg, id: searchBar.text!)
                    
                    self.activiyIndicator.stopAnimating()
                    self.showResult()
                    
                    // 검색한 것이 나의 계정이라면 버튼 숨기기
                    if searchBar.text == self.appdelegate?.myAccount?.id {
                        self.addFriendBtn.isHidden = true
                    }
                }
                else {
                    self.noResult()
                }
                
            })
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        noSearchResultLbl.isHidden = true
        
        if searchBar.text!.isEmpty {
            enableAddFriend()
            searchFriendResult = nil
            hideResult()
        }
    }
}
