//
//  Checkin+CoreDataProperties.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 4/4/22.
//
//

import Foundation
import CoreData


extension Checkin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Checkin> {
        return NSFetchRequest<Checkin>(entityName: "Checkin")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var sleepQuantity: NSNumber?
    @NSManaged public var sleepQuality: NSNumber?
    @NSManaged public var howAmIFeeling: String?
    @NSManaged public var whereIsMyHeadSpace: String?
    @NSManaged public var whatDoIFeelINeed: String?
    @NSManaged public var stressLevel: NSNumber?
//    @NSManaged public var howDoIFeelAboutMyself: String?
//    @NSManaged public var thoughtsPositivity: NSNumber?
    @NSManaged public var howHaveICoped: String?

}

extension Checkin : Identifiable {
    

    func unwrapCheckin() -> UnwrappedCheckin? {
        
        guard let unwrappedDate = date else {return nil}
        guard let unwrappedID = id else {return nil}
        guard let unwrappedSleepQuantity = sleepQuantity else {return nil}
        guard let unwrappedSleepQuality = sleepQuality else {return nil}
        guard let unwrappedFeelings = unwrapFeelings() else{return nil}
        guard let unwrappedHeadspace = whereIsMyHeadSpace else {return nil}
        guard let unwrappedNeeds = whatDoIFeelINeed else {return nil}
        guard let unwrappedStressLevel = stressLevel else {return nil}
        guard let unwrappedCopingMethods = unwrapCopingMethods() else {return nil}
        
        
        
        
        return UnwrappedCheckin(date: unwrappedDate, id: unwrappedID, sleepQuantity: Float(truncating: unwrappedSleepQuantity), sleepQuality: Int16(truncating: unwrappedSleepQuality), core: unwrappedFeelings.core, state: unwrappedFeelings.state, stateResponse: unwrappedFeelings.response, headspaceResponse: unwrappedHeadspace, needs: unwrappedNeeds, stressLevel: Int16(truncating: unwrappedStressLevel), copingMethods: unwrappedCopingMethods)
    }
    
    func unwrapFeelings() ->(core : CoreEmotion, state: EmotionState, response: String)?{
        
        guard let unwrappedComponents = howAmIFeeling?.components(separatedBy: "+") else {return nil}
        
        if unwrappedComponents.count != 3 {return nil}
        
        guard let core = EmotionConstants.Cores.getAll().first(where: {$0.name == unwrappedComponents[0]}) else {return nil}
        
        guard let state = EmotionConstants.Cores.getStatesByCore(core).first(where: {$0.name == unwrappedComponents[1]}) else {return nil}
                
        return(core, state, unwrappedComponents[2])
    }
    
    func unwrapCopingMethods() -> [CopingMethod]?{
        guard let unwrappedcopestring = howHaveICoped else {return nil}

        var copingArr : [CopingMethod] = []
        
        //for "," versions...oops?
        let components = unwrappedcopestring.components(separatedBy: unwrappedcopestring.contains(",") ? "," : "+")
        components.forEach{ name in
            if let unwrappedCopingMethod = EmotionConstants.CopingMethods.getAllMethods().first(where: {$0.name == name}){
                copingArr.append(unwrappedCopingMethod)
            }
        }
        return copingArr
    }
}

struct UnwrappedCheckin : Identifiable {
    let date : Date
    let id : UUID //Do I need?
    let sleepQuantity : Float
    let sleepQuality : Int16
    let core : CoreEmotion
    let state : EmotionState
    let stateResponse : String
    let headspaceResponse : String
    let needs : String //TODO: Make this a list thing maybe?
    let stressLevel : Int16
    let copingMethods : [CopingMethod]
}
