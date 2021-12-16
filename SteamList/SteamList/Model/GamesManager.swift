//
//  GamesManager.swift
//  SteamList
//
//  Created by Adam Bokun on 18.11.21.
//

import Foundation

private enum NetworkResponse: String, Error {
    case success
    case failed = "Error"
    case noData = "No data"
    case ubableToDecode = "Unable to decode"
}

final class GamesManager {
    let network: NetworkManagerProtocol
    
    init(network: NetworkManagerProtocol) {
        self.network = network
    }
}



extension GamesManager: GamesManagerProtocol {
    
    func makeRequest<T: Codable>(endPoint: SteamEndPoints, completion: @escaping (Result<T, Error>) -> Void) {
        network.request(endPoint: endPoint) { data, response, error in
            if error != nil {
                completion(.failure(NetworkResponse.failed))
            }
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                    case 200...299:
                        guard let responseData = data else {
                            completion(.failure(NetworkResponse.noData))
                            return
                        }
                        do {
                            let apiResponse = try JSONDecoder().decode(T.self, from: responseData)
                            print(response.description)
                            print(response.statusCode)
                            completion(.success(apiResponse))
                        } catch let error {
                            print(error.localizedDescription)
                            completion(.failure(NetworkResponse.ubableToDecode))
                        }

                    default:
                        print(response.description)
                        print(response.statusCode)
                        completion(.failure(NetworkResponse.failed))
                }
            }
        }
    }
    
    func getGameDetails(endPoint: SteamEndPoints, completion: @escaping (Result<GameDetails, Error>) -> Void) {
        makeRequest(endPoint: endPoint, completion: completion)
    }
    
    func getGames(endPoint: SteamEndPoints, completion: @escaping (Result<GamesList, Error>) -> Void) {
        makeRequest(endPoint: endPoint, completion: completion)
    }
}
