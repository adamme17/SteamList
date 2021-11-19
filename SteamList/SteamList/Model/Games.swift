//
//  Games.swift
//  SteamList
//
//  Created by Adam Bokun on 17.11.21.
//

import Foundation

struct Games: Codable {
    let app_id: Int
    let name: String
    
    init(app_id: Int, name: String) {
        self.app_id = app_id
        self.name = name
    }
}
