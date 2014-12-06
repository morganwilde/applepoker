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
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        avatarImage.onlineImage = appDelegate.currentUser?.getAvatarUrl()
        //moneyLabel.text = AppDelegate.cur
        userNameLabel.text = appDelegate.currentUser?.getName()
    }
    
}
