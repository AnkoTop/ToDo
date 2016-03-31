//
//  APIClient.swift
//  ToDo
//
//  Created by Anko Top on 30/03/16.
//  Copyright © 2016 Anko Top. All rights reserved.
//

import Foundation

enum WebserviceError : ErrorType {
    case DataEmptyError
    case ResponseError
}

class APIClient {
    
    lazy var session: ToDoURLSession = NSURLSession.sharedSession()
    var keychainManager: KeychainAccessible?
    
    func loginUserWithName(username: String, password: String, completion: (ErrorType?) -> Void) {
        let allowedCharacters = NSCharacterSet(charactersInString: "/%&=?$#+-~@<>|\\*,.()[]{}^!").invertedSet
        
        guard let encodedUsername = username.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters) else {
            fatalError()
        }
       
        guard let encodedPassword = password.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters) else {
            fatalError()
        }
        
        guard let url = NSURL(string: "https://awesometodos.com/login?username=\(encodedUsername)&password=\(encodedPassword)") else
        { fatalError() }
        
        let task = session.dataTaskWithURL(url) { (data, response,
            error) -> Void in
            
            if error != nil {
                completion(WebserviceError.ResponseError)
                return
            }
            
            
            if let theData = data {
                do {
                    let responseDict = try NSJSONSerialization.JSONObjectWithData(theData, options: [])
                    
                    let token = responseDict["token"] as! String
                    self.keychainManager?.setPassword(token, account: "token")
                } catch {
                    completion(error)
                }
            } else {
                completion(WebserviceError.DataEmptyError)
            }
        }
        
        task.resume()
    }
    
}

protocol ToDoURLSession {
    
    func dataTaskWithURL(url: NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask
}

extension NSURLSession : ToDoURLSession {
    
}