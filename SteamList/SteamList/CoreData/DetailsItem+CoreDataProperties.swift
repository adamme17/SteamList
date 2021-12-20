//
//  DetailsItem+CoreDataProperties.swift
//  SteamList
//
//  Created by Adam Bokun on 19.12.21.
//
//

import Foundation
import CoreData


extension DetailsItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DetailsItem> {
        return NSFetchRequest<DetailsItem>(entityName: "DetailsItem")
    }

    @NSManaged public var type: String?
    @NSManaged public var name: String?
    @NSManaged public var steamAppid: Int64
    @NSManaged public var isFree: Bool
    @NSManaged public var shortDescript: String?
    @NSManaged public var headerImage: String?
    @NSManaged public var discountPercent: Int64
    @NSManaged public var finalFormatted: String?
    @NSManaged public var windows: Bool
    @NSManaged public var mac: Bool
    @NSManaged public var linux: Bool
    @NSManaged public var comingSoon: Bool
    @NSManaged public var date: String?
    @NSManaged public var pathFull: String?
    @NSManaged public var genreDescription: String?

}

extension DetailsItem : Identifiable {

}
