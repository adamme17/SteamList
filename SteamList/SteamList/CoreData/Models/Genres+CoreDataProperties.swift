//
//  Genres+CoreDataProperties.swift
//  SteamList
//
//  Created by Adam Bokun on 5.01.22.
//
//

import Foundation
import CoreData


extension Genres {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Genres> {
        return NSFetchRequest<Genres>(entityName: "Genres")
    }

    @NSManaged public var appid: Int64
    @NSManaged public var genreid: Int64
    @NSManaged public var genreDescription: String?

}

extension Genres : Identifiable {

}
