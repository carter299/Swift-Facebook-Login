//
//  LoginViewController.swift
//  login test
//
//  Created by Christopher Lang on 2/4/15.
//  Copyright (c) 2015 Christopher Lang. All rights reserved.
//

import UIKit
import CryptoSwift

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
    
    func decrypt(transferData:NSData, keyData:NSData) -> String {
        let ivData = transferData.subdataWithRange(NSRange(location: 0, length: AES.blockSizeBytes()))
        let encryptedData = transferData.subdataWithRange(NSRange(location: AES.blockSizeBytes(), length: transferData.length - AES.blockSizeBytes()))
        
        let aes = AES(key: keyData, iv: ivData, blockMode: .CBC) // CBC is default
        let decryptedData = Cipher.AES(key: keyData, iv: ivData, blockMode: .CBC).decrypt(encryptedData)
        let decryptedString = NSString(data: decryptedData!, encoding: NSUTF8StringEncoding)!
        return decryptedString
    }
    
    func decryptData(transferData:NSData, keyData:NSData) -> NSData {
        let ivData = transferData.subdataWithRange(NSRange(location: 0, length: AES.blockSizeBytes()))
        let encryptedData = transferData.subdataWithRange(NSRange(location: AES.blockSizeBytes(), length: transferData.length - AES.blockSizeBytes()))
        
        let aes = AES(key: keyData, iv: ivData, blockMode: .CBC) // CBC is default
        let decryptedData = Cipher.AES(key: keyData, iv: ivData, blockMode: .CBC).decrypt(encryptedData)
        return decryptedData!
    }
    
    func encrypt(plaintextData:NSData, keyData:NSData) -> NSData {
        let ivData:NSData = Cipher.randomIV(keyData)
        let cipherdata = Cipher.AES(key: keyData, iv: ivData, blockMode: .CBC).encrypt(plaintextData)
        let transferData = NSMutableData(data: ivData)
        transferData.appendData(cipherdata!)
        return transferData
    }
    
    @IBAction func loginBackButton(sender: AnyObject) {
    }

    @IBAction func loginButton(sender: AnyObject) {
        
        let customAllowedSet =  NSCharacterSet(charactersInString: "+=/").invertedSet
        
        let keyStr = "4sZHK5oYi4CVRAx7"
        
        let loginDict: [String : String] = [
            "username" : self.usernameLoginTextField.text,
            "password" : self.passwordLoginTextField.text
        ]
        
        let apiKey: String = "$2y$10$LGSrLV5qQyxk4eKZdMCVIOmcXt.kYJE0JmsXhQ.fcPU9aoKXDLqYK"
        //let apiKey: String = "$2y$10$uID4XnCset1vkxN.1W0w.OH27Et8/aj.2wgIHPtJq0dEKb/73X0pa"
        let loginData: String = JSON(loginDict).rawString(encoding: NSUTF8StringEncoding, options: nil)!
        
        println(loginData); println()
        
        
        // BEGIN ENCRYPTION -------------------
        
        let keyData = keyStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        let ivData:NSData = Cipher.randomIV(keyData)
        let encryptedLogin = encrypt(loginData.dataUsingEncoding(NSUTF8StringEncoding)!, keyData: keyData)
        let encryptedApi = encrypt(apiKey.dataUsingEncoding(NSUTF8StringEncoding)!, keyData: keyData)
        let b64Login: String = encryptedLogin.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
        let b64Api: String = encryptedApi.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
        
        // END ENCRYPTION ---------------------
        
        println("data=\(b64Login)&api_key=\(b64Api)"); println()
        
        let jsonString: String = "data=\(b64Login.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!)&api_key=\(b64Api.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!)"
        println(jsonString); println()
        
        let urlPath: String = "http://104.236.212.56/api/v1/login/username"
        //let urlPath: String = "http://sportsapi.app/api/v1/login/username"
        var url: NSURL = NSURL(string: urlPath)!
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        
        let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
        
        request.timeoutInterval = 60
        request.HTTPBody = data
        request.HTTPShouldHandleCookies = false
        
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            var err: NSError
            
            var responseStr = NSString(data: data, encoding: NSUTF8StringEncoding) as String
            let encryptedData = NSData(base64EncodedString: responseStr, options: NSDataBase64DecodingOptions.allZeros)!
            
            
            var respStr = self.decrypt(encryptedData, keyData: keyData).stringByReplacingOccurrencesOfString("\0", withString: "")
            
            println(respStr); println()
            
            let respData = respStr.dataUsingEncoding(NSUTF8StringEncoding)
            
            var jsonErr: NSError?
            var jsonResult:AnyObject? = NSJSONSerialization.JSONObjectWithData(respData!, options: NSJSONReadingOptions.MutableContainers, error: &jsonErr)
            
            let jsonResponse = JSON(jsonResult!)
            
            if(jsonResponse[0]["meta"]["code"].stringValue == "200")
            {
                let name = jsonResponse[0]["data"]["name"].stringValue
                let email = jsonResponse[0]["data"]["email"].stringValue
                
                var alertString: String = "Hi \(name)! Email: \(email)"
                println(alertString); println()
            }
            else
            {
                println("Login failed!");
                println(jsonResponse); println()
            }
            
            
        })
    }

}
