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

struct GetAccessTokenRequest: RequestType {
    let code: String
    
    typealias Response = AccessToken
    var baseURL: NSURL {
        return NSURL(string: "https://github.com")!
    }
    var path: String {
        return "/login/oauth/access_token"
    }
    var method: HTTPMethod {
        return .POST
    }
    var parameters: [String: AnyObject] {
        return [
            "client_id": Secrets.githubClientID,
            "client_secret": Secrets.githubClientSecret,
            "code": code
        ]
    }
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> AccessToken? {
        do {
            let token: AccessToken = try decode(object)
            return token
        } catch {
            print("Error parsing response: \(error)")
            return nil
        }
    }
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
            URLRequest.setValue("token \(token.token)", forHTTPHeaderField: "Authorization")
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

struct GetUserStarsCountRequest: GitHubRequest {
    typealias Response = Int
    let userName: String
    
    var path: String {
        return "/users/\(userName)/starred"
    }
    var parameters: [String: AnyObject] {
        return ["per_page": 1]
    }
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Int? {
        if let link = URLResponse.allHeaderFields["Link"] as? String {
            let match = link.grep("<([^>]*)>;\\srel=\"last\"")
            if match {
                if let lastLink = NSURL(string: match.captures[1]) {
                    return lastLink.queries["page"].flatMap { Int($0) }
                }
            }
        }
        return nil
    }
}

struct GetUserStarsRequest: GitHubRequest {
    typealias Response = [Repo]
    let userName: String
    let perPage: Int
    let page: Int
    
    var path: String {
        return "/users/\(userName)/starred"
    }
    var parameters: [String: AnyObject] {
        return ["page": page, "per_page": perPage]
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

struct GetCurrentUserRequest: GitHubRequest {
    typealias Response = User
    var path: String {
        return "/user"
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

struct GetFollowersRequest: GitHubRequest {
    typealias Response = [UserSummary]
    let userName: String
    let perPage: Int
    let page: Int
    
    var parameters: [String: AnyObject] {
        return ["per_page": perPage, "page": page]
    }
    
    var path: String {
        return "/users/\(userName)/followers"
    }
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        do {
            let users: [UserSummary] = try decodeArray(object)
            return users
        } catch {
            print("Error parsing response: \(error)")
            return nil
        }
    }
}

struct GetFollowingRequest: GitHubRequest {
    typealias Response = [UserSummary]
    let userName: String
    let perPage: Int
    let page: Int
    
    var parameters: [String: AnyObject] {
        return ["per_page": perPage, "page": page]
    }
    
    var path: String {
        return "/users/\(userName)/following"
    }
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        do {
            let users: [UserSummary] = try decodeArray(object)
            return users
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

struct GetDirectoryRequest: GitHubRequest {
    typealias Response = [File]
    
    let repoName: String
    let dirPath: String
    
    var path: String {
        return "/repos/\(repoName)/contents/\(dirPath)"
    }
    
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        do {
            let files: [File] = try decodeArray(object)
            return files
        } catch {
            print("Error parsing response: \(error)")
            return nil
        }
    }
}

struct SearchRepoResponse {
    let totalCount: Int
    let hasIncompleteResults: Bool
    let items: [Repo]
}

extension SearchRepoResponse: Decodable {
    static func decode(e: Extractor) throws -> SearchRepoResponse {
        return try SearchRepoResponse(
            totalCount: e <| "total_count",
            hasIncompleteResults: e <| "incomplete_results",
            items: e <|| "items"
        )
    }
}

enum SearchRepoSortType {
    case BestMatch
    case Stars
    case Forks
    case Updated
    
    var string: String {
        switch self {
        case .BestMatch:
            return ""
        case .Stars:
            return "stars"
        case .Forks:
            return "forks"
        case .Updated:
            return "updated"
        }
    }
}

struct SearchRepoRequest: GitHubRequest {
    typealias Response = [Repo]
    
    let query: String
    let sort: SearchRepoSortType
    let perPage: Int
    let page: Int
    
    var path: String {
        return "/search/repositories"
    }
    
    var parameters: [String: AnyObject] {
        return ["q": query, "sort": sort.string, "per_page": perPage, "page": page]
    }
    
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        do {
            let response: SearchRepoResponse = try decode(object)
            return response.items
        } catch {
            print("Error parsing response: \(error)")
            return nil
        }
    }
}
