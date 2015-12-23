//
//  GitHubAPI.swift
//  StarCat
//
//  Created by 池上涼平 on 2015/12/22.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import Foundation
import APIKit

protocol GitHubRequest: RequestType {
    
}

extension GitHubRequest {
    var baseURL: NSURL {
        return NSURL(string: "https://api.github.com")!
    }
    func configureURLRequest(URLRequest: NSMutableURLRequest) throws -> NSMutableURLRequest {
        URLRequest.setValue("token \(Constants.githubAccessToken)", forHTTPHeaderField: "Authorization")
        return URLRequest
    }
}

extension User {
    static func fromDictionary(dict: [String: AnyObject]) -> User {
        let id = dict["id"] as! Int
        let login = dict["login"] as! String
        let avatarURL = dict["avatar_url"] as! String
        return User(id: id, login: login, avatarURL: NSURL(string: avatarURL)!)
    }
}

extension Repo {
    static func fromDictionary(dict: [String: AnyObject]) -> Repo {
        return Repo(id: dict["id"] as! Int, name: dict["name"] as! String)
    }
}

extension Event {
    static func fromDictionary(dict: [String: AnyObject]) -> Event? {
        switch dict["type"] as! String {
        case "WatchEvent":
            let actor = User.fromDictionary(dict["actor"] as! [String: AnyObject])
            let repo = Repo.fromDictionary(dict["repo"] as! [String: AnyObject])
            return .Star(actor, repo)
        default:
            return nil
        }
    }
}

struct GetUserEventsRequest: GitHubRequest {
    typealias Response = [Event]
    let userName: String
    
    init(let userName: String) {
        self.userName = userName
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var path: String {
        return "/users/\(userName)/received_events"
    }
    
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        guard let events = object as? [AnyObject] else {
            return nil
        }
        return events.flatMap { ev in Event.fromDictionary(object as! [String: AnyObject]) }
    }
}
