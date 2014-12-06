//
//  RegisterController.swift
//  ApplePoker
//
//  Created by Tautvydas Stakėnas on 12/6/14.
//  Copyright (c) 2014 Tautvydas Stakėnas. All rights reserved.
//

import Foundation
import UIKit

class RegisterController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    @IBAction func registrationButtonAction(sender: UIButton) {
        var success = false
        if success {
            var storyBoard = UIStoryboard(name: "Poker", bundle: nil)
            println(storyBoard)
            var profile = storyBoard.instantiateViewControllerWithIdentifier("Profile") as ProfileController
            println(profile)
            navigationController?.pushViewController(profile, animated: true)
            //self.presentViewController(profile, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Wrong user name.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController( alert, animated: true, completion: nil )
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate=self
    }
    
    /*
     * Keyboard hiding handlers
     */
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.view.endEditing(true)
    }
    /*
    *
    */
}