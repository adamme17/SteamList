//
//  FavoriteGames+CoreDataProperties.swift
//  SteamList
//
//  Created by Adam Bokun on 5.01.22.
//
//

import Foundation
import CoreData


extension FavoriteGames {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteGames> {
        return NSFetchRequest<FavoriteGames>(entityName: "FavoriteGames")
    }

    @NSManaged public var id: Int64
    @NSManaged public var isFree: Bool
    @NSManaged public var finalFormatted: String?
    @NSManaged public var discountPercent: Int64
    @NSManaged public var name: String?

}

extension FavoriteGames : Identifiable {

}
