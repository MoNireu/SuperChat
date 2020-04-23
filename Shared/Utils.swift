//
//  Utils.swift
//  SuperChat
//
//  Created by MoNireu on 2020/02/25.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit
import CoreData

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
        self.layer.borderColor = UIColor.clear.cgColor
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
    
    func getProfileImageFrom(strData: String) -> UIImage {
        if let imgData = Data(base64Encoded: strData) {
            let image = UIImage(data: imgData) ?? UIImage(named: "default_user_profile")!
            return image
        }
        else {
            return UIImage(named: "default_user_profile")!
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

extension UIImage {
    
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
        
        return plist.synchronize()
    }
}
