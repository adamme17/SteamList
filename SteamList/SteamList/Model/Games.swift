//
//  Games.swift
//  SteamList
//
//  Created by Adam Bokun on 17.11.21.
//

import Foundation

struct GamesList: Codable {
    var applist: Apps
}

struct Apps: Codable {
    var apps: [Games]
}

struct Games: Codable {
    let appid: Int
    let name: String
    let isFavorite: Bool

    init(appId: Int, name: String, isFavorite: Bool = false) {
        self.appid = appId
        self.name = name
        self.isFavorite = isFavorite
    }

    enum CodingKeys: String, CodingKey {
        case appid
        case name
        case isFavorite
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.appid = try container.decode(Int.self, forKey: .appid)
        self.name = try container.decode(String.self, forKey: .name)
        self.isFavorite = false
    }
}
