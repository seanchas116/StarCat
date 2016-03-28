//
//  Decodables.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2015/12/28.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import Foundation
import Himotoki
import SwiftDate

enum DecodeError: ErrorType {
    case WrongURL(String)
    case WrongUserType(String)
    case WrongFileType(String)
}

extension Link: Decodable {
    static func decode(e: Extractor) throws -> Link {
        let str = try String.decode(e)
        if let link = Link(string: str) {
            return link
        } else {
            throw Himotoki.DecodeError.MissingKeyPath(KeyPath())
        }
    }
}

extension NSDate: Decodable {
    public static func decode(e: Extractor) throws -> NSDate {
        let str = try String.decode(e)
        return str.toDate(DateFormat.ISO8601Format(.Full)) ?? NSDate()
    }
}

extension UserType: Decodable {
    static func decode(e: Extractor) throws -> UserType {
        let str = try String.decode(e)
        switch str {
        case "User":
            return .User
        case "Organization":
            return .Organization
        default:
            throw DecodeError.WrongUserType(str)
        }
    }
}

extension User: Decodable {
    static func decode(e: Extractor) throws -> User {
        return try User(
            type: e <| "type",
            id: e <| "id",
            login: e <| "login",
            name: e <|? "name",
            avatarURL: e <| "avatar_url",
            company: e <|? "company",
            location: e <|? "location",
            blog: e <|? "blog",
            email: e <|? "email",
            followers: e <| "followers",
            following: e <| "following"
        )
    }
}

extension UserSummary: Decodable {
    static func decode(e: Extractor) throws -> UserSummary {
        return try UserSummary(
            id: e <| "id",
            login: e <| "login",
            avatarURL: e <| "avatar_url",
            type: e <|? "type"
        )
    }
}

extension Repo: Decodable {
    static func decode(e: Extractor) throws -> Repo {
        return try Repo(
            id: e <| "id",
            owner: e <| "owner",
            name: e <| "name",
            fullName: e <| "full_name",
            description: e <|? "description",
            starsCount: e <| "stargazers_count",
            language: e <|? "language",
            homepage: e <|? "homepage",
            pushedAt: e <| "pushed_at"
        )
    }
}

extension RepoSummary: Decodable {
    static func decode(e: Extractor) throws -> RepoSummary {
        return try RepoSummary(
            id: e <| "id",
            fullName: e <| "name"
        )
    }
}

extension FileType: Decodable {
    static func decode(e: Extractor) throws -> FileType {
        let str = try String.decode(e)
        switch str {
        case "file":
            return .File
        case "dir":
            return .Dir
        default:
            throw DecodeError.WrongFileType(str)
        }
    }
}

extension File: Decodable {
    static func decode(e: Extractor) throws -> File {
        return try File(
            type: e <| "type",
            name: e <| "name",
            path: e <| "path"
        )
    }
}

extension FileContent: Decodable {
    static func decode(e: Extractor) throws -> FileContent {
        return try FileContent(
            content: e <| "content"
        )
    }
}

extension Event: Decodable {
    static func decode(e: Extractor) throws -> Event {
        let type: String = try e <| "type"
        let createdAt: NSDate = try e <| "created_at"
        switch type {
        case "WatchEvent":
            let actor: UserSummary = try e <| "actor"
            let repo: RepoSummary = try e <| "repo"
            return Event(content: .Star(actor, repo), createdAt: createdAt)
        default:
            return Event(content: .Unknown, createdAt: createdAt)
        }
    }
}

extension AccessToken: Decodable {
    static func decode(e: Extractor) throws -> AccessToken {
        return try AccessToken(
            token: e <| "access_token",
            scope: e <| "scope"
        )
    }
}