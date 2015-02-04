//
//  ViewController.swift
//  login test
//
//  Created by Christopher Lang on 2/1/15.
//  Copyright (c) 2015 Christopher Lang. All rights reserved.
//


import UIKit

class ViewController: UIViewController, FBLoginViewDelegate {
    
    @IBOutlet weak var withEmail: UIButton!
    
    @IBOutlet var fbLoginView : FBLoginView!
    @IBOutlet var profilePictureView : FBProfilePictureView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends", "user_photos"]
        //navigationController?.hidesBarsOnSwipe = true
        //navigationController?.hidesBarsOnTap = true
        //navigationController?.hidesBarsWhenKeyboardAppears = true
        
        
        //Below is the code if we want to use their login/sign up buttons - uncomment to see what it looks like
        
        //var loginBtn = UIButton(frame: CGRectMake(40, 360, 240, 40))
        //loginBtn.layer.borderColor = UIColor.whiteColor().CGColor
        //loginBtn.layer.borderWidth = 2
        //loginBtn.titleLabel!.font = UIFont.systemFontOfSize(24)
        //loginBtn.tintColor = UIColor.whiteColor()
        //loginBtn.setTitle("Login", forState: UIControlState.Normal)
        //self.view.addSubview(loginBtn)
        
        //var signUpBtn = UIButton(frame: CGRectMake(40, 420, 240, 40))
        //signUpBtn.layer.borderColor = UIColor.whiteColor().CGColor
        //signUpBtn.layer.borderWidth = 2
        //signUpBtn.titleLabel!.font = UIFont.systemFontOfSize(24)
        //signUpBtn.tintColor = UIColor.whiteColor()
        //signUpBtn.setTitle("Sign Up", forState: UIControlState.Normal)
        //self.view.addSubview(signUpBtn)
        
        
    }
    
    // Facebook Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        
        
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        println("User: \(user)")
        println("User ID: \(user.objectID)")
        println("User Name: \(user.name)")
        var userEmail = user.objectForKey("email") as String
        println("User Email: \(userEmail)")
        
        var profileImageView = FBProfilePictureView()
        
        // Get List Of Friends From FB
        var friendsRequest : FBRequest = FBRequest.requestForMyFriends()
        friendsRequest.startWithCompletionHandler{(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            var resultdict = result as NSDictionary
            
            //Pull in the facebook profile picture code
            //self.profilePictureView.profileID = user.objectID
            //self.profilePictureView.pictureCropping = FBProfilePictureCropping.Square
            //self.profilePictureView.frame = CGRectMake(200, 200, 100, 100)
            //self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width / 2
            
            
            
            
            println("Result Dict: \(resultdict)")
            var data : NSArray = resultdict.objectForKey("data") as NSArray
            
            for i in 0..<data.count {
                let valueDict : NSDictionary = data[i] as NSDictionary
                let id = valueDict.objectForKey("id") as String
                println("the id value is \(id)")
            }
            
            var friends = resultdict.objectForKey("data") as NSArray
            println("Found \(friends.count) friends")
            
        }
        
        //Added a view for
        //self.view.addSubview(profilePictureView)
        
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}
