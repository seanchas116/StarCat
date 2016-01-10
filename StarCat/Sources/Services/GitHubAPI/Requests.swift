//
//  Requests.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2015/12/28.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import Foundation
import APIKit
import Himotoki

protocol GitHubRequest: RequestType {
}

extension GitHubRequest {
    var baseURL: NSURL {
        return NSURL(string: "https://api.github.com")!
    }
    var method: HTTPMethod {
        return .GET
    }
    func configureURLRequest(URLRequest: NSMutableURLRequest) throws -> NSMutableURLRequest {
        if let token = Authentication.accessToken {
            URLRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }
        return URLRequest
    }
}

struct GetUserEventsRequest: GitHubRequest {
    typealias Response = [Event]
    let userName: String
    let page: Int
    
    var path: String {
        return "/users/\(userName)/received_events"
    }
    var parameters: [String: AnyObject] {
        return ["page": page]
    }
    
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        do {
            return try decodeArray(object)
        } catch {
            print("Error parsing response: \(error)")
            return nil
        }
    }
}

struct GetRepoRequest: GitHubRequest {
    typealias Response = Repo
    let fullName: String
    
    var path: String {
        return "/repos/\(fullName)"
    }
    
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        do {
            let repo: Repo = try decode(object)
            return repo
        } catch {
            print("Error parsing response: \(error)")
            return nil
        }
    }
}

struct GetUserRequest: GitHubRequest {
    typealias Response = User
    let login: String
    
    var path: String {
        return "/users/\(login)"
    }
    
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        do {
            let user: User = try decode(object)
            return user
        } catch {
            print("Error parsing response: \(error)")
            return nil
        }
    }
}

struct GetReadmeRequest: GitHubRequest {
    typealias Response = String
    
    let fullName: String
    
    var path: String {
        return "/repos/\(fullName)/readme"
    }
    
    var responseBodyParser: ResponseBodyParser {
        get {
            return .Custom(acceptHeader: "application/vnd.github.v3.html", parseData: { data in
                return NSString(data: data, encoding: NSUTF8StringEncoding) ?? ""
            })
        }
    }
    
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        return object as? String
    }
}