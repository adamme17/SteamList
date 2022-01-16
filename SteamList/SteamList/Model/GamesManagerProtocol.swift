//
//  GamesManagerProtocol.swift
//  SteamList
//
//  Created by Adam Bokun on 18.11.21.
//

import Foundation

protocol GamesManagerProtocol {
    func getGames(endPoint: SteamEndPoints, completion: @escaping (Result<GamesList, Error>) -> Void)
    func getGameDetails(endPoint: SteamEndPoints, completion: @escaping (Result<[String: DetailResponse], Error>) -> Void)
    func getGameNews(endPoint: SteamEndPoints, completion: @escaping (Result<[String: Appnews], Error>) -> Void)
}
