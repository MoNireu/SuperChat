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
    
    
    
    
    
}

class CoreDataUtils {
    lazy var appdelegate = UIApplication.shared.delegate as? AppDelegate
    
    func fetch(entity: String) -> [NSManagedObject] {
        let context = appdelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        let result =  try! context?.fetch(fetchRequest)
        return result!
    }
    
    func save(entity: String, value: AccountVO) -> Bool {
        let context = appdelegate?.persistentContainer.viewContext
        
        let object = NSEntityDescription.insertNewObject(forEntityName: entity, into: context!)
        
        object.setValue(value.email, forKey: "email")
        object.setValue(value.id, forKey: "id")
        object.setValue(value.name, forKey: "name")
        object.setValue(value.statusMsg, forKey: "statusMsg")
        object.setValue(value.profileImg, forKey: "profileImg")
        object.setValue(value.backgroundImg, forKey: "backgroundImg")
        object.setValue(value.friends, forKey: "friends")
        
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
    
    func fetchMyAccount() -> AccountVO {
        let plist = UserDefaults.standard
        
        let myAccount = AccountVO()
        
        myAccount.email = plist.string(forKey: "email")
        myAccount.id = plist.string(forKey: "id")
        myAccount.name = plist.string(forKey: "name")
        myAccount.statusMsg = plist.string(forKey: "statusMsg")
        
        if let profileImgData = plist.object(forKey: "profileImg") as? NSData {
            myAccount.profileImg = UIImage(data: profileImgData as Data)
        }
        
        if let backgroundImgData = plist.object(forKey: "backgroundImg") as? NSData {
            myAccount.backgroundImg = UIImage(data: backgroundImgData as Data)
        }
        
        
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
        
        let profileImgData = myAccount?.profileImg?.jpegData(compressionQuality: 0.5)
        plist.set(profileImgData, forKey: "profileImg")
        
        let backgroundImgData = myAccount?.backgroundImg?.jpegData(compressionQuality: 0.5)
        plist.set(backgroundImgData, forKey: "backgroundImg")
        
        //            plist.set(myAccount.chatRoom, forKey: "chatRoom")
        
        
        if plist.synchronize() {
            return true
        } else {
            return false
        }
    }
}
