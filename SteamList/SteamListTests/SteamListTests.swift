//
//  SteamListTests.swift
//  SteamListTests
//
//  Created by Adam Bokun on 14.11.21.
//

import XCTest
@testable import SteamList

class SteamListTests: XCTestCase {
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

    func testGameListEndPointToCorrectRequest() throws {
        var request: URLRequest
        var expectedResult = URL(string: "https://api.steampowered.com/ISteamApps/GetAppList/v2/?")!
        
        request = try XCTUnwrap(networkManager.buildRequest(.getGamesList)!)
        
        XCTAssertEqual(expectedResult, request.url)
    }
    
    func testGameDetailsEndPointToCorrectRequest() throws {
        var request: URLRequest
        var expectedResult = URL(string: "https://store.steampowered.com/api/appdetails?appids=1599830")!
        
        request = try XCTUnwrap(networkManager.buildRequest(.getGameDetailsList(appId: 1599830))!)
        
        XCTAssertEqual(expectedResult, request.url)
    }
    
    func testNewsListEndPointToCorrectRequest() throws {
        var request: URLRequest
        var expectedResult = URL(string: "https://api.steampowered.com/ISteamNews/GetNewsForApp/v2/?appid=1213750&count=1")!
        
        request = try XCTUnwrap(networkManager.buildRequest(.getGameNews(appId: 1213750, number: 1))!)
        
        XCTAssertEqual(expectedResult, request.url)
    }
    
    func testFetchGameList() {
        var fetchResult: GamesList?
        gamesManager.getGames(endPoint: .getGamesList) { result in
            switch result {
            case .success(let model):
                fetchResult = model
                XCTAssertNotNil(fetchResult)
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func testFetchGameDetails() {
        gamesManager.getGameDetails(endPoint: .getGameDetailsList(appId: 1213750)) { result in
            switch result {
            case .success(let model):
                XCTAssert(!model.isEmpty)
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func testFetchNewsList() {
        gamesManager.getGameNews(endPoint: .getGameNews(appId: 1213750, number: 1)) { result in
            switch result {
            case .success(let model):
                XCTAssert(!model.isEmpty)
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func testGameListDecoding() throws {
        let jsonData = try Data(contentsOf: URL(string: "https://api.steampowered.com/ISteamApps/GetAppList/v2/?")!)
        XCTAssertNoThrow(try JSONDecoder().decode(GamesList.self, from: jsonData))
    }
    
    func testGameDetailsDecoding() throws {
        let jsonData = try Data(contentsOf: URL(string: "https://store.steampowered.com/api/appdetails?appids=1869020")!)
        XCTAssertNoThrow(try JSONDecoder().decode(Details.self, from: jsonData))
    }
}

