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

    init(appId: Int, name: String) {
        self.appid = appId
        self.name = name
    }
}
