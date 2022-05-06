//
//  Stressor+CoreDataProperties.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 4/21/22.
//
//

import Foundation
import CoreData


extension Stressor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stressor> {
        return NSFetchRequest<Stressor>(entityName: "Stressor")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var weight: Int16
    @NSManaged public var name: String?
    @NSManaged public var stressDescription: String?
    @NSManaged public var addDate: Date?

}

extension Stressor : Identifiable {

}
