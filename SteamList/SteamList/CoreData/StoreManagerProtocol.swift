//
//  StoreManagerProtocol.swift
//  SteamList
//
//  Created by Adam Bokun on 7.12.21.
//

import Foundation

protocol StoreManagerProtocol {
    static func shared() -> CoreDataManager
    func applicationLibraryDirectory()
    func prepare(dataForSaving: [Games])
    func createEntityFrom(games: Games) -> GameItems?
    func saveData()
    func fetchAllData() -> [Games]
    func fetchGameDetail(id: Int) -> Details?
    func fetchFavoritesGames() -> [Int]
    func fetchFavoritesGamesToModel() -> [FavoriteGames]
    func storeDataAsync(data: [Games])
}
