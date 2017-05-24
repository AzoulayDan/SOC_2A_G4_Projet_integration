//
//  RequestManager.swift
//  Final_app_news
//
//  Created by Dan Azoulay on 23/05/2017.
//  Copyright © 2017 Dan Azoulay. All rights reserved.
//

import UIKit
import Dispatch

class RequestManager: NSObject {
    
    /* Cette méthode permet d'effectuer un post de connexion */
    @discardableResult
    static func do_post_request_account (atUrl:String, withData:[String:Any]) -> [[String:Any]] {
        var result_request : [[String:Any]]?
        
        DispatchQueue.global(qos: .userInitiated).sync {
            let group = DispatchGroup()
            group.enter()
            
            //Debut de la requete
            let requestObject = NSMutableURLRequest(url: URL(string: atUrl)!)
            requestObject.httpMethod = "POST"
            requestObject.addValue("application/json", forHTTPHeaderField: "Content-Type")
            requestObject.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let posting = JSON(withData)
            requestObject.httpBody = posting.rawString()!.data(using: String.Encoding.utf8)
            print(posting.rawString()!.data(using: String.Encoding.utf8)!)
            
            URLSession.shared.dataTask(with: (requestObject as URLRequest), completionHandler: { (data, response, error) in
                
                if (error != nil) {
                    print(error!.localizedDescription)
                    result_request = [[String:Any]]()
                    group.leave()
                }
                else {
                    let httpcode = (response as? HTTPURLResponse)?.statusCode
                    if (httpcode == 200) {
                        let response_of_server = JSON(data!)
                        result_request = response_of_server.arrayObject as? [[String:Any]]
                        group.leave()
                    }
                    else {
                        print("passage dans le 204, no content")
                        result_request = [[String:Any]]()
                        group.leave()
                    }
                }
            }).resume()
            group.wait()
        }
        print("Arrivé à la fin de la méthode post : \(result_request)")
        return result_request!
    }
    
    /* Cette méthode permet d'effectuer un get sur une url quelconque */
    @discardableResult
    static func do_get_request (atUrl:String) -> [[String:Any]] {
        var result_request: [[String:Any]]?
        
        DispatchQueue.global(qos: .userInitiated).sync {
            let group = DispatchGroup()
            group.enter()
            
            //Debut de la requete
            let requestObject = NSMutableURLRequest(url: URL(string: atUrl)!)
            requestObject.httpMethod = "GET"
            URLSession.shared.dataTask(with: requestObject as URLRequest, completionHandler: { (data, response, error) in
                
                if (error != nil) {
                    print(error!.localizedDescription)
                    result_request = [[String:Any]]()
                    group.leave()
                }
                else {
                    
                    let httpcode = (response as? HTTPURLResponse)?.statusCode
                    if (httpcode != 200) {
                        print("Le code http est \(String(describing: httpcode)) au lieu de 200")
                        result_request = [[String:Any]]()
                        group.leave()
                    }
                    
                    if (httpcode == 200) {
                        let response_of_server = JSON(data!)
                        result_request =  response_of_server.arrayObject as? [[String:Any]]
                        group.leave()
                    }
                    else {
                        result_request = [[String:Any]]()
                        group.leave()
                    }
                }
            }).resume()
            group.wait()
        }
        
        return result_request!
    }
    
    /* Cette méthode permet la création d'un document dans une collection */
    @discardableResult
    static func do_post_request_creation (atUrl:String, withData:[String:Any]) -> String {
        var result_request: String? = ""
        
        DispatchQueue.global(qos: .userInitiated).sync {
            let group = DispatchGroup()
            group.enter()
            
            //Debut de la requete
            let requestObject = NSMutableURLRequest(url: URL(string: atUrl)!)
            requestObject.httpMethod = "POST"
            requestObject.addValue("application/json", forHTTPHeaderField: "Content-Type")
            requestObject.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let posting = JSON(withData)
            requestObject.httpBody = posting.rawString()!.data(using: String.Encoding.utf8)
            print(posting.rawString()!.data(using: String.Encoding.utf8)!)
            
            URLSession.shared.dataTask(with: (requestObject as URLRequest), completionHandler: { (data, response, error) in
                defer {
                    group.leave()
                }
                
                if (error != nil) {
                    print(error!.localizedDescription)
                    result_request = ""
                }
                else {
                    let httpcode = (response as? HTTPURLResponse)?.statusCode
                    if (httpcode == 201) {
                        let the_id = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSString
                        result_request =  the_id as String
                        print(result_request!)
                    }
                }
            }).resume()
            group.wait()
        }
        return result_request!
    }
    
    /* Cette méthode permet de faire un update dans la base de données */
    static func do_patch_request (atUrl:String, withData:[String:Any]) -> Void {
        DispatchQueue.global(qos: .userInitiated).sync {
            let group = DispatchGroup()
            group.enter()
            
            //Début de la requête
            let requestObject = NSMutableURLRequest(url: URL(string: atUrl)!)
            requestObject.httpMethod = "PATCH"
            requestObject.addValue("application/json", forHTTPHeaderField: "Content-Type")
            requestObject.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let datas = JSON(withData)
            requestObject.httpBody = datas.rawString()!.data(using: String.Encoding.utf8)
            
            URLSession.shared.dataTask(with: (requestObject as URLRequest), completionHandler: { (data, response, error) in
                
                if (error != nil) {
                    print(error!.localizedDescription)
                    group.leave()
                }
                else {
                    let httpCode = (response as! HTTPURLResponse).statusCode
                    if (httpCode == 204) {
                        print("The document with id : \(String(describing: withData["id"])) was updated")
                        group.leave()
                    }
                }
            }).resume()
            group.wait()
        }
    }


}
