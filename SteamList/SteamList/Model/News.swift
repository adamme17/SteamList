//
//  News.swift
//  SteamList
//
//  Created by Adam Bokun on 10.12.21.
//

import Foundation

struct FilterNews {
    var filteredNews = [Newsitem]()
    var filteredGames = [FilterItem]()
}

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

class FilterItem: Hashable {
    
    static func == (lhs: FilterItem, rhs: FilterItem) -> Bool {
        lhs.gameID == rhs.gameID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(gameID)
    }
    
    var gameID: String
    var name: String
    var isEnabled: Bool

    init(gameID: String, name: String, isEnabled: Bool) {
        self.gameID = gameID
        self.name = name
        self.isEnabled = isEnabled
    }
}
