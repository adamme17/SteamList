//
//  DetailGameModel.swift
//  SteamList
//
//  Created by Adam Bokun on 7.12.21.
//

import Foundation
import UIKit


struct GameDetailsModel: Codable {
    let appId: [String: DetailResponse]?
}

struct DetailResponse: Codable {
    let success: Bool?
    let data: Details?
}

// MARK: - DataClass
struct Details: Codable {
    let type, name: String?
    var steamAppid, requiredAge: Int?
    let isFree: Bool?
    let controllerSupport, detailedDescription, aboutTheGame, shortDescript: String?
    let supportedLanguages: String?
    let headerImage: String?
    let website: String?
    let legalNotice: String?
    let developers, publishers: [String]?
    let priceOverview: Price?
    let platforms: Platforms?
    let categories: [Category]?
    let genres: [Genre]?
    let screenshots: [Screenshot]?
    let releaseDate: ReleaseDate?
    let background: String?
    
    enum CodingKeys: String, CodingKey {
        case type, name
        case steamAppid = "steam_appid"
        case requiredAge = "required_age"
        case isFree = "is_free"
        case controllerSupport = "controller_support"
        case detailedDescription = "detailed_description"
        case aboutTheGame = "about_the_game"
        case shortDescript = "short_description"
        case supportedLanguages = "supported_languages"
        case headerImage = "header_image"
        case website
        case legalNotice = "legal_notice"
        case developers, publishers
        case priceOverview = "price_overview"
        case platforms, genres, screenshots, categories
        case releaseDate = "release_date"
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

// MARK: - Price
struct Price: Codable {
    let currency: String
    let initial, priceOverviewFinal, discountPercent: Int
    let initialFormatted, finalFormatted: String
    
    enum CodingKeys: String, CodingKey {
        case currency, initial
        case priceOverviewFinal = "final"
        case discountPercent = "discount_percent"
        case initialFormatted = "initial_formatted"
        case finalFormatted = "final_formatted"
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

