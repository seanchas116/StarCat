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
import Regex

protocol GitHubRequest: Request {
    var contentLength: Int? { get }
}

struct GetAccessTokenRequest: Request {
    let code: String
    
    typealias Response = AccessToken
    var baseURL: URL {
        return URL(string: "https://github.com")!
    }
    var path: String {
        return "/login/oauth/access_token"
    }
    var method: HTTPMethod {
        return .post
    }
    var parameters: [String : Any] {
        return [
            "client_id": Secrets.githubClientID,
            "client_secret": Secrets.githubClientSecret,
            "code": code
        ]
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> AccessToken {
        do {
            let token: AccessToken = try decodeValue(object)
            return token
        } catch {
            throw "Error parsing response: \(error)"
        }
    }
}

extension GitHubRequest {
    var contentLength: Int? {
        return nil
    }
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    var method: HTTPMethod {
        return .get
    }
    func configureURLRequest(URLRequest: NSMutableURLRequest) throws -> NSMutableURLRequest {
        if let token = Authentication.accessToken {
            URLRequest.setValue("token \(token.token)", forHTTPHeaderField: "Authorization")
        }
        if let contentLength = self.contentLength {
            URLRequest.setValue("\(contentLength)", forHTTPHeaderField: "Content-Length")
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
    var parameters: [String : Any]? {
        return ["page": page]
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Array<Event> {
        do {
            return try decodeArray(object)
        } catch {
            throw "Error parsing response: \(error)"
        }
    }
}

struct GetUserStarsCountRequest: GitHubRequest {
    typealias Response = Int
    let userName: String
    
    var path: String {
        return "/users/\(userName)/starred"
    }
    var parameters: [String : Any]? {
        return ["per_page": 1]
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Int {
        if let link = urlResponse.allHeaderFields["Link"] as? String {
            let lastLinkStr = "<([^>]*)>;\\srel=\"last\"".r?.findFirst(in: link)?.matched
            if let lastLinkStr = lastLinkStr {
                if let lastLink = URL(string: lastLinkStr) {
                    return lastLink.queries["page"].flatMap { Int($0) }!
                }
            }
        }
        throw "Error parsing header"
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
    var parameters: [String : Any]? {
        return ["page": page, "per_page": perPage]
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Array<Repo> {
        do {
            return try decodeArray(object)
        } catch {
            throw "Error parsing response: \(error)"
        }
    }
}

struct GetRepoRequest: GitHubRequest {
    typealias Response = Repo
    let fullName: String
    
    var path: String {
        return "/repos/\(fullName)"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Repo {
        do {
            let repo: Repo = try decodeValue(object)
            return repo
        } catch {
            throw "Error parsing response: \(error)"
        }
    }
}

struct GetUserRequest: GitHubRequest {
    typealias Response = User
    let login: String
    
    var path: String {
        return "/users/\(login)"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> User {
        do {
            let user: User = try decodeValue(object)
            return user
        } catch {
            throw "Error parsing response: \(error)"
        }
    }
}

struct GetMembersRequest: GitHubRequest {
    typealias Response = [UserSummary]
    
    let organizationName: String
    let perPage: Int
    let page: Int
    
    var parameters: [String : Any]? {
        return ["per_page": perPage, "page": page]
    }
    
    var path: String {
        return "/orgs/\(organizationName)/members"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Array<UserSummary> {
        do {
            return try decodeArray(object)
        } catch {
            throw "Error parsing response: \(error)"
        }
    }
}

struct GetCurrentUserRequest: GitHubRequest {
    typealias Response = User
    
    var path: String {
        return "/user"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> User {
        do {
            let user: User = try decodeValue(object)
            return user
        } catch {
            throw "Error parsing response: \(error)"
        }
    }
}

struct GetFollowersRequest: GitHubRequest {
    typealias Response = [UserSummary]
    let userName: String
    let perPage: Int
    let page: Int
    
    var parameters: [String : Any]? {
        return ["per_page": perPage, "page": page]
    }
    
    var path: String {
        return "/users/\(userName)/followers"
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Array<UserSummary> {
        do {
            let users: [UserSummary] = try decodeArray(object)
            return users
        } catch {
            throw "Error parsing response: \(error)"
        }
    }
}

struct GetFollowingRequest: GitHubRequest {
    typealias Response = [UserSummary]
    let userName: String
    let perPage: Int
    let page: Int
    
    var parameters: [String : Any]? {
        return ["per_page": perPage, "page": page]
    }
    
    var path: String {
        return "/users/\(userName)/following"
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Array<UserSummary> {
        do {
            let users: [UserSummary] = try decodeArray(object)
            return users
        } catch {
            throw "Error parsing response: \(error)"
        }
    }
}

struct ReadmeParser: DataParser {
    var contentType: String? {
        return "application/vnd.github.v3.html"
    }
    func parse(data: Data) throws -> Any {
        return String(data: data, encoding: String.Encoding.utf8) ?? ""
    }
}

struct GetReadmeRequest: GitHubRequest {
    typealias Response = String
    
    let fullName: String
    
    var path: String {
        return "/repos/\(fullName)/readme"
    }
    
    var dataParser: DataParser {
        return ReadmeParser()
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> String {
        guard let str = object as? String else {
            throw "Error converting to string"
        }
        return str
    }
}

struct GetDirectoryRequest: GitHubRequest {
    typealias Response = [File]
    
    let repoName: String
    let dirPath: String
    
    var path: String {
        return "/repos/\(repoName)/contents/\(dirPath)"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        do {
            let files: [File] = try decodeArray(object)
            return files
        } catch {
            throw "Error parsing response: \(error)"
        }
    }
}

struct GetFileContentRequest: GitHubRequest {
    typealias Response = FileContent
    
    let repoName: String
    let filePath: String
    
    var path: String {
        return "/repos/\(repoName)/contents/\(filePath)"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        do {
            let file: FileContent = try decodeValue(object)
            return file
        } catch {
            throw "Error parsing response: \(error)"
        }
    }
}

struct SearchRepoResponse {
    let totalCount: Int
    let hasIncompleteResults: Bool
    let items: [Repo]
}

extension SearchRepoResponse: Decodable {
    static func decode(_ e: Extractor) throws -> SearchRepoResponse {
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
    
    var parameters: [String : Any]? {
        return ["q": query, "sort": sort.string, "per_page": perPage, "page": page]
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Array<Repo> {
        do {
            let response: SearchRepoResponse = try decodeValue(object)
            return response.items
        } catch {
            throw "Error parsing response: \(error)"
        }
    }
}

struct AddStarRequest: GitHubRequest {
    typealias Response = Bool
    
    let repoName: String
    
    var method: HTTPMethod {
        return .put
    }
    var path: String {
        return "/user/starred/\(repoName)"
    }
    var contentLength: Int? {
        return 0
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Bool {
        return true
    }
}

struct RemoveStarRequest: GitHubRequest {
    typealias Response = Bool
    
    let repoName: String
    
    var method: HTTPMethod {
        return .delete
    }
    var path: String {
        return "/user/starred/\(repoName)"
    }
    var contentLength: Int? {
        return 0
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Bool {
        return true
    }
}

struct CheckStarredRequest: GitHubRequest {
    typealias Response = Bool
    
    let repoName: String
    
    var path: String {
        return "/user/starred/\(repoName)"
    }
    
    var acceptableStatusCodes: Set<Int> {
        return Set([204, 404])
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Bool {
        if urlResponse.statusCode == 204 {
            return true
        } else {
            return false
        }
    }
}

struct FollowRequest: GitHubRequest {
    typealias Response = Bool
    
    let userName: String
    
    var method: HTTPMethod {
        return .put
    }
    var path: String {
        return "/user/following/\(userName)"
    }
    var contentLength: Int? {
        return 0
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Bool {
        return true
    }
}

struct UnfollowRequest: GitHubRequest {
    typealias Response = Bool
    
    let userName: String
    
    var method: HTTPMethod {
        return .delete
    }
    var path: String {
        return "/user/following/\(userName)"
    }
    var contentLength: Int? {
        return 0
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Bool {
        return true
    }
}


struct CheckFollowedRequest: GitHubRequest {
    typealias Response = Bool
    
    let userName: String
    
    var path: String {
        return "/user/following/\(userName)"
    }
    
    var acceptableStatusCodes: Set<Int> {
        return Set([204, 404])
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Bool {
        if urlResponse.statusCode == 204 {
            return true
        } else {
            return false
        }
    }
}
