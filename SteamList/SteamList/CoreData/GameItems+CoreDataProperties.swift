//
//  GameItems+CoreDataProperties.swift
//  SteamList
//
//  Created by Adam Bokun on 1.12.21.
//
//

import Foundation
import CoreData


extension GameItems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameItems> {
        return NSFetchRequest<GameItems>(entityName: "GameItems")
    }

    @NSManaged public var appid: Int
    @NSManaged public var name: String?
    @NSManaged public var isFavorite: Bool

}

extension GameItems : Identifiable {

}
