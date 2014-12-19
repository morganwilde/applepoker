//
//  ImageController.swift
//  ApplePoker
//
//  Created by Tautvydas Stakėnas on 12/19/14.
//  Copyright (c) 2014 Tautvydas Stakėnas. All rights reserved.
//

import Foundation
import UIKit

class ImageController: UITableViewController, UITableViewDelegate{
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forHeaderFooterViewReuseIdentifier: "imageCell")
        
        
        
    }
    
    
}