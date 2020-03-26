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
    func makeRoundImage() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = self.frame.height / 2.55
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
            object.setValue(value.chatRoom, forKey: "chatRoom")
            
            do {
                try context?.save()
                return true
            } catch {
                context?.rollback()
                return false
            }
        }
    }
}
