//
//  SteamEndPoints.swift
//  SteamList
//
//  Created by Adam Bokun on 22.11.21.
//

import Foundation

enum SteamEndPoints {
    case getGamesList
    case getGameDetailsList(appId: Int)
    case getGameNews(appId: Int, number: Int)
}

extension SteamEndPoints {
    var baseUrl: String {
        switch self {
        case .getGamesList:
            return "https://api.steampowered.com/ISteamApps/GetAppList/v2/?"
        case .getGameDetailsList(appId: let appId):
            return "https://store.steampowered.com/api/appdetails?appids=\(appId)"
        case .getGameNews(appId: let appId, number: let number):
            return "https://api.steampowered.com/ISteamNews/GetNewsForApp/v2/?appid=\(appId)&count=\(number)"
        }
    }
}
