//
//  APIController.swift
//  rush00
//
//  Created by Claudio MUTTI on 10/6/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit
import Foundation

class APIController {
    private static let clientId = "3bcad0dc38836cb4f099bfabb4dbc9e5f55cc525167903f3554285603962138e"
    private static let secretId = "2b7fcf10452667988f80f3abea331a9b5538458249054ddc3ed84a11a72c9502"
    static let authLink = "https://api.intra.42.fr/oauth/authorize?client_id=3bcad0dc38836cb4f099bfabb4dbc9e5f55cc525167903f3554285603962138e&redirect_uri=fr42Rush00Scheme%3A%2F%2Fcallback&response_type=code&scope=public%20forum"
    private static var code: String? = nil
    private static var uri = "fr42Rush00Scheme%3A%2F%2Fcallback"
    
    private static var accessToken = "c6bbc7076e33d914be77b06f63e11be6c7b52cc975512b6f3c231cc8b6f70213"
    private static var refreshToken = "cd43b9b6c6a1f7d3ba39f61dc1a3715c61a3e02eaf5b1822c2f112e297a6b6b7"
    
    static var currentView : UIViewController? = nil
    
    static let pageSize = 30
    
    static var userId = 16894 // cmutti = 16894, nsayah =
    
    static func getToken(action: @escaping (Bool) -> Void) {
        if canSkipAuth() {
            if userId < 0 {
                getUserId {
                    success in
                    action(success)
                }
                return
            }
            action(true)
            return
        }
        
        let url = NSURL(string: "https://api.intra.42.fr/oauth/token")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = ("grant_type=authorization_code&client_id=\(clientId)&client_secret=\(secretId)&code=\(code!)&redirect_uri=\(uri)").data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
//            print("Response\n", response as Any)
            var success = false
            if let err = error {
                print("Error in URL response\n", err)
            }
            else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
//                        print("Full Token Answer\n", dic)
                        if let accessTok = dic.value(forKey: "access_token") as? String, let refreshTok = dic.value(forKey: "refresh_token") as? String {
                            print("Acces Token: " + accessTok)
                            accessToken = accessTok
                            refreshToken = refreshTok
                            success = true
                        }
                        else {
                            print("No access token found")
                        }
                    }
                    else {
                        print("Cannot cast to NSDictionary")
                    }
                }
                catch (let err) {
                    print("Catched Error\n", err)
                }
            }
            
            if success {
                getUserId {_ in
                    action(success)
                }
            }
            else {
                action(success)
            }
        }
        task.resume()
    }
    
    static func getUserId(action: @escaping (Bool) -> Void) {
        let url = "https://api.intra.42.fr/v2/me"
        makeApiGetRequest(urlString: url, finishAction: {success, _, _ in action(success) }) {
            data in
            var success = false
            do {
                let dico: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//                print("UserInfo\n", dico)
                if let id = dico.value(forKey: "id") as? Int {
                    print("UserId: \(id)")
                    success = true
                    self.userId = id
                }
                else {
                    print("No UserId")
                }
            }
            catch (let err) {
                print("Catched Error\n", err)
            }
            
            return (success, [Any]())
        }
    }
    
    static func getTopics(page: Int, action: @escaping (Bool, [Any], Int) -> Void) {
        
        let url = "https://api.intra.42.fr/v2/topics?page=\(page)"
        makeApiGetRequest(urlString: url, finishAction: action) {
            data in
            var success = false
            var topicArray = [Topic]()
            do {
                let array: [NSDictionary] = try JSONSerialization.jsonObject(with: data, options:[]) as! [NSDictionary]
                //                    print(array)
                success = true
                for elem in array {
                    if  let id = elem.value(forKey: "id") as? Int,
                        let auth = elem.value(forKey: "author") as? NSDictionary,
                        let name = elem.value(forKey: "name") as? String,
                        let date = elem.value(forKey: "created_at") as? String,
                        let login = auth.value(forKey: "login") as? String {
//                        print("Login: \(login)\nName: \(name)\nDate: \(date)\n")
                        topicArray.append(Topic(userName: login, createDate: self.UTCToLocal(UTCDateString: date), topicTitle: name, id: id))
                    }
                    else {
                        print("Some errors..\n")
                        success = false
                        break
                    }
                }
            }
            catch (let err) {
                print("Catched Error\n", err)
            }
            return (success, topicArray)
        }
    }
    
    static func getTopicMessages(id: Int, action: @escaping (Bool, [Any], Int) -> Void) {
        
        let url = "https://api.intra.42.fr/v2/topics/\(id)/messages"
        makeApiGetRequest(urlString: url, finishAction: action) {
            data in
            var success = false
            var myArray = [TopicMessage]()
            do {
//                print("Data test : \(data)\n")
                
                if let dic : NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    print("ERROR\n", dic)
                }
                else {
                    let array: [NSDictionary] = try JSONSerialization.jsonObject(with: data, options:[]) as! [NSDictionary]
//                    print("Array test : \(array.description)\n")
                    success = true
                    for elem in array {
                        if  let id = elem.value(forKey: "id") as? Int,
                            let content = elem.value(forKey: "content") as? String,
                            let date = elem.value(forKey: "created_at") as? String,
                            let auth = elem.value(forKey: "author") as? NSDictionary,
                            let login = auth.value(forKey: "login") as? String {
                            
//                            print("Login: \(login)\nContent: \(content)\nDate: \(date)")
                            // Fetch replies
                            var replies = [MessageReply]()
                            if let repliesArray = elem.value(forKey: "replies") as? [NSDictionary] {
                                for reply in repliesArray {
                                    if  let r_content = reply.value(forKey: "content") as? String,
                                        let r_date = reply.value(forKey: "created_at") as? String,
                                        let r_auth = reply.value(forKey: "author") as? NSDictionary,
                                        let r_login = r_auth.value(forKey: "login") as? String {
//                                        print("\tLogin: \(r_login)\n\tContent: \(r_content)\n\tDate: \(r_date)")
                                        replies.append(MessageReply(userName: r_login, createDate: self.UTCToLocal(UTCDateString: r_date), reply: r_content))
                                    }
                                    else {
                                        print("Some errors in reply..\n")
                                        success = false
                                        break
                                    }
                                }
                            }
                            else {
                                print("\tNo replies")
                            }
                            print("")
                            myArray.append(TopicMessage(id: id, userName: login, createDate: self.UTCToLocal(UTCDateString: date), message: content, replies: replies))
                        }
                        else {
                            print("Some errors in message..\n")
                            success = false
                            break
                        }
                    }
                }
            }
            catch (let err) {
                print("Catched Error\n", err)
            }
            return (success, myArray)
        }
    }

    private static func makeApiGetRequest(urlString: String, finishAction: @escaping (Bool, [Any], Int) -> Void,
                                       treatDataAction: @escaping (Data) -> (Bool, [Any])) {
//        print("\nRequested: \(urlString)")
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            var success = false
            var myArray = [Any]()
            var totalElem: Int = -1
//            print("Response\n", response as Any)
            if let err = error {
                print("Error in URL response\n", err)
            }
            else if let httpResponse = response as? HTTPURLResponse,
                let headers = httpResponse.allHeaderFields as? NSDictionary,
                httpResponse.statusCode == 200 {
//                print("\tPositive httpResponse")
                
                // Sometimes httpResponse doesnt have a pagination
                if let pageSize = headers.value(forKey: "X-Per-Page") as? String,
                    let link = headers.value(forKey: "Link") as? String,
                    let index = link.range(of: ">; rel=\"last\"")?.lowerBound {
//                        print("Headers\n", headers)
                    
                    // Get total elems from Header
                    var pageNbr = String (link[..<index])
                    var index = link.range(of: "page=")?.upperBound
                    while let idx = index {
                        pageNbr = String (pageNbr[idx...])
                        index = pageNbr.range(of: "page=")?.upperBound
                    }
                    totalElem = Int(pageSize)! * Int(pageNbr)!
//                        print("Total Elems: \(totalElem)")
                }
                
                // Treat data
                if let d = data {
                    (success, myArray) = treatDataAction(d)
                    if success, totalElem < 0 {
                        totalElem = myArray.count
                    }
                }
                else {
                    print("No data")
                }
            }
            else {
                print("Error in Headers")
            }
            
            finishAction(success, myArray, totalElem)
        }
        task.resume()
    }
    
    static func addMessage(to topicId: Int, message: String, action: @escaping (Bool, Any?) -> Void) {
        
        let url = "https://api.intra.42.fr/v2/topics/\(topicId)/messages"
        let json = "{\"message\": {\"author_id\": \"\(userId)\",\"content\": \"\(message)\"}}"
        makeApiPostRequest(urlString: url, json: json, finishAction: action) {
            data in
            let postedData = TopicMessage(id: 0, userName: "test", createDate: "", message: "", replies: [MessageReply]())
            let success = true
            
            do {
                if let dic : NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    print("Full Post\n", dic)
                    if  let id = dic.value(forKey: "id") as? Int,
                        let content = dic.value(forKey: "content") as? String,
                        let date = dic.value(forKey: "created_at") as? String,
                        let auth = dic.value(forKey: "author") as? NSDictionary,
                        let login = auth.value(forKey: "login") as? String {
                        postedData.userName = login
                        postedData.createDate = UTCToLocal(UTCDateString: date)
                        postedData.message = content
                        postedData.id = id
                    }
                }
                else {
                    print("Cannot cast to NSDictionary")
                }
            }
            catch (let err) {
                print("Catched Error\n", err)
            }

            
            return (success, postedData)
        }
    }
    
    private static func makeApiPostRequest(urlString: String, json: String, finishAction: @escaping (Bool, Any?) -> Void,
                                          treatDataAction: @escaping (Data) -> (Bool, Any?)) {
        
//        print("\nPOST Requested:\n\t\(urlString)\n\t\(json)")
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            var success = false
            var postedData : Any? = nil
            //            print("Response\n", response as Any)
            if let err = error {
                print("Error in URL response\n", err)
            }
            else if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 201 {
//                print("\tPositive httpResponse")
                
                // Treat data
                if let d = data {
                    (success, postedData) = treatDataAction(d)
                }
                else {
                    print("No data")
                }
            }
            else {
                print("Error in Headers")
            }
            
            finishAction(success, postedData)
        }
        task.resume()
    }
    
    static func updateCode(rawCode: String) {
        code = rawCode.replacingOccurrences(of: "fr42rush00scheme://callback?code=", with: "", options: .literal, range: nil)
    }
    
    static private func UTCToLocal(UTCDateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" //Input Format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let UTCDate = dateFormatter.date(from: UTCDateString)
        
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm" // Output Format
        dateFormatter.timeZone = TimeZone.current
        let UTCToCurrentFormat = dateFormatter.string(from: UTCDate!)
        
        return UTCToCurrentFormat
    }
    
    static func canSkipAuth() -> Bool {
        return (accessToken != "")
    }
}
