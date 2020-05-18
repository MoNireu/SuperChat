//
//  ProfileImgViewController.swift
//  SuperChat
//
//  Created by MoNireu on 2020/05/18.
//  Copyright © 2020 monireu. All rights reserved.
//

import UIKit

class ProfileImgViewController: UIViewController {

    @IBOutlet var profileImg: UIImageView!
    var param_profileImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImg.image = param_profileImg
        profileImg.contentMode = .scaleAspectFit
        profileImg.backgroundColor = .black
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
