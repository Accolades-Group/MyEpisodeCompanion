//
//  Checkin.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/29/22.
//

import Foundation
import CoreData

@objc(Checkin)
public class Checkin: NSManagedObject {

}


extension Checkin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Checkin> {
        return NSFetchRequest<Checkin>(entityName: "Checkin")
    }

    @NSManaged public var date: Date
    @NSManaged public var emotionResponse: String
    @NSManaged public var copingMethods: [String]?
    @NSManaged public var id: UUID
    @NSManaged public var sleepQuality: NSNumber
    @NSManaged public var sleepQuantity: NSNumber
    @NSManaged public var stressLevel: NSNumber
    @NSManaged public var needQuestion: String
    @NSManaged public var headspaceQuestion: String
    @NSManaged public var emotionState: String
//    @NSManaged public var howDoIFeelAboutMyself: String?
//    @NSManaged public var thoughtsPositivity: NSNumber?

}
//Unwrapping an existing checkin
extension Checkin : Identifiable {
    
    func getState() -> EmotionStates{
        return EmotionStates.allCases.first(where: {$0.rawValue == emotionState}) ?? .peace
    }
    
    func setState(_ state : EmotionStates){
        emotionState = state.rawValue
    }
    
    //Returns true if the user coped with something for this checkin, or false if didn't
    func didCope() -> Bool {
        return copingMethods != nil
    }
    
    func setCopingMethods(_ methods: [CopingMethods]){
        
        var copeArray : [String] = []
        methods.forEach{method in
            let copeString = method.rawValue
            copeArray.append(copeString)
        }
        copingMethods = copeArray
    }
    
    /*
     var copeStr : String = ""

     methods.forEach{method in
         copeStr += method.rawValue
         copeStr += CUSTOM_DELIMINATOR
     }
     
     copingMethods = String(copeStr.dropLast(CUSTOM_DELIMINATOR.count))
     */
    
    func getCopingMethods() -> [CopingMethods]{
        var copeArray : [CopingMethods] = []
        if let copeStr = copingMethods{
        copeStr.forEach{str in
            if let method = CopingMethods.allCases.first(where: {$0.rawValue == str as String}){
                copeArray.append(method)
            }
        }
        }
        return copeArray
    }
    
/*
    func unwrapCheckin() -> UnwrappedCheckin? {
        print("Unwrapping checkin")
        guard let unwrappedDate = date else {
            print("Failed to unwrap date")
            print("\(date?.description ?? "Nil Response")")
            return nil
        }
        guard let unwrappedID = id else {
            print("Failed to unwrap ID")
            print("\(id?.uuidString ?? "Nil Response")")
            return nil
        }
        guard let unwrappedSleepQuantity = sleepQuantity else {
            print("Failed to unwrap sleep qty")
            print("\(sleepQuantity?.stringValue ?? "Nil response")")
            return nil}
        guard let unwrappedSleepQuality = sleepQuality else {
            print("Failed to unwrap sleep quality")
            print("\(sleepQuality?.stringValue ?? "Nil response")")
            return nil}
        guard let unwrappedFeelings = unwrapFeelings(feelings: emotionResponse) else{
            print("Failed to unwrap feelings")
            print("\(emotionResponse ?? "Nil Response")")
            return nil}
        guard let unwrappedHeadspace = whereIsMyHeadSpace else {
            print("Failed to unwrap headspace")
            print("\(whereIsMyHeadSpace ?? "Nil Response")")
            return nil}
        guard let unwrappedNeeds = whatDoIFeelINeed else {
            print("\(whatDoIFeelINeed ?? "Nil Response")")
            return nil}
        guard let unwrappedStressLevel = stressLevel else {
            print("\(stressLevel?.stringValue ?? "Nil Response")")
            return nil}
        guard let unwrappedCopingMethods = unwrapCopingMethods() else {
            print("\(howHaveICoped ?? "Nil Response")")
            return nil}
        
        
        
/*
        
        if secondaryEmotionRespose != nil, let unwrappedSecondary = unwrapFeelings(feelings: secondaryEmotionRespose){
            
            
            
            
            return UnwrappedCheckin(
                date: unwrappedDate,
                id: unwrappedID,
                sleepQuantity: Float(truncating: unwrappedSleepQuantity),
                sleepQuality: Int16(truncating: unwrappedSleepQuality),
                core: unwrappedFeelings.core,
                state: unwrappedFeelings.state,
                stateResponse: unwrappedFeelings.response,
                headspaceResponse: unwrappedHeadspace,
                needs: unwrappedNeeds,
                stressLevel: Int16(truncating: unwrappedStressLevel),
                copingMethods: unwrappedCopingMethods,
                hasSecondary: true,
                secondaryCore: unwrappedSecondary.core,
                secondaryState: unwrappedSecondary.state,
                secondaryResponse: unwrappedSecondary.response
            )
        }
  */
        return UnwrappedCheckin(
            date: unwrappedDate,
            id: unwrappedID,
            sleepQuantity: Float(truncating: unwrappedSleepQuantity),
            sleepQuality: Int16(truncating: unwrappedSleepQuality),
            core: unwrappedFeelings.core,
            state: unwrappedFeelings.state,
            stateResponse: unwrappedFeelings.response,
            headspaceResponse: unwrappedHeadspace,
            needs: unwrappedNeeds,
            stressLevel: Int16(truncating: unwrappedStressLevel),
            copingMethods: unwrappedCopingMethods//,
        /*
            hasSecondary: false,
            secondaryCore: nil,
            secondaryState: nil,
            secondaryResponse: nil
         */
        )

        
    }
    
    func unwrapFeelings(feelings : String?) ->(core : CoreEmotion, state: EmotionState, response: String)?{
        
        guard let unwrappedComponents = feelings?.components(separatedBy: CUSTOM_DELIMINATOR) else {return nil}
        if unwrappedComponents.count != 3 {return nil}
        
        guard let core = EmotionConstants.Cores.getAll().first(where: {$0.name == unwrappedComponents[0]}) else {return nil}
        
        guard let state = EmotionConstants.getStatesByCore(core).first(where: {$0.name == unwrappedComponents[1]}) else {return nil}
        
        return (core, state, unwrappedComponents[2])
        
    }
    
    func unwrapCopingMethods() -> [CopingMethod]?{
        guard let unwrappedcopestring = howHaveICoped else {return nil}

        var copingArr : [CopingMethod] = []
        
        //for "," versions...oops?
        let components = unwrappedcopestring.components(separatedBy: CUSTOM_DELIMINATOR)
        
        components.forEach{ name in
            if let unwrappedCopingMethod = EmotionConstants.CopingMethods.getAllMethods().first(where: {$0.name == name}){
                copingArr.append(unwrappedCopingMethod)
            }
        }
        return copingArr
    }
    */
}
//Validating and building a new checkin
extension Checkin {
    /*
    func buildFeelings(core : CoreEmotion, state : EmotionState, response : String){
        //TODO: validate?
        let str = core.name + CUSTOM_DELIMINATOR + state.name + CUSTOM_DELIMINATOR + response
        emotionResponse = str
    }
    
    func buildCopingString(copingMethods : [CopingMethod]){
        var str : NSString = ""
        copingMethods.forEach{method in
            str += method.name
            str += CUSTOM_DELIMINATOR
        }
        str = String(str.dropLast(3))
        howHaveICoped = str
    }
    
    func buildVals(date theDate : Date? = Date.now, uuid theUUID : UUID? = UUID(), sleepQty : Float, sleepQual : Int, headspace : String, needQuestion : String, stresslvl : Int){
        date = theDate// ?? Date.now
        id = theUUID// ?? UUID()
        sleepQuantity = NSNumber(value: sleepQty)
        sleepQuality = NSNumber(value: sleepQual)
        whereIsMyHeadSpace = headspace
        whatDoIFeelINeed = needQuestion
        stressLevel = NSNumber(value: stresslvl)
    }
    */
    
}

fileprivate var CUSTOM_DELIMINATOR : String = "@@@"

struct UnwrappedCheckin : Identifiable {
    let date : Date
    let id : UUID //Do I need?
    let sleepQuantity : Float
    let sleepQuality : Int16
    let core : CoreEmotion //TODO: Delete
    let state : EmotionState //TODO: Delete
    let stateResponse : String
    let headspaceResponse : String
    let needs : String //TODO: Make this a list thing maybe?
    let stressLevel : Int16
    let copingMethods : [CopingMethod]
   /*
    let hasSecondary: Bool
    let secondaryCore : CoreEmotion?
    let secondaryState: EmotionState?
    let secondaryResponse : String?
    */
    
}

class AttributedStringToDataTransformer: ValueTransformer {
    
    override func transformedValue(_ value: Any?) -> Any? {
        let boxedData = try! NSKeyedArchiver.archivedData(withRootObject: value!, requiringSecureCoding: true)
        return boxedData
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        let typedBlob = value as! Data
        let data = try! NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSString.self], from: typedBlob)
        return (data as! String)
    }
    
}
