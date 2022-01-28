//
//  NetworkManagerProtocol.swift
//  SteamList
//
//  Created by Adam Bokun on 24.11.21.
//

import Foundation

protocol NetworkManagerProtocol {
    typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void
    func request (endPoint: SteamEndPoints, completion: @escaping NetworkRouterCompletion)
    func cancel ()
    func buildRequest(_ endPoint: SteamEndPoints) throws -> URLRequest?
}
