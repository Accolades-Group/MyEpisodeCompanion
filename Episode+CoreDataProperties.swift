//
//  Episode+CoreDataProperties.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 4/4/22.
//
//

import Foundation
import CoreData


extension Episode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Episode> {
        return NSFetchRequest<Episode>(entityName: "Episode")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var howDidIFeel: String?
    @NSManaged public var howDidIReact: String?
    @NSManaged public var whatTriggeredMe: String?
    @NSManaged public var physicalChanges: String?
    @NSManaged public var whatDidItFeelLike: String?
    @NSManaged public var whatDidThatRemindMeOf: String?
    @NSManaged public var howDidICopeAfterComeDown: String?

}

extension Episode : Identifiable {

    
    //TODO: Clean this up
    func getCore() -> CoreEmotion{
        return EmotionConstants.Cores.getCoreByNameStr(howDidIFeel ?? "")
    }
}
