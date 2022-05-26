//
//  Trauma.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/29/22.
//

/**
 A traumatic event that has taken place in a person's past.
 */
//@objc(Trauma)
//public class Trauma: NSManagedObject {
//
//}

//public class Trauma2  {
//
//    public var id : UUID
//    /** The age the individual was (approx) at time of trauma */
//    public var age : Int
//    /** The name associated with the given trauma */
//    public var name : String
//    /** The description of the trauma */
//    public var description : String
//    /** Where the trauma took place */
//    public var location : String
//    /** Individuals associated with the trauma */
//    public var involvedIndividuals : String
//    /** The type of trauma exprienced */
//    public var traumaType : TraumaType
//
//}
//
//enum TraumaType : String, CaseIterable {
//    case witnessDeath, experienceInjury, witnessInjury, threatToLife, riskOfInjury, panic, /* disassociation? */ absenceOfControl, prolongedExposure,  /* safeByChance: -> survivor's guilt? */ awarnessOfLoss
//}

import Foundation
import CoreData

@objc(TraumaEvent)
public class TraumaEvent: NSManagedObject {

}

extension TraumaEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TraumaEvent> {
        return NSFetchRequest<TraumaEvent>(entityName: "TraumaEvent")
    }
    /** Unique ID for the trauma  */
    @NSManaged public var id: UUID?
    /** The age the individual was (approx) at time of trauma */
    @NSManaged public var age: Int16
    /** The name associated with the given trauma */
    @NSManaged public var name: String
    /** The description of the trauma */
    @NSManaged public var eventDescription: String?
    /** The type of trauma */
    @NSManaged public var type: String
    /** A list of the threats associated with this trauma */
    @NSManaged public var threats: [NSString]?
    /** A list of the victims associated with this trauma */
    @NSManaged public var victims: [NSString]?
    
    @NSManaged public var relationship: NSSet?
    

}

// MARK: Generated accessors for relationship
extension TraumaEvent {

    @objc(addTriggerObject:)
    @NSManaged public func addToTrigger(_ value: TriggerEvent)

    @objc(removeTriggerObject:)
    @NSManaged public func removeFromTrigger(_ value: TriggerEvent)

    @objc(addTrigger:)
    @NSManaged public func addToTrigger(_ values: NSSet)

    @objc(removeTrigger:)
    @NSManaged public func removeFromTrigger(_ values: NSSet)

}

extension TraumaEvent : Identifiable {

    var traumaType : TraumaType {
        return TraumaType.allCases.first(where: {$0.rawValue == type}) ?? .other
    }
    
}

//https://www.nctsn.org/what-is-child-trauma/trauma-types
enum TraumaType : String, CaseIterable {
    case bullying, communityViolence, complexTrauma, disasters, earlyChildhoodTrauma, intimatePartnerViolence, medicalTrauma, physicalAbuse, refugeeTrauma, sexualAbuse, terrorismAndViolence, traumaticGreif, other
    
    //sexTrafficking <- rare enough to include in sexual Abuse?
    
    var name: String{
        switch self{
        case .communityViolence: return "Community Violence"
        case .complexTrauma: return "Complex Trauma"
        case .earlyChildhoodTrauma: return "Early Childhood Trauma"
        case .intimatePartnerViolence: return "Intimate Partner Violence"
        case .medicalTrauma: return "Medical Trauma"
        case .physicalAbuse: return "Physical Abuse"
        case .refugeeTrauma: return "Refugee Trauma"
        case .sexualAbuse: return "Sexual Abuse"
        case .terrorismAndViolence: return "Terrorism And Violence"
        case .traumaticGreif: return "Traumatic Grief"
     //   case .sexTrafficking: return "S"
        //default: return self.rawValue.capitalized
        case .bullying:
            return "Bullying"
        case .disasters:
            return "Disasters"
            
        case .other:
            return "Other Trauma"
        }
    }
    
    var description: String{
        switch self{
        case .bullying: return "Bullying is a deliberate and unsolicited action that occurs with the intent of inflicting social, emotional, physical, and/or psychological harm to someone who often is perceived as being less powerful."
            
        case .communityViolence: return "Community violence is exposure to intentional acts of interpersonal violence committed in public areas by individuals who are not intimately related to the victim."
            
        case .complexTrauma: return "Complex trauma describes both children’s exposure to multiple traumatic events—often of an invasive, interpersonal nature—and the wide-ranging, long-term effects of this exposure."
            
        case .disasters: return "Natural disasters include hurricanes, earthquakes, tornadoes, wildfires, tsunamis, and floods, as well as extreme weather events such as blizzards, droughts, extreme heat, and wind storms."
            
        case .earlyChildhoodTrauma: return "Early childhood trauma generally refers to the traumatic experiences that occur to children aged 0-6."
            
        case .intimatePartnerViolence: return "Intimate Partner Violence (IPV), also referred to as domestic violence, occurs when an individual purposely causes harm or threatens the risk of harm to any past or current partner or spouse."
            
        case .medicalTrauma: return "Pediatric medical traumatic stress refers to a set of psychological and physiological responses of children and their families to single or multiple medical events."
            
        case .physicalAbuse: return "Physical abuse occurs when a parent or caregiver commits an act that results in physical injury to a child or adolescent."
            
        case .refugeeTrauma: return "Many refugees, especially children, have experienced trauma related to war or persecution that may affect their mental and physical health long after the events have occurred."
            
        case .sexualAbuse: return "Child sexual abuse is any interaction between a child and an adult (or another child) in which the child is used for the sexual stimulation of the perpetrator or an observer."
            
        case .terrorismAndViolence: return "Families and children may be profoundly affected by mass violence, acts of terrorism, or community trauma in the form of shootings, bombings, or other types of attacks."
            
        case .traumaticGreif: return "While many children adjust well after a death, other children have ongoing difficulties that interfere with everyday life and make it difficult to recall positive memories of their loved ones."
            
        case .other: return "Other trauma type"
        }
    }
}
