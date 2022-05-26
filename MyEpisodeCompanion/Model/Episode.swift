////
////  EpisodeModel.swift
////  MyEpisodeCompanion
////
////  Created by Tanner Brown on 3/29/22.
////
//
//import Foundation
//
//
//struct Episode : Identifiable {
//    
//    // the ID for identification
//    let id = UUID()
//    
//    // The date the episode took place
//    let date : Date
//    
//    //the emotion felt
//    let coreEmotion : CoreEmotion
//    
//    //the state of the core emotion
//    let stateEmotion : EmotionState
//    
//    //the response to the emotion
//    let emotionResponses : [EmotionResponseAction : String]
//
//    
//    //the changes felt during the episoe
//    let physicalChanges : [PhysicalChange]
//    let psychologicalChange : [PsychologicalChange]
//    
//    //triggers
//    let trigger : Trigger
//    
//    //coping mechanisms
//    let copingMethod : CopingMethod
//    
//    //Precondition?
//    //let precondition : Checkin?
//    
//    //TODO: Past events? As Episodes?
//    
//    //from watch if it exists
//    let duration : Double?
//    let heartRate : Double?
//    let avgSoundDB : Double?
//    
//}

//
//func recordEp() {
//    let precondition : Int = 3014 //ID of most recent checkin
//    //let precondition : Checkin = getCheckinInToday() not stored. Retrived through fetch request. Array of checksin from time since last sleep. (Or store UUIDs of checksin)
//    let HowDidIFeel : String = "Anger+Fury" //(Core+State)
//    let PhysicalChanges : String = "Shaking,HeartRacing,Sweating" //Physical Changes (needed?)
//    let HowDidIReact : String = "ScreamYell,Undermine,Insult,WalkAway" //(Response Actions)
//    let WhatTriggeredMe : String = "Rejected.Insulted" //(TriggerEvent -> Category.Specific)
//    let WhatDidItFeelLike : String = "Rejection" //(Perception A)
//    let WhatDidThatRemindMeOf : String = "Getting Fired Event" //(Perception B)
//    let HowDidICopeAfterComedown : String = "Drugs.Tobacco" //(Post Condition)
//    
//}
//
//func recordCheck() {
//    //Day -> Loads from most recent checkin since sleeping
//    //Moment -> At time of checkin
//    //Since -> Since last checkin or sleep (combine with previous checks)
//    //Have you slept since last checkin?
//    let sleepQuantity : Float = 6.1 //(Day)
//    let sleepQuality : Int = 4 // 1-10(Day)
//    let HowAmIFeeling : String = "Fear+Anxiety" //(Core+State) (Moment) + Check @ core change?
//    let WhereIsMyHeadspace : String = "Breaking Up With GF" //(Since)
//    let WhatDoIFeelINeed : String = "Space and time to myself" //(Moment)
//    let WhatIsMyStressLevelAt : Int = 72 //Low 1-100 High(Since) + Check @ +/- 10
//    let WhatHaveIDoneToCopeWithStress : String = "Smoke" //(Since)
//    let HowDoIFeelAboutMyself : String = "Guilty,Failure" //(Moment) * Check @ Any
//    let AreMyThoughtsPositiveOrNegative : Int = 3 //Bad 1-10 Good (Moment) * Check @ Any
//    
//    
//}

import Foundation
import CoreData

@objc(Episode)
public class Episode: NSManagedObject {

}


extension Episode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Episode> {
        return NSFetchRequest<Episode>(entityName: "Episode")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var emotionState: String?
    @NSManaged private var emotionResponses: [String]? //private to require access through getter/setters
    @NSManaged private var copingMethods: [String]? //private to require access through getter/setters
    @NSManaged public var sleepQty: Float
    @NSManaged public var sleepQuality: Int16
    @NSManaged public var stressLevel: Int16
    @NSManaged public var trigger: TriggerEvent?
    @NSManaged public var trauma: TraumaEvent?

}

extension Episode : Identifiable {

    func getCore() -> CoreEmotions {
        return getState()?.core ?? .Joy
    }
    
    func setResponses(_ responses : [EmotionResponses]){
        var responseArray : [String] = []
        responses.forEach{response in
            responseArray.append(response.rawValue)
        }
        emotionResponses = responseArray
    }
    
    func getResponses() -> [EmotionResponses]{
        var responseArray : [EmotionResponses] = []
        if let unwrappedResponses = emotionResponses {
            unwrappedResponses.forEach{resp in
                if let response = EmotionResponses.allCases.first(where: {$0.rawValue == resp}){
                    responseArray.append(response)
                }
            }
        }
        return responseArray
    }
    
    func setCopingMethods(_ methods: [CopingMethods]){
        
        var copeArray : [String] = []
        methods.forEach{method in
            let copeString = method.rawValue
            copeArray.append(copeString)
        }
        copingMethods = copeArray
    }
    
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
    
    func setState(_ state : EmotionStates){
        emotionState = state.rawValue
    }
    
    func getState() -> EmotionStates?{
        return EmotionStates.allCases.first(where: {$0.rawValue == emotionState})
    }
}


