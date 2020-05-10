//
//  Utils.swift
//  SuperChat
//
//  Created by MoNireu on 2020/02/25.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth
import FirebaseFirestore

enum LocalDB: String {
    case myProfile = "MyAccount"
    case friendList = "FriendList"
}

extension UIImageView {
    func makeImageRound() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = self.frame.height / 2.55
        self.clipsToBounds = true
    }
}

extension UIButton {
    func makeButtonRound() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.systemBlue.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

extension UIViewController {
    func errorAlert(_ msg: String?, complete: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "오류", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default){ _ in
            complete?()
        })
        self.present(alert, animated: true)
    }
    
    func infoAlert(_ msg: String, complete: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "안내", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default){ _ in
            complete?()
        })
        self.present(alert, animated: true)
    }
    
    func strDataToImg(strData: String?) -> UIImage {
        guard strData != "" else { return UIImage(named: "default_user_profile.png")! }
        guard strData != nil else { return UIImage(named: "default_user_profile.png")! }
        
        if let imgData = Data(base64Encoded: strData!) {
            let image = UIImage(data: imgData) ?? UIImage(named: "default_user_profile.png")!
            return image
        }
        else {
            return UIImage(named: "default_user_profile.png")!
        }
    }
    
    func getImgStringDataFrom(img: UIImage) -> String? {
        if img != UIImage(named: "default_user_profile") {// 이미지가 기본데이터가 아닐경우
            let imgStringData = img.jpegData(compressionQuality: 0.5)?.base64EncodedString()
            return imgStringData
        }
        else { //이미지가 기본 데이터일 경우
            return nil
        }
    }
}



class CoreDataUtils {
    lazy var appdelegate = UIApplication.shared.delegate as? AppDelegate
    
    func fetch(entity: String) -> [NSManagedObject] {
        let context = appdelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        let result =  try! context?.fetch(fetchRequest)
        return result!
    }
    
    func save(entity: String, value: MyAccountVO) -> Bool {
        let context = appdelegate?.persistentContainer.viewContext
        
        let object = NSEntityDescription.insertNewObject(forEntityName: entity, into: context!)
        
        object.setValue(value.email, forKey: "email")
        object.setValue(value.id, forKey: "id")
        object.setValue(value.name, forKey: "name")
        object.setValue(value.statusMsg, forKey: "statusMsg")
        object.setValue(value.profileImg, forKey: "profileImg")
        object.setValue(value.backgroundImg, forKey: "backgroundImg")
        object.setValue(value.friendList, forKey: "friendList")
        
        do {
            try context?.save()
            return true
        } catch {
            context?.rollback()
            return false
        }
    }
}

class UserDefaultsUtils {
    
    func fetchMyAccount() -> MyAccountVO {
        let plist = UserDefaults.standard
        
        let myAccount = MyAccountVO()
        
        myAccount.email         = plist.string(forKey: "email")
        myAccount.id            = plist.string(forKey: "id")
        myAccount.name          = plist.string(forKey: "name")
        myAccount.statusMsg     = plist.string(forKey: "statusMsg")
        myAccount.profileImg    = plist.string(forKey: "profileImg")
        myAccount.backgroundImg = plist.string(forKey: "backgroundImg")
        myAccount.friendList    = plist.dictionary(forKey: "friendList") as! [String : Bool]?
        
        return myAccount
    }
    
    
    
    func saveMyAccount() -> Bool {
        let plist = UserDefaults.standard
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        
        let myAccount = appdelegate?.myAccount
        
        plist.set(myAccount?.email, forKey: "email")
        plist.set(myAccount?.id, forKey: "id")
        plist.set(myAccount?.name, forKey: "name")
        plist.set(myAccount?.statusMsg, forKey: "statusMsg")
        plist.set(myAccount?.profileImg, forKey: "profileImg")
        plist.set(myAccount?.backgroundImg, forKey: "backgroundImg")
        plist.set(myAccount?.friendList, forKey: "friendList")
        
    
        if plist.synchronize() {
            return true
        } else {
            return false
        }
    }
    
    func removeMyAccount() -> Bool {
        let plist = UserDefaults.standard
        
        plist.removeObject(forKey: "email")
        plist.removeObject(forKey: "id")
        plist.removeObject(forKey: "name")
        plist.removeObject(forKey: "statusMsg")
        plist.removeObject(forKey: "profileImg")
        plist.removeObject(forKey: "backgroundImg")
        plist.removeObject(forKey: "lastProfileUpdate")
        plist.removeObject(forKey: "friendProfileListData")
        
        return plist.synchronize()
    }
    
    func saveFriendProfileList(_ friendProfileDictionary: [String : ProfileVO]) {
        // UserDefaults에 FriendProfileList저장.
        let plist = UserDefaults.standard
        do {
            // 인코딩 후 저장
            let encoder = JSONEncoder()
            let friendProfileListData = try encoder.encode(friendProfileDictionary)
            plist.set(friendProfileListData, forKey: "friendProfileListData")
            
            // latestUpdate 시간 저장
            plist.set(Date(), forKey: "latestProfileUpdate")
        }
        catch let error{
            print(error.localizedDescription)
        }
    }
    
    func fetchFriendProfileList() -> [String : ProfileVO]? {
        // UserDefaults에서 FriendProfileList 불러오기.
        let plist = UserDefaults.standard
        if let friendProfileListData = plist.value(forKey: "friendProfileListData") as? Data {
            let decoder = JSONDecoder()
            do {
                let ud_friendProfileList = try decoder.decode([String : ProfileVO].self, from: friendProfileListData)
                return ud_friendProfileList
            } catch let error {
                print("UserDefaults load FriendProfileList ERROR: \(error.localizedDescription)")
            }
        }
        return nil
    }
}


class AccountUtils {
    let appdelegate = UIApplication.shared.delegate as? AppDelegate
    
    
    func signOut() {
        try? Auth.auth().signOut()
        appdelegate?.isSignedIn = false
        print("SignOut")
    }
    
    func reloadMyAccount() {
        // Get UserID from UID collection
        let uidRef = appdelegate?.db?.collection("UID").document(Auth.auth().currentUser!.uid)
        uidRef?.getDocument() { result, error in
            if error == nil {   // Success
                if let result = result?.data()?["id"] as? String {
                    self.getMyAccount(userID: result)
                }
            } else { // Fail
                print(error)
            }
        }
    }
    
    func getDocumentFrom(_ uid: String, complete: @escaping () -> ()) {
        // UID 가져오기
        let uidRef = self.appdelegate?.db?.collection("UID").document(uid)
        var userID: String?
        uidRef?.getDocument { (document, error) in
            if let document = document, document.exists {
                let result = document.data()
                userID = result?["id"] as? String ?? nil
                // 계정 정보 가져오기
                self.getMyAccount(userID: userID, complete: complete)
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func getMyAccount(userID: String?, complete: (() -> Void)? = nil) {
            guard userID != nil else {self.signOut(); return}
        let docRef = appdelegate?.db?.collection("Users").document(userID!)
            docRef?.getDocument { (result, error) in
                if result != nil, result!.exists { // Success
                    self.appdelegate?.myAccount = MyAccountVO()
                    
                    // 계정정보 가져오기
                    let myAccount = self.appdelegate?.myAccount
                    print("========== getDoc Success! ==========")
                    let data = result?.data()
                    myAccount?.id            = userID
                    myAccount?.name          = data!["name"] as? String
                    myAccount?.statusMsg     = data!["statusMsg"] as? String
                    myAccount?.profileImg    = data!["profileImg"] as? String
                    myAccount?.backgroundImg = data!["backgroundImg"] as? String
                    
                    print(data!["name"]) // Test
                    print("appdelegate name = \(myAccount?.name)") // TestCode
                    
                    
                    // 친구목록 가져오기
                    let friendsRef = docRef?.collection("friends").whereField("isFriend", isEqualTo: true)
                    friendsRef?.getDocuments { (query, error) in
                        if query != nil { // Success
                            myAccount?.friendList = [String : Bool]()
                            let docs = query?.documents
                            for element in docs! {
                                let elementData = element.data()
                                let friend   = element.documentID
                                let isFriend = elementData["isFriend"] as? Bool
                                print("*********Friend: \(friend) / isFriend: \(isFriend)")
                                myAccount?.friendList?.updateValue(isFriend!, forKey: friend)
    //                            self.myAccount?.friendList?["\(friend)"] = isFriend
                                print("FriendList = \(myAccount?.friendList)") //Test
                            }
                            
                            self.appdelegate?.myAccount = myAccount
                            complete?()
                        }
                        else {
                            print("ERROR2 : \(error)")
    //                        complete?()
                        }
                    }
                }
                else { // Fail
                    print("ERROR1: \(error?.localizedDescription)")
                }
            }
        }
    
    func downloadFriendProfile(id: String, isNew: Bool = false, completion: ((ProfileVO?) -> Void)? = nil) {
        let friendID = appdelegate?.db?.collection("Users").document(id)
        friendID?.getDocument() { (doc, error) in
            if doc != nil, doc?.exists == true { //success
                print("$$$ \(isNew)")
                if isNew == false { // 기존 존재하던 프로필일 경우
                    print("$$$") //Test
                    let timestamp = doc?.get("latestUpdate") as? Timestamp
                    let friendProfileUpdateTime = timestamp?.dateValue()
                    let mylatestUpdate: Date? = UserDefaults.standard.value(forKey: "latestProfileUpdate") as? Date
                    // 최신 업데이트 되었는지 확인 후 업데이트 진행 유무 결정
                    guard mylatestUpdate == nil || (mylatestUpdate! < friendProfileUpdateTime!) else {completion?(nil); return}
                }
                
                guard let data = doc?.data() else {return}
                
                let friendProfile = ProfileVO()
                
                friendProfile.id            = id
                friendProfile.name          = data["name"] as? String
                friendProfile.statusMsg     = data["statusMsg"] as? String
                friendProfile.profileImg    = data["profileImg"] as? String
                friendProfile.backgroundImg = data["backgroundImg"] as? String
                
                completion?(friendProfile)
            }
            else {
                print("ERROR: downloadFriendProfile() - \(error?.localizedDescription)")
            }
        }
    }
}
