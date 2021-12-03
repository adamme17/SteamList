//
//  DataSaver.swift
//  SteamList
//
//  Created by Adam Bokun on 2.12.21.
//

import Foundation

class DataSaver: Operation {
    
    let storageManager = CoreDataManager.shared()
    let data: [Games]
    
    init(gamesData: [Games]) {
        self.data = gamesData
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        storageManager.prepare(dataForSaving: data)
        
        if isCancelled {
            return
        }
    }
    
}
