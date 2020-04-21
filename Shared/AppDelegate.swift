//
//  AppDelegate.swift
//  SuperChat
//
//  Created by MoNireu on 2020/02/24.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var db: Firestore?
    var ref: DatabaseReference!
    var myAccount: MyAccountVO?
    var isSignedIn: Bool?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        db = Firestore.firestore()
        ref = Database.database().reference()
        
//        self.signOut()  // TestCode
        
        isSignedIn = Auth.auth().currentUser != nil ? true : false
        print(isSignedIn)
        
        if isSignedIn! {
            print("Signed In")
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentCloudKitContainer(name: "SuperChat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    // MARK: - Outher Methods
    func signOut() {
        try? Auth.auth().signOut()
        isSignedIn = false
        print("SignOut")
    }
    
    func reloadMyAccount() {
        // Get UserID from UID collection
        let uidRef = db?.collection("UID").document(Auth.auth().currentUser!.uid)
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
    
    
    func getMyAccount(userID: String?, complete: (() -> Void)? = nil) {
        guard userID != nil else {self.signOut(); return}
        let docRef = db?.collection("Users").document(userID!)
        docRef?.getDocument { (result, error) in
            if result != nil, result!.exists { // Success
                self.myAccount = MyAccountVO()
                print("========== getDoc Success! ==========")
                let data = result?.data()
                self.myAccount?.id = userID
                self.myAccount?.name = data!["name"] as? String
                print(data!["name"])
                print("appdelegate name = \(self.myAccount?.name)") // TestCode
                self.myAccount?.statusMsg = data!["statusMsg"] as? String
                if let profileImgString = data!["profileImg"] as? String {
                    let profileImgData = Data(base64Encoded: profileImgString)
                    let profileImg = UIImage(data: profileImgData!)
                    self.myAccount?.profileImg = profileImg
                }
                if let backgroundImgString = data!["backgroundImg"] as? String {
                    let backgroundImgData = Data(base64Encoded: backgroundImgString)
                    let backgroundImg = UIImage(data: backgroundImgData!)
                    self.myAccount?.backgroundImg = backgroundImg
                }
                
                let friendsRef = docRef?.collection("friends")
                friendsRef?.getDocuments { (query, error) in
                    if query != nil { // Success
                        self.myAccount?.friendList = [String : Bool]()
                        let docs = query?.documents
                        for element in docs! {
                            let elementData = element.data()
                            let friend   = element.documentID
                            let isFriend = elementData["isFriend"] as? Bool
                            print("*********Friend: \(friend) / isFriend: \(isFriend)")
                            self.myAccount?.friendList?.updateValue(isFriend!, forKey: friend)
//                            self.myAccount?.friendList?["\(friend)"] = isFriend
                            print("FriendList = \(self.myAccount?.friendList)") //Test
                        }
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
    
    func fetchMyAccount() -> MyAccountVO {
        let plist = UserDefaults.standard
        
        let myAccount = MyAccountVO()
        
        myAccount.email = plist.string(forKey: "email")
        myAccount.id = plist.string(forKey: "id")
        myAccount.name = plist.string(forKey: "name")
        myAccount.statusMsg = plist.string(forKey: "statusMsg")
        myAccount.friendList = plist.dictionary(forKey: "friendList") as! [String : Bool]?
        
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
        
        let myAccount = self.myAccount
        
        plist.set(myAccount?.email, forKey: "email")
        plist.set(myAccount?.id, forKey: "id")
        plist.set(myAccount?.name, forKey: "name")
        plist.set(myAccount?.statusMsg, forKey: "statusMsg")
        plist.set(myAccount?.friendList, forKey: "friendList")
        
        let profileImgData = myAccount?.profileImg?.jpegData(compressionQuality: 0.5)
        plist.set(profileImgData, forKey: "profileImg")
        
        let backgroundImgData = myAccount?.backgroundImg?.jpegData(compressionQuality: 0.5)
        plist.set(backgroundImgData, forKey: "backgroundImg")
        
        //            plist.set(myAccount.chatRoom, forKey: "chatRoom")
        
        
        return plist.synchronize()
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

