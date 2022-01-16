//
//  Screens+CoreDataProperties.swift
//  SteamList
//
//  Created by Adam Bokun on 5.01.22.
//
//

import Foundation
import CoreData


extension Screens {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Screens> {
        return NSFetchRequest<Screens>(entityName: "Screens")
    }

    @NSManaged public var appid: Int64
    @NSManaged public var pathFull: String?
    @NSManaged public var screenid: Int64

}

extension Screens : Identifiable {

}
