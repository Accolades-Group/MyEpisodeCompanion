//
//  Trigger.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 5/24/22.
//

import Foundation
import CoreData

@objc(TriggerEvent)
public class TriggerEvent: NSManagedObject {

}

extension TriggerEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TriggerEvent> {
        return NSFetchRequest<TriggerEvent>(entityName: "TriggerEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var eventType: String?
    @NSManaged public var eventName: String?
    @NSManaged private var triggerType: String?
    @NSManaged public var eventDescription: String?
    @NSManaged public var episode: Episode?

}

extension TriggerEvent : Identifiable {
    //Sets the trigger type based on an associated raw value
    func setTriggerType(_ type : TriggerTypes){
        triggerType = type.rawValue
    }
    func getTriggerType() -> TriggerTypes?{
        return TriggerTypes.allCases.first(where: {$0.rawValue == triggerType})
    }
}

enum TriggerTypes : String, CaseIterable{
    
    case family, passiveAggression, yelling, likeAbuser, abuse, doctors, hospitals, illness, bloodGore, violence, crowds, suddenMovements, noises, lights, lies /* /being Tricked/ untrustworthiness */, inconsistency, lateness, discrimination, accusations, beingMisunderstood, invalidation /* /dismissal */, rejection, criticism, abandonment, loneliness, beingIgnored, cheating, unfairness, teasing, money, positivity, holidays, therapy, expressingNeeds, judgement, failure, pressure, responsibility, mistakes, thingsDontGoAsPlanned, testsGrades, possessiveness, crossedBoundary, manipulation, coercion, beingOverworked, beingOverwhelmed, religion, gaslighting, sexIntimacy, beingDependedOn, authority, enclosedSpaces
    
    var name: String {
        switch self{
        case .passiveAggression: return "Passive Aggression"
        case .likeAbuser: return "Like Abuser"
        case .bloodGore: return "Blood or Gore"
        case .suddenMovements: return "Sudden Movements"
        case .beingMisunderstood: return "Being Misunderstood"
        case .beingIgnored: return "Being Ignored"
        case .expressingNeeds: return "Expressing Needs"
        case .thingsDontGoAsPlanned: return "Things don't go as planned"
        case .testsGrades: return "Tests or Grades"
        case .crossedBoundary: return "Crossed Boundary"
        case .beingOverworked: return "Being Overworked"
        case .beingOverwhelmed: return "Being Overwhelmed"
        case .sexIntimacy: return "Sex or Intimacy"
        case .beingDependedOn: return "Being Depended On"
        case .enclosedSpaces: return "Enclosed Spaces"
            
        default: return self.rawValue.capitalized
        }
    }
    
    var description: String{
        return "TODO \(self.name) description!"
        /*
        switch self{
        
        case .family:
            <#code#>
        case .passiveAggression:
            <#code#>
        case .yelling:
            <#code#>
        case .likeAbuser:
            <#code#>
        case .abuse:
            <#code#>
        case .doctors:
            <#code#>
        case .hospitals:
            <#code#>
        case .illness:
            <#code#>
        case .bloodGore:
            <#code#>
        case .violence:
            <#code#>
        case .crowds:
            <#code#>
        case .suddenMovements:
            <#code#>
        case .noises:
            <#code#>
        case .lights:
            <#code#>
        case .lies:
            <#code#>
        case .inconsistency:
            <#code#>
        case .lateness:
            <#code#>
        case .discrimination:
            <#code#>
        case .accusations:
            <#code#>
        case .beingMisunderstood:
            <#code#>
        case .invalidation:
            <#code#>
        case .rejection:
            <#code#>
        case .criticism:
            <#code#>
        case .abandonment:
            <#code#>
        case .lonliness:
            <#code#>
        case .beingIgnored:
            <#code#>
        case .cheating:
            <#code#>
        case .unfairness:
            <#code#>
        case .teasing:
            <#code#>
        case .money:
            <#code#>
        case .positivity:
            <#code#>
        case .holidays:
            <#code#>
        case .therapy:
            <#code#>
        case .expressingNeeds:
            <#code#>
        case .judgement:
            <#code#>
        case .failure:
            <#code#>
        case .pressure:
            <#code#>
        case .responsibility:
            <#code#>
        case .mistakes:
            <#code#>
        case .thingsDontGoAsPlanned:
            <#code#>
        case .testsGrades:
            <#code#>
        case .possessiveness:
            <#code#>
        case .crossedBoundary:
            <#code#>
        case .manipulation:
            <#code#>
        case .coercion:
            <#code#>
        case .beingOverworkedOverwhelmed:
            <#code#>
        case .religion:
            <#code#>
        case .gaslighting:
            <#code#>
        case .sexIntimacy:
            <#code#>
        case .beingDependedOn:
            <#code#>
        case .authority:
            <#code#>
        case .enclosedSpaces:
            <#code#>
        }
        */
    }
    
    /** The default core fear this trigger tends to point to. This can be complicated and ultimately a trigger can lead to different fears depending on the underlying trauma */
    var coreFears: [CoreFears]{
        switch self{
            
            //TODO: Revisit this. Family related triggers are related to the fear projected upon by parents
        case .family:
            return CoreFears.allCases
        case .passiveAggression:
            return CoreFears.allCases
        case .yelling:
            return CoreFears.allCases
        case .likeAbuser:
            return CoreFears.allCases
        case .abuse:
            return CoreFears.allCases
            
            //Doctors tend to be an authority figure that can tell you what to do.
        case .doctors:
            return [.extinction, .mutilation, .autonomyLoss]
        case .hospitals:
            return [.extinction, .mutilation]
        case .illness:
            return [.extinction, .mutilation]
        case .bloodGore:
            return [.mutilation]
        case .violence:
            return [.mutilation]
            //TODO:
        case .crowds:
            return []
        case .suddenMovements:
            return [.extinction]
        case .noises:
            return [.extinction]
        case .lights:
            return [.extinction]
        case .lies:
            return []
        case .inconsistency:
            return []
        case .lateness:
            return [.separation]
        case .discrimination:
            return [.autonomyLoss, .separation]
        case .accusations:
            return [.separation]
        case .beingMisunderstood:
            return [.separation]
        case .invalidation:
            return [.separation]
        case .rejection:
            return [.separation]
        case .criticism:
            return [.separation]
        case .abandonment:
            return [.separation]
        case .loneliness:
            return [.separation]
        case .beingIgnored:
            return [.separation]
        case .cheating:
            return [.egoDeath]
        case .unfairness:
            return [.egoDeath]
        case .teasing:
            return [.egoDeath]
        case .money:
            return [.egoDeath]
        case .positivity:
            return [.egoDeath]
        case .holidays:
            return [.egoDeath]
        case .therapy:
            return [.egoDeath]
        case .expressingNeeds:
            return [.egoDeath]
        case .judgement:
            return [.egoDeath]
        case .failure:
            return [.egoDeath]
        case .pressure:
            return [.egoDeath]
        case .responsibility:
            return [.egoDeath]
        case .mistakes:
            return [.egoDeath]
        case .thingsDontGoAsPlanned:
            return [.egoDeath]
        case .testsGrades:
            return [.egoDeath]
        case .possessiveness:
            return [.autonomyLoss]
        case .crossedBoundary:
            return [.autonomyLoss]
        case .manipulation:
            return [.autonomyLoss]
        case .coercion:
            return [.autonomyLoss]
            
            //being overworked might mean you didn't work hard enough which is a failure
        case .beingOverworked:
            return [.autonomyLoss, .egoDeath]
        case .beingOverwhelmed:
            return [.autonomyLoss]
        case .religion:
            return [.extinction, .autonomyLoss, .egoDeath]
        case .gaslighting:
            return [.autonomyLoss]
        case .sexIntimacy:
            return [.autonomyLoss]
            // forced dependence loses autonomy, failing those who depend on you is failure
        case .beingDependedOn:
            return [.autonomyLoss, .egoDeath]
        case .authority:
            return [.extinction, .mutilation, .autonomyLoss]
        case .enclosedSpaces:
            return [.autonomyLoss]
        }
    }
}
