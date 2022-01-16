//
//  News.swift
//  SteamList
//
//  Created by Adam Bokun on 10.12.21.
//

import Foundation

struct Appnews: Codable {
    let appid: Int
    let newsitems: [Newsitem]
    let count: Int
}

// MARK: - Newsitem
struct Newsitem: Codable {
    let gid, title: String
    let url: String
    let isExternalURL: Bool
    let author, contents, feedlabel: String
    let date: Int
    let feedname: String
    let feedType, appid: Int

    enum CodingKeys: String, CodingKey {
        case gid, title, url
        case isExternalURL = "is_external_url"
        case author, contents, feedlabel, date, feedname
        case feedType = "feed_type"
        case appid
    }
}
