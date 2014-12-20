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
    @IBOutlet weak var imgButton: ImageButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let url = appDelegate.currentUser!.avatar!
        //println(avatarImage)
        //avatarImage.onlineImage = url
        //moneyLabel.text = AppDelegate.cur
        userNameLabel.text = appDelegate.currentUser?.name
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.leftBarButtonItem = nil;
        navigationItem.hidesBackButton = true;
    }
    
    /*override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.leftBarButtonItem = nil;
        navigationItem.hidesBackButton = true;
        
    }*/
    
    func updateAvatar() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let filename = appDelegate.currentUser!.avatar?.filename
        imgButton.setInternalImage(filename!)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        //navigationItem.setHidesBackButton(false, animated: false)
    }
}
