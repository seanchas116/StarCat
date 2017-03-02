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
    var parameters: Any? {
        return [
            "client_id": Secrets.githubClientID,
            "client_secret": Secrets.githubClientSecret,
            "code": code
        ]
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> AccessToken {
        let token: AccessToken = try decodeValue(object)
        return token
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
    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        var newRequest = urlRequest
        if let token = Authentication.accessToken {
            newRequest.setValue("token \(token.token)", forHTTPHeaderField: "Authorization")
        }
        if let contentLength = self.contentLength {
            newRequest.setValue("\(contentLength)", forHTTPHeaderField: "Content-Length")
        }
        return newRequest
    }
}

struct GetUserEventsRequest: GitHubRequest {
    typealias Response = [Event]
    let userName: String
    let page: Int
    
    var path: String {
        return "/users/\(userName)/received_events"
    }
    var parameters: Any? {
        return ["page": page]
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Array<Event> {
        return try decodeArray(object)
    }
}

protocol CountFromPaginationRequest: GitHubRequest {
}

extension CountFromPaginationRequest {
    typealias Response = Int
    var parameters: Any? {
        return ["per_page": 1]
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Int {
        guard let link = urlResponse.allHeaderFields["Link"] as? String else {
            throw "Header 'Link' not found in \(urlResponse.url?.absoluteString ?? "")"
        }
        guard let lastLinkStr = "<([^>]*)>;\\srel=\"last\"".r?.findFirst(in: link)?.group(at: 1) else {
            throw "Header format wrong"
        }
        guard let lastLink = URL(string: lastLinkStr) else {
            throw "'last' link invalid"
        }
        guard let page = lastLink.queries["page"] else {
            throw "'page' query not found"
        }
        guard let num = Int(page) else {
            throw "Cannot parse 'page' query as int"
        }
        return num
    }
}

struct GetUserStarsCountRequest: CountFromPaginationRequest {
    let userName: String
    
    var path: String {
        return "/users/\(userName)/starred"
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
    var parameters: Any? {
        return ["page": page, "per_page": perPage]
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Array<Repo> {
        return try decodeArray(object)
    }
}

struct GetRepoRequest: GitHubRequest {
    typealias Response = Repo
    let fullName: String
    
    var path: String {
        return "/repos/\(fullName)"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Repo {
        let repo: Repo = try decodeValue(object)
        return repo
    }
}

struct GetUserRequest: GitHubRequest {
    typealias Response = User
    let login: String
    
    var path: String {
        return "/users/\(login)"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> User {
        let user: User = try decodeValue(object)
        return user
    }
}

struct GetMemberCountRequest: CountFromPaginationRequest {
    let organizationName: String
    
    var path: String {
        return "/orgs/\(organizationName)/members"
    }
}

struct GetMembersRequest: GitHubRequest {
    typealias Response = [UserSummary]
    
    let organizationName: String
    let perPage: Int
    let page: Int
    
    var parameters: Any? {
        return ["per_page": perPage, "page": page]
    }
    
    var path: String {
        return "/orgs/\(organizationName)/members"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Array<UserSummary> {
        return try decodeArray(object)
    }
}

struct GetCurrentUserRequest: GitHubRequest {
    typealias Response = User
    
    var path: String {
        return "/user"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> User {
        let user: User = try decodeValue(object)
        return user
    }
}

struct GetFollowersRequest: GitHubRequest {
    typealias Response = [UserSummary]
    let userName: String
    let perPage: Int
    let page: Int
    
    var parameters: Any? {
        return ["per_page": perPage, "page": page]
    }
    
    var path: String {
        return "/users/\(userName)/followers"
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Array<UserSummary> {
        let users: [UserSummary] = try decodeArray(object)
        return users
    }
}

struct GetFollowingRequest: GitHubRequest {
    typealias Response = [UserSummary]
    let userName: String
    let perPage: Int
    let page: Int
    
    var parameters: Any? {
        return ["per_page": perPage, "page": page]
    }
    
    var path: String {
        return "/users/\(userName)/following"
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Array<UserSummary> {
        let users: [UserSummary] = try decodeArray(object)
        return users
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
        let files: [File] = try decodeArray(object)
        return files
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
        let file: FileContent = try decodeValue(object)
        return file
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
    
    var parameters: Any? {
        return ["q": query, "sort": sort.string, "per_page": perPage, "page": page]
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Array<Repo> {
        let response: SearchRepoResponse = try decodeValue(object)
        return response.items
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
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        let statusCode = urlResponse.statusCode
        if statusCode != 204 && statusCode != 404 {
            throw APIKit.ResponseError.unacceptableStatusCode(statusCode)
        }
        return object
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
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        let statusCode = urlResponse.statusCode
        if statusCode != 204 && statusCode != 404 {
            throw APIKit.ResponseError.unacceptableStatusCode(statusCode)
        }
        return object
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Bool {
        if urlResponse.statusCode == 204 {
            return true
        } else {
            return false
        }
    }
}
