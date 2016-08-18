//
//  Utility.swift
//  settingsMyTests
//
//  Created by Zacharias Giakoumi on 08/08/16.
//  Copyright © 2016 Zacharias Giakoumi. All rights reserved.
//

import UIKit
import Foundation

protocol ApiServiceDelegate {
    
    
   
    func serviceCallDidFinish(responseString : NSString)
    
}


class Utility: NSObject {

    
    var apiDelegate :ApiServiceDelegate!
    
    private static var response : String! =   "testVar1"
    private static var testVar2 : String! =   "testVar2"
    
    static func getresponse()-> String{
        
        return response
        
    }
    static func gettestVar2()-> String{
        
        return testVar2
        
    }
    
    
    
    static func setresponse(response : String){
        self.response =  response
        
    }
    
    static func setNECoord(testVar : String){
        
        self.testVar2 =  testVar
        
    }

    
     func getResponse(response: String) {
    
        apiDelegate.serviceCallDidFinish(response)
        
    }
    
    
     func makeTheRequestPost(request : NSString)  {
        
     
       
       
        let url = request
        print("request url \(url)")
        
        let request = NSMutableURLRequest(URL: NSURL(string: url as String)!)
        request.HTTPMethod = "POST"
        
        //request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
          //  print("responseString = \(responseString!)")
            
            
          self.apiDelegate.serviceCallDidFinish(responseString!)
            
            
            
            
            
        }
        task.resume()
        // return ruternResponse
    }

    
    
    
     func ServiceRequest( apiMethod: String, params : String ) {
        
        let serviceIP = ""
        //let request = String(format: "http://\(serviceIP)\(apiMethod)?\(params)")
        let request = String(format: "http://\(serviceIP)\(apiMethod)")
       
        
         self.makeTheRequestPost(request)
        
    }
    
    struct apiMethod
    {
        static let Url_Api_1 = "api/1url"
        static let Url_Api_2 = "api/2url"
        static let googleUrl = "google.com"
        
    }

    
    static func myObjectToString (Obj : AnyObject){
        print("\(Obj.description)")
    }
    static func getAppVersion ()-> String{
        var versionStr : String = ""
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            versionStr = version
        }
        return versionStr
        
    }
    static func getAppName()-> String{
      
        var appName : String = ""
        appName =  NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
        return appName
        
    }
    
}
