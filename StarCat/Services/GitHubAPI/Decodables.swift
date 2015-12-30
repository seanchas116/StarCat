//
//  Decodables.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2015/12/28.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import Foundation
import Himotoki

extension NSURL: Decodable {
    public static func decode(e: Extractor) throws -> NSURL {
        return try NSURL(string: String.decode(e))!
    }
}

extension UserSummary: Decodable {
    static func decode(e: Extractor) throws -> UserSummary {
        return try UserSummary(
            id: e <| "id",
            login: e <| "login",
            avatarURL: e <| "avatar_url"
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
            language: e <|? "language"
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

extension Event: Decodable {
    static func decode(e: Extractor) throws -> Event {
        let type: String = try e <| "type"
        switch type {
        case "WatchEvent":
            let actor: UserSummary = try e <| "actor"
            let repo: RepoSummary = try e <| "repo"
            return .Star(actor, repo)
        default:
            return .Unknown
        }
    }
}
