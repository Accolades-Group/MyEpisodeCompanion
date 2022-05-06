//
//  TrackedEpisode+CoreDataProperties.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 4/20/22.
//
//

import Foundation
import CoreData


extension TrackedEpisode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackedEpisode> {
        return NSFetchRequest<TrackedEpisode>(entityName: "TrackedEpisode")
    }

    @NSManaged public var date: Date?
    @NSManaged public var duration: Int16
    @NSManaged public var avgHeartRate: Int16
    @NSManaged public var peakHeartRate: Int16
    @NSManaged public var peakDb: Int16
    @NSManaged public var avgDb: Int16

}

extension TrackedEpisode : Identifiable {

}
