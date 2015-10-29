//
//  ViewController.swift
//  sample
//
//  Created by Vallavan on 07/10/15.
//  Copyright © 2015 DevelopScripts LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onHTTPRequest(sender: AnyObject) {
        let urlPost = "http://74.86.126.4:8001/login/users"
//        self.post(["firstName": "Dinesh","lastName":"V", "email":"din@auctionsoftware.com", "password": "123456"], url: urlPost)
//        
        var jsonPOST : JSON = [:]
        jsonPOST["firstName"].string = "Dinesh"
        jsonPOST["lastName"].string =  "V"
        jsonPOST["email"].string =  "din@auctionsoftware.com"
        jsonPOST["password"].string =  "123456"
        
        self.postJSON(jsonPOST, url: urlPost)
    }
    
    func post(params : Dictionary<String, String>, url : String) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted)
        } catch {
            //handle error. Probably return or mark function as throws
            print(error)
            return
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            // handle error
            //            guard error == nil else { return }
            
            print("Data: \(data)")
            let json = JSON(data: data!)
            if let statusCode = json["Status Code"].int {
                //Calm down, take it easy, the ".string" property still produces the correct Optional String type with safety
                print("Status Code \(statusCode)")
            } else {
                //Print the error
                print("Improper Key")
            }
            print("Response: \(response)")
            print("Error: \(error)")
            print("Status Code: \(json["Status Code"].intValue)")
            
            //            let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //            print("Body: \(strData)")
            //
            //            let json: NSDictionary?
            //            do {
            //                json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
            //            } catch let dataError {
            //                // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            //                print(dataError)
            //                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //                print("Error could not parse JSON: '\(jsonStr)'")
            //                // return or throw?
            //                return
            //            }
            //
            //
            //            // The JSONObjectWithData constructor didn't return an error. But, we should still
            //            // check and make sure that json has a value using optional binding.
            //            if let parseJSON = json {
            //                // Okay, the parsedJSON is here, let's get the value for 'success' out of it
            //                let success = parseJSON["Status Code"] as? Int
            //                print("Succes: \(success)")
            //            }
            //            else {
            //                // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
            //                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //                print("Error could not parse JSON: \(jsonStr)")
            //            }
            
        })
        
        task.resume()
    }
    
    func postJSON(params : JSON, url : String) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        do {
            //Sending JSON to server
            request.HTTPBody = try params.rawData()
        } catch {
            //handle error. Probably return or mark function as throws
            print(error)
            return
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            // handle error
            guard error == nil else { return }
            
            let json = JSON(data: data!)
            if let statusCode = json["Status Code"].int {
                //Calm down, take it easy, the ".string" property still produces the correct Optional String type with safety
                print("Status Code \(statusCode)")
            } else {
                //Print the error
                print("Improper Key")
            }
            print("Response: \(response)")
            print("Error: \(error)")
            print("Status Code: \(json["Status Code"].intValue)")
        })
        
        task.resume()
    }
    
}

