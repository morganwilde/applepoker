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
    
    
    @IBAction func imageAction(sender: UIButton) {
        
        let mainStoryboard = UIStoryboard(name: "Poker", bundle: NSBundle.mainBundle())
        var image = mainStoryboard.instantiateViewControllerWithIdentifier("ImageTable") as ImageController
        self.navigationController?.pushViewController(image, animated: true)
        
    }
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userNameText: UILabel!
    @IBOutlet weak var cashText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let url = appDelegate.currentUser!.avatarUrl!
        //println(avatarImage)
        //avatarImage.onlineImage = url
        //moneyLabel.text = AppDelegate.cur
        userNameLabel.text = appDelegate.currentUser?.name
        
    }
    
}
