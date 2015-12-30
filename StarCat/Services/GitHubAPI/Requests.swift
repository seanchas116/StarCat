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
    
    var path: String {
        return "/users/\(userName)/received_events"
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