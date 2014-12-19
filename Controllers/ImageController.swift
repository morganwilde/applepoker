//
//  ImageController.swift
//  ApplePoker
//
//  Created by Tautvydas Stakėnas on 12/19/14.
//  Copyright (c) 2014 Tautvydas Stakėnas. All rights reserved.
//

import Foundation
import UIKit

class ImageController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    let avatars = AvatarModel.getAvatars()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return avatars.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as AvatarCellController
        cell.avatarImage?.image = UIImage(named: self.avatars[indexPath.row].filename)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        //println("You selected cell #\(avatars[indexPath.row].avatarId)!")
        if let navigation = navigationController {
            if let profileController = navigation.viewControllers[navigation.viewControllers.count - 2] as? ProfileController {
                let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                appDelegate.currentUser?.updateAvatar(avatars[indexPath.row].avatarId)
                //model update avatar
                
                profileController.updateAvatar()
            }
            navigation.popViewControllerAnimated(true)
            
        }
        
        
    }
}