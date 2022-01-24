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
    func prepare(dataForSaving: [Games]) -> Bool
    func prepareDetails(dataForSaving: [Details]) -> Bool
    func prepareFavorites(dataForSaving: [Details]) -> Bool
    func prepareFavorites(dataForSaving: [Games]) -> Bool
    func prepareGenres(dataForSaving: Details) -> Bool
    func prepareScreens(dataForSaving: Details) -> Bool
    func createEntityFrom(games: Games) -> GameItems?
    func saveData() -> Bool
    func fetchAllData() -> [Games]
    func fetchGameDetail(id: Int) -> Details?
    func fetchFavoritesGames() -> [Int]
    func fetchFavoritesGamesToModel() -> [FavoriteGames]
    func deleteItemFromFavorites(id: Int) -> Bool
    func storeDataAsync(data: [Games])
}
