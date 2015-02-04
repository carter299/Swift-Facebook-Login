//
//  LoginViewController.swift
//  login test
//
//  Created by Christopher Lang on 2/4/15.
//  Copyright (c) 2015 Christopher Lang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameLoginTextField: UITextField!
    @IBOutlet weak var passwordLoginTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameLoginTextField.delegate = self
        self.passwordLoginTextField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func loginBackButton(sender: AnyObject) {
    }

    @IBAction func loginButton(sender: AnyObject) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
