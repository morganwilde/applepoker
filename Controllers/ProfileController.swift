//
//  ProfileController.swift
//  ApplePoker
//
//  Created by Tautvydas Stakėnas on 12/6/14.
//  Copyright (c) 2014 Tautvydas Stakėnas. All rights reserved.
//

import Foundation
import UIKit

class ProfileController: UIViewController {
    
    
    @IBOutlet weak var avatarImage: Avatar!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let url = appDelegate.currentUser!.getAvatarUrl()!
        //println(avatarImage)
        avatarImage.onlineImage = url
        //moneyLabel.text = AppDelegate.cur
        userNameLabel.text = appDelegate.currentUser?.getName()
    }
    
}
