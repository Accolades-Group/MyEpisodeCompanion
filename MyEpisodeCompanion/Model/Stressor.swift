//
//  Stressor.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 5/24/22.
//
import Foundation
import CoreData

@objc(Stressor)
public class Stressor: NSManagedObject {

}

extension Stressor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stressor> {
        return NSFetchRequest<Stressor>(entityName: "Stressor")
    }

    @NSManaged public var addDate: Date
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var removeDate: Date?
    @NSManaged public var stressDescription: String
    @NSManaged public var weight: Int16

}

extension Stressor : Identifiable {

    var isRemoved: Bool {
        return removeDate != nil
    }
    
}
