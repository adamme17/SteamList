//
//  Network Manager.swift
//  SteamList
//
//  Created by Adam Bokun on 18.11.21.
//

import Foundation

extension NetworkManager {
    enum ErrorHandler: Error {
        case invalidURL
    }
}

public class NetworkManager {

    typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()
    var task: URLSessionTask?
    
    func request (completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            guard let request = try buildRequest()
            else {
                completion(nil, nil, ErrorHandler.invalidURL)
                return
            }
            
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
            
        } catch {
            completion(nil, nil, error)
        }
        task?.resume()
    }
    
    public func cancel (){
        task?.cancel()
    }
    
    private func buildRequest() throws -> URLRequest? {
        
        guard let requestUrl = URL(string: "https://api.steampowered.com/ISteamApps/GetAppList/v2/?")
        else { return nil }
        
        var request = URLRequest(url: requestUrl,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 30.0)
        
        request.httpMethod = "GET"
        return request
    }
}
