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
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var userNameTextField: ColoredTextField!
    @IBOutlet weak var passwordTextField: ColoredTextField!
    
    @IBOutlet weak var registrationButton: UIButton!
    
    
    @IBAction func registrationButtonAction(sender: UIButton) {
        var success = false
        let username = userNameTextField.text
        User.createUser(userNameTextField.text, callback: { (error, user) -> () in
            if error.isEmpty {
                
                var storyBoard = UIStoryboard(name: "Poker", bundle: nil)
                var profile = storyBoard.instantiateViewControllerWithIdentifier("Profile") as! ProfileController
                self.navigationController?.pushViewController(profile, animated: false)
                
                let mainStoryboard = UIStoryboard(name: "Poker", bundle: NSBundle.mainBundle())
                var image = mainStoryboard.instantiateViewControllerWithIdentifier("ImageTable") as! ImageController
                self.navigationController?.pushViewController(image, animated: true)
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
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
        
        userNameTextField.delegate = self
        //urlImageTextField.delegate = self
        
        //LAYOUT
        
        let screenSize : CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let aligmentX = screenWidth/2 - userNameTextField.frame.width/2
        
        usernameLabel.frame.origin.x = aligmentX
        usernameLabel.frame.origin.y = screenHeight/2 - 50
        
        userNameTextField.frame.origin.x = aligmentX
        userNameTextField.frame.origin.y = screenHeight/2 - 25
        
        passwordLabel.frame.origin.x = aligmentX
        passwordLabel.frame.origin.y = screenHeight/2 + 25
        
        passwordTextField.frame.origin.x = aligmentX
        passwordTextField.frame.origin.y = screenHeight/2 + 50
        
        registrationButton.frame.origin.x = aligmentX
        registrationButton.frame.origin.y = screenHeight/2 + 100
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
     * Keyboard hiding handlers
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches as Set<NSObject>, withEvent: event)
        self.view.endEditing(true)
    }

}