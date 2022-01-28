//
//  StorageDataTests.swift
//  SteamListTests
//
//  Created by Adam Bokun on 24.01.22.
//

import XCTest
@testable import SteamList

class StorageDataTests: XCTestCase {
    
    var networkManager: NetworkManagerProtocol!
    var storageManager: StoreManagerProtocol!
    var gamesManager: GamesManagerProtocol!
    
    override func setUpWithError() throws {
        networkManager = NetworkManager()
        storageManager = CoreDataManager()
        gamesManager = GamesManager(network: networkManager)
    }
    
    override func tearDownWithError() throws {
        networkManager = nil
        storageManager = nil
        gamesManager = nil
    }
    
    func testStoreGames() throws {
        let game = Games(appId: 1346130, name: "Test Game")
        let storeResult = storageManager.prepare(dataForSaving: [game])
        XCTAssert(storeResult)
    }
    
    func testStoreAndDeleteFavorites() throws {
        let game = Games(appId: 1346130, name: "Test Game")
        let storeResult = storageManager.prepareFavorites(dataForSaving: [game])
        let deleteResult = storageManager.deleteItemFromFavorites(id: 1346130)
        XCTAssert(storeResult && deleteResult)
    }
    
    
    func testStoreDetails() throws {
        let game = Details(type: "game",
                           name: "TITS OKAY TITS FINE",
                           steamAppid: 1869020,
                           requiredAge: 0,
                           isFree: false,
                           controllerSupport: nil,
                           detailedDescription: nil,
                           aboutTheGame: nil,
                           shortDescript: nil,
                           supportedLanguages: nil,
                           headerImage: nil,
                           website: nil,
                           legalNotice: nil,
                           developers: nil,
                           publishers: nil,
                           priceOverview: nil,
                           platforms: nil,
                           categories: nil,
                           genres: nil,
                           screenshots: nil,
                           releaseDate: nil,
                           background: nil)
        let result = storageManager.prepareFavorites(dataForSaving: [game])
        XCTAssert(result)
    }
    
    func testFetchGameList() throws {
        let game = Games(appId: 1346130, name: "Test Game")
        let storeResult = storageManager.prepare(dataForSaving: [game])
        let fetchResult = storageManager.fetchAllData()
        XCTAssert(fetchResult.contains(where: { $0.appid == game.appid }))
    }
    
    func testFetchDetails() throws {
        let game = Details(type: "game",
                           name: "TITS OKAY TITS FINE",
                           steamAppid: 1869020,
                           requiredAge: 0,
                           isFree: false,
                           controllerSupport: nil,
                           detailedDescription: nil,
                           aboutTheGame: nil,
                           shortDescript: nil,
                           supportedLanguages: nil,
                           headerImage: nil,
                           website: nil,
                           legalNotice: nil,
                           developers: nil,
                           publishers: nil,
                           priceOverview: nil,
                           platforms: nil,
                           categories: nil,
                           genres: nil,
                           screenshots: nil,
                           releaseDate: nil,
                           background: nil)
        let storeResult = storageManager.prepareDetails(dataForSaving: [game])
        let fetchResult = storageManager.fetchGameDetail(id: 1869020)
        XCTAssertEqual(fetchResult?.steamAppid, game.steamAppid)
    }
    
    func testFetchFavoriteGames() throws {
        let game = Games(appId: 1346130, name: "Test Game")
        let storeResult = storageManager.prepareFavorites(dataForSaving: [game])
        let fetchResult = storageManager.fetchFavoritesGames()
        XCTAssert(fetchResult.contains(where: { $0 == game.appid }))
    }
    
    func testFetchFavoriteGamesInDetails() throws {
        let game = Details(type: "game",
                           name: "TITS OKAY TITS FINE",
                           steamAppid: 1869020,
                           requiredAge: 0,
                           isFree: false,
                           controllerSupport: nil,
                           detailedDescription: nil,
                           aboutTheGame: nil,
                           shortDescript: nil,
                           supportedLanguages: nil,
                           headerImage: nil,
                           website: nil,
                           legalNotice: nil,
                           developers: nil,
                           publishers: nil,
                           priceOverview: nil,
                           platforms: nil,
                           categories: nil,
                           genres: nil,
                           screenshots: nil,
                           releaseDate: nil,
                           background: nil)
        let storeResult = storageManager.prepareFavorites(dataForSaving: [game])
        let fetchResult = storageManager.fetchFavoritesGames()
        XCTAssert(fetchResult.contains(where: { $0 == game.steamAppid }))
    }
}
