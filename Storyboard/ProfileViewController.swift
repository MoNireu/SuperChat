//
//  ProfileViewController.swift
//  SuperChat
//
//  Created by MoNireu on 2020/02/25.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

enum Status {
    case normal
    case edit
}

class ProfileViewController: UIViewController {
    
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var backgroundImg: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var statMsg: UILabel!
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var endEditBtn: UIButton!
    @IBOutlet var buttonStackView: UIStackView!
    
    let appdelegate = UIApplication.shared.delegate as? AppDelegate
    var ref: DatabaseReference!
    var accountVO: ProfileVO?
    
    private var status: Status = .normal
    private lazy var pickerImgView = UIImageView()
    
    weak var delegate: FriendListViewController?
    lazy var imgPicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = appdelegate?.ref
        
        endEditBtn.isHidden = true
        endEditBtn.addTarget(self, action: #selector(endEditMode(_:)), for: .touchUpInside)
        
        button1.imageView?.makeImageRound()
        button2.imageView?.makeImageRound()
        button3.imageView?.makeImageRound()
        
        button3.addTarget(self, action: #selector(startEditMode(_:)), for: .touchUpInside)
        
        backgroundImg.image       = self.strDataToImg(strData: accountVO?.backgroundImg)
        backgroundImg.contentMode = .scaleAspectFill
        backgroundImg.alpha       = 0.75
        backgroundImg.addGestureRecognizer(setGestureRecognizer())
        
        profileImg.makeImageRound()
        profileImg.addGestureRecognizer(setGestureRecognizer())
        profileImg.image       = self.strDataToImg(strData: accountVO?.profileImg)
        profileImg.contentMode = .scaleAspectFill
        self.view.bringSubviewToFront(profileImg)
        
        name.text = accountVO?.name
        name.sizeToFit()
        
        statMsg.text     = accountVO?.statusMsg
        statMsg.sizeToFit()
        statMsg.center.x = self.view.frame.width / 2
        statMsg.center.y = profileImg.frame.minY / 2
        
        let swipeGesture = UISwipeGestureRecognizer()
        swipeGesture.direction = .down
        swipeGesture.addTarget(self, action: #selector(dismiss(_:)))
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    func setGestureRecognizer() -> UITapGestureRecognizer {
        let tapRecognizer = UITapGestureRecognizer()
        if status == .normal {
            tapRecognizer.addTarget(self, action: #selector(profileImgTapped(_:)))
        }
        
        return tapRecognizer
    }
    
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.tableView.reloadData()
        }
    }
    
    @objc func startEditMode(_ sender: Any) {
        self.status = .edit
        
        buttonStackView.isHidden = true
        endEditBtn.isHidden = false
    }
    
    @objc func endEditMode(_ sender: Any) {
        self.status = .normal
        
        buttonStackView.isHidden = false
        endEditBtn.isHidden = true
    }
    
    
    @IBAction func openChatRoom(_ sender: Any) {
        if let chatRoomVC = self.storyboard?.instantiateViewController(identifier: "chatRoomVC") as? ChatRoomViewController {
            chatRoomVC.accountVO = self.accountVO
            chatRoomVC.myAccount = delegate?.myAccount
            
            self.dismiss(animated: false) {
                self.delegate?.navigationController!.pushViewController(chatRoomVC, animated: true)
                self.delegate?.hidesBottomBarWhenPushed = false
            }
        }
    }
    
    
    @objc func dismiss(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.tableView.reloadData()
        }
    }
    
    @objc func profileImgTapped(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case profileImg:
            if status == .normal {
                if let profileImgVC = storyboard?.instantiateViewController(identifier: "profileImgVC") as? ProfileImgViewController {
                    profileImgVC.param_data = profileImg.image
                    profileImgVC.modalPresentationStyle = .fullScreen
                    self.present(profileImgVC, animated: true)
                }
            }
            else {
                selectImg(sender.view as! UIImageView)
            }
        case backgroundImg:
            if status == .normal
            {
                if let profileImgVC = storyboard?.instantiateViewController(identifier: "profileImgVC") as? ProfileImgViewController {
                    profileImgVC.param_data = backgroundImg.image
                    profileImgVC.modalPresentationStyle = .fullScreen
                    self.present(profileImgVC, animated: true)
                }
            }
            else {
                selectImg(sender.view as! UIImageView)
            }
            
        default:
            ()
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel")
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let selectedImg = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.pickerImgView.image = selectedImg
            }
        }
    }
    
    @objc func selectImg(_ sender: UIImageView) {
        imgPicker.allowsEditing = true
        imgPicker.delegate = self
        pickerImgView = sender
        
        let alert = UIAlertController(title: "프로필 사진 설정", message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "카메라", style: .default) { _ in
            self.imgPicker.sourceType = .camera
            self.present(self.imgPicker, animated: true)
        }
        let photoLibrary = UIAlertAction(title: "포토 라이브러리", style: .default) { _ in
            self.imgPicker.sourceType = .photoLibrary
            self.present(self.imgPicker, animated: true)
        }
        let savedPhotosAlbum = UIAlertAction(title: "저장된 앨범", style: .default) { _ in
            self.imgPicker.sourceType = .savedPhotosAlbum
            self.present(self.imgPicker, animated: true)
        }
        let defaultImg = UIAlertAction(title: "기본 이미지", style: .default) { (_) in
            sender.image = UIImage(named: "default_user_profile.png")
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(camera)
        alert.addAction(photoLibrary)
        alert.addAction(savedPhotosAlbum)
        alert.addAction(defaultImg)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
    
    
}
