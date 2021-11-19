//
//  GamesManagerProtocol.swift
//  SteamList
//
//  Created by Adam Bokun on 18.11.21.
//

import Foundation


protocol GamesManagerProtocol {
    func getGames(completion: @escaping (Result<[Games],Error>) -> Void)
}
