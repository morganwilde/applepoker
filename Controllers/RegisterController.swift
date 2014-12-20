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
    @IBOutlet weak var urlImageTextField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
   
    
    @IBAction func registrationButtonAction(sender: UIButton) {
        var success = false
        let username = textField.text
        User.createUser(textField.text, callback: { (error, user) -> () in
            if error.isEmpty {
                
                var storyBoard = UIStoryboard(name: "Poker", bundle: nil)
                var profile = storyBoard.instantiateViewControllerWithIdentifier("Profile") as ProfileController
                self.navigationController?.pushViewController(profile, animated: false)
                
                let mainStoryboard = UIStoryboard(name: "Poker", bundle: NSBundle.mainBundle())
                var image = mainStoryboard.instantiateViewControllerWithIdentifier("ImageTable") as ImageController
                self.navigationController?.pushViewController(image, animated: true)
                
                let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                appDelegate.currentUser = user
                
                
            } else {
                
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController( alert, animated: true, completion: nil )
                
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        urlImageTextField.delegate = self
    }
    
    /*
     * Keyboard hiding handlers
     */
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
}