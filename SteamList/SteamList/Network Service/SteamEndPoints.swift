//
//  SteamEndPoints.swift
//  SteamList
//
//  Created by Adam Bokun on 22.11.21.
//

import Foundation

enum SteamEndPoints {
    case getGamesList
}
extension SteamEndPoints {
    var baseUrl: String {
        switch self {
        case .getGamesList:
            return "https://api.steampowered.com/ISteamApps/GetAppList/v2/?"
        }
    }
}
