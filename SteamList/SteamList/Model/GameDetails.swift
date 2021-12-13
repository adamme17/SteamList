//
//  DetailGameModel.swift
//  SteamList
//
//  Created by Adam Bokun on 7.12.21.
//

import Foundation
import UIKit

struct GameDetailsList: Codable {
    var appid: AppsId?
    
    struct CustomCodingKeys: CodingKey {

        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
        var value: AppsId?
        for key in container.allKeys {
            value = try container.decode(AppsId.self, forKey: CustomCodingKeys(stringValue: key.stringValue)!)
        }
        if let gameDecode = value {
            appid = gameDecode
        } else {
            appid = nil
        }
    }
}

struct AppsId: Codable {
    var success: Bool
    var data: [Details]
}

struct Details: Codable {
    var type: String
    var name: String
    var appId: Int
    var age: Int
    var description: String
    var image: String?
    var platforms: [Platforms]
    var genres: [Genres]
    var screenshots: [Screens]?

//    init(appId: Int, name: String, type: String, age: Int, description: String, image: URL) {
//        self.type = type
//        self.name = name
//        self.steam_appid = appId
//        self.required_age = age
//        self.short_description = description
//        self.header_image = image
//    }

    enum CodingKeys: String, CodingKey {
        case type
        case name
        case appId = "steam_appid"
        case age = "required_age"
        case description = "short_description"
        case image = "header_image"
        case platforms
        case genres
        case screenshots
    }

//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.type = try container.decode(String.self, forKey: .type)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.steam_appid = try container.decode(Int.self, forKey: .steam_appid)
//        self.required_age = try container.decode(Int.self, forKey: .required_age)
//        self.short_description = try container.decode(String.self, forKey: .short_description)
//        self.header_image = try container.decode(URL.self, forKey: .header_image)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        
//    }
}

struct Platforms: Codable {
    var windows: Bool
    var mac: Bool
    var linux: Bool
}

struct Genres: Codable {
    let id: Int
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
    }
}

struct Screens: Codable {
    let id: Int
    let path: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case path = "path_full"
    }
}

