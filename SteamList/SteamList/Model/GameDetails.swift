//
//  DetailGameModel.swift
//  SteamList
//
//  Created by Adam Bokun on 7.12.21.
//

import Foundation
import UIKit

//struct GameDetailsList: Codable {
//    var appid: AppsId?
//
//    struct CustomCodingKeys: CodingKey {
//
//        var stringValue: String
//        init?(stringValue: String) {
//            self.stringValue = stringValue
//        }
//        var intValue: Int?
//        init?(intValue: Int) {
//            return nil
//        }
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
//        var value: AppsId?
//        for key in container.allKeys {
//            value = try container.decode(AppsId.self, forKey: CustomCodingKeys(stringValue: key.stringValue)!)
//        }
//        if let gameDecode = value {
//            appid = gameDecode
//        } else {
//            appid = nil
//        }
//    }
//}
//
//struct AppsId: Codable {
//    var success: Bool
//    var data: [Details]
//}
//
//struct Details: Codable {
//    var type: String
//    var name: String
//    var appId: Int
//    var age: Int
//    var description: String
//    var image: String
//    var platforms: [Platforms]
//    var genres: [Genres]
//    var screenshots: [Screens]?
//    var priceItem: PriceItem?
//    var releaseDate: ReleaseDate
//
//    enum CodingKeys: String, CodingKey {
//        case type
//        case name
//        case appId = "steam_appid"
//        case age = "required_age"
//        case description = "short_description"
//        case image = "header_image"
//        case platforms
//        case genres
//        case screenshots
//        case priceItem = "price_overview"
//        case releaseDate = "release_date"
//    }
//}
//
//struct Platforms: Codable {
//    var windows: Bool
//    var mac: Bool
//    var linux: Bool
//}
//
//struct Genres: Codable {
//    let id: Int
//    let description: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case description
//    }
//}
//
//struct Screens: Codable {
//    let id: Int
//    let path: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case path = "path_full"
//    }
//}
//
//struct PriceItem: Codable {
//    let discountPercent: Int
//    let priceTitle: String
//    let price: Int
//
//    enum CodingKeys: String, CodingKey {
//        case discountPercent = "discount_percent"
//        case priceTitle = "final_formatted"
//        case price = "final"
//    }
//}
//
//struct ReleaseDate: Codable {
//    let isComingSoon: Bool
//    let date: String
//
//    enum CodingKeys: String, CodingKey {
//        case isComingSoon = "coming_soon"
//        case date
//    }
//}

// MARK: - Welcome
struct GameDetails: Codable {
    let appId: DetailResponse?
    
    enum CodingKeys: String, CodingKey {
        case appId
    }
}

// MARK: - The1599830
struct DetailResponse: Codable {
    let success: Bool?
    let data: Details?
}

// MARK: - DataClass
struct Details: Codable {
    let type, name: String?
    let steamAppid, requiredAge: Int?
    let isFree: Bool?
    let controllerSupport, detailedDescription, aboutTheGame, shortDescription: String?
    let supportedLanguages: String?
    let headerImage: String?
    let website: String?
   // let pcRequirements: PCRequirements?
    let legalNotice: String?
    let developers, publishers: [String]?
    let platforms: Platforms?
   // let categories: [Category]?
    let genres: [Genre]?
    let screenshots: [Screenshot]?
    //let releaseDate: ReleaseDate?
   // let supportInfo: SupportInfo?
    let background: String?
    
    enum CodingKeys: String, CodingKey {
        case type, name
        case steamAppid = "steam_appid"
        case requiredAge = "required_age"
        case isFree = "is_free"
        case controllerSupport = "controller_support"
        case detailedDescription = "detailed_description"
        case aboutTheGame = "about_the_game"
        case shortDescription = "short_description"
        case supportedLanguages = "supported_languages"
        case headerImage = "header_image"
        case website
        //case pcRequirements = "pc_requirements"
        case legalNotice = "legal_notice"
        case developers, publishers
        case platforms, genres, screenshots //, categories
       // case releaseDate = "release_date"
       // case supportInfo = "support_info"
        case background
    }
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let categoryDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoryDescription = "description"
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id, genreDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case genreDescription = "description"
    }
}


// MARK: - PCRequirements
struct PCRequirements: Codable {
    let minimum, recommended: String?
}

// MARK: - Platforms
struct Platforms: Codable {
    let windows, mac, linux: Bool?
}

// MARK: - ReleaseDate
struct ReleaseDate: Codable {
    let comingSoon: Bool?
    let date: String?
    
    enum CodingKeys: String, CodingKey {
        case comingSoon = "coming_soon"
        case date
    }
}

// MARK: - Screenshot
struct Screenshot: Codable {
    let id: Int?
    let pathThumbnail, pathFull: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case pathThumbnail = "path_thumbnail"
        case pathFull = "path_full"
    }
}

// MARK: - SupportInfo
struct SupportInfo: Codable {
    let url: String?
    let email: String?
}

