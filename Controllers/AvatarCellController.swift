//
//  AvatarCellController.swift
//  ApplePoker
//
//  Created by Tautvydas Stakėnas on 12/19/14.
//  Copyright (c) 2014 Tautvydas Stakėnas. All rights reserved.
//

import Foundation
import UIKit

class AvatarCellController: UITableViewCell {
    @IBOutlet weak var avatarImage: Avatar?
    @IBOutlet weak var selectorButton: UIButton?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
