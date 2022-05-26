//
//  EpisodeReportViewModel.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 4/14/22.
//

import Foundation
import CoreData
import SwiftUI

//TODO: 1 - Initialize data from watch report, if exists
//TODO: 2 - Put in viewsection enum?
//TODO: 3 - Allow one to select date of episode?
final class EpisodeReportViewModel : ObservableObject {
    @Published var tempText : String = "Hello Episode Report View!"
    
    //Alert variables
    @Published var isShowingAlert : Bool = false
    @Published var alertText : String = ""
    @Published var isShowingSubmitConfirmation : Bool = false
    
    
    //Question Responses
    @Published var coreEmotion : CoreEmotions?
    @Published var emotionResponses : [EmotionResponses] = []
    @Published var stateEmotion : EmotionStates?
    
    /**
     An array for the methods a user engagued in to cope with their feelings
     */
    @Published var copingMethods : [CopingMethods] = []
    
    /**
     A number to represent the quality of sleep a user had
     */
    @Published var sleepQuality : Float = 0
    /**
     A number to represent the amount of time the user slept for
     */
    @Published var sleepQuantity : Float = 0
    
    /**
     A number to represnt the amount of stress a user is feeling in a range of 0-100
     */
    @Published var stressQuantity : Int = 0
    
    //Trigger
    @Published var eventType : TriggerEventTypes? = nil
    @Published var eventName : String = ""
    @Published var trigger : TriggerTypes? = nil
    @Published var triggerDescription : String = ""
    
    @State var episodeDate : Date
    
    //TODO: Link?
    @Published var linkedTrauma: TraumaType? = nil
    
    
    init(){
        //TODO: 1
        episodeDate = Date.now
    }
    
    //ViewSection Functionality
    
    enum ViewSection : Int, CaseIterable {
        case coreQuestion , //What was your core emotion
             responseQuestion, //How did you respond
             stateQuestion, //What state did you feel? (filtered by responses)
           //  physicalQuestion = 3, //Remove? (replace with empathic suggestions in review...you probably felt ___ )
           //  psychologicalQuestion = 4, //Remove? (replace with empathic suggestions in review...you probably felt ___ )
             triggerQuestion, //Event and type
             perceptionDBQuesiton,
             preconditionSleepQuestion, //Quick how did you sleep? How did you feel
             preconditionFeelQuestion,
             review
        
        var questionText : Text {
            switch self{
                
            case .coreQuestion:
               return Text("What Core Emotion did you feel")
            case .responseQuestion:
               return
                Text("What was your response to feeling ")
           //     +
          //      Text("\(coreEmotion?.name ?? "This way")")
            case .stateQuestion:
               return Text("State Question")
            case .triggerQuestion:
               return Text("Trigger Question")
            case .perceptionDBQuesiton:
               return Text("Perception Question")
            case .preconditionSleepQuestion:
               return Text("Precondition Sleep Question")
            case .preconditionFeelQuestion:
               return Text("Precondition Feelings Question")
            case .review:
                return Text("Review Confirmation Question")
            }
        }
        
        //TODO: Different Backgrounds
        var backgroundImage : String {
            switch self{
            default: return "lineBackground"
            }
        }
        
        var next : ViewSection {
            switch self {
            default : return ViewSection(rawValue: self.rawValue + 1) ?? .coreQuestion
            }
        }
        
    }
    
    //TODO: Clean up, make less clunky? Return to switch statement
    func getQuestionText(_ section : ViewSection) -> Text {
        
        switch section{
        case .coreQuestion:
            return Text("What Core Emotion did you feel?")
        case .responseQuestion:
            return (
            Text("What was your response to feeling ")
            +
            Text("\(coreEmotion?.name ?? "This way")").foregroundColor(coreEmotion?.colorPrimary ?? .black)
            +
            Text("?")
            )
        case .stateQuestion:
            return
             (Text("What state of ")
             +
              Text("\(coreEmotion?.name ?? "emotion") ").foregroundColor(coreEmotion?.colorPrimary ?? .black)
             +
             Text("did you feel?"))
        case .triggerQuestion:
            
                
            let firstLineStr : String = coreEmotion == .Sadness ? "What loss triggered your " : coreEmotion == .Fear ? "What threat gave you " : "What was the source of your "
                
                let secondLineStr : String = coreEmotion == .Anger ? " that triggered your " : " and made you feel "
            
                return (
                
                    Text(firstLineStr)
                    +
                    Text(coreEmotion?.name ?? "Emotion" ).foregroundColor(coreEmotion?.colorPrimary ?? .black)
                    +
                    Text(secondLineStr)
                    +
                    Text(stateEmotion?.name ?? "State" ).foregroundColor(coreEmotion?.colorPrimary ?? .black)
                    +
                    Text("?")
                )
                
            
            
        case .perceptionDBQuesiton:
            return Text("Perception Question")
        case .preconditionSleepQuestion:
            return Text("PreCondition Sleep Question")
        case .preconditionFeelQuestion:
            return Text("Precondition Feeling Question")
        case .review:
            return Text("Review Question")
        }
    }
    
    
    
    //TODO: 2
    func nextSection(_ viewSection : ViewSection) -> ViewSection {
        return ViewSection.allCases.first(where: {$0.rawValue == (viewSection.rawValue + 1)}) ?? viewSection
    }
    
    func previousSection(_ viewSection : ViewSection) -> ViewSection {
        return ViewSection.allCases.first(where: {$0.rawValue == (viewSection.rawValue - 1)}) ?? viewSection
    }
    
    func getStatesByResponses() -> [EmotionStates]{
        
        var retArr : [EmotionStates] = []
      
        
        
        if let unwrappedCore = coreEmotion {
            
            retArr = unwrappedCore.states
            
            emotionResponses.forEach{response in
                retArr.forEach{state in
                    if !state.responseActions.contains(response){
                        retArr.removeAll(where: {$0 == state})
                    }
                }
            } 
        }
        

        return retArr
    }
    
    
    func isValidResponse(_ viewSection : ViewSection) -> Bool {
        switch viewSection {
            
        case .coreQuestion:
            return coreEmotion != nil
        case .responseQuestion:
            return !emotionResponses.isEmpty
        case .stateQuestion:
            return stateEmotion != nil
        case .triggerQuestion:
            return (eventType != nil && !eventName.isEmpty && !triggerDescription.isEmpty && trigger != nil)
        case .perceptionDBQuesiton:
            return true
        case .preconditionSleepQuestion:
            return true
        case .preconditionFeelQuestion:
            return true
        case .review:
            return true
        }
    }
    
    
    func setAlert(_ viewSection : ViewSection) {
        alertText = "Unknown Error: Section index = \(viewSection.rawValue)"
        switch viewSection {
            
            //TODO: Replace these with things
        case .coreQuestion:
                alertText = "Please select a core emotion"
            
        case .responseQuestion:
            alertText = "Please select the response(s) that most closely fits your situation"
            
        case .stateQuestion:
            alertText = "Please select an emotion state"
            
        case .triggerQuestion:
            isShowingAlert = true
        case .perceptionDBQuesiton:
            isShowingAlert = true
        case .preconditionSleepQuestion:
            isShowingAlert = true
        case .preconditionFeelQuestion:
            isShowingAlert = true
        case .review:
            isShowingAlert = true
        }
        isShowingAlert = true
    }
    
    
    
    //Functionality
    
    /**
        Sets the core emotion when an emotion button is pressed. Toggles it on and off or sets a new one
     */
    func coreButtonPress(_ core : CoreEmotions){
        emotionResponses.removeAll()
        stateEmotion = nil
        if(coreEmotion == core){
            //Deselect core emotion and do stuff with states etc
            
            coreEmotion = nil
            //do stuff with states etc
        }else{
            coreEmotion = core
        }
    }
    
    /**
        Sets the emotion response when an emotion button is pressed. Toggles it on and off or sets a new one
     */
    func responseButtonPress(_ response : EmotionResponses){
        if(emotionResponses.contains(response)){
            emotionResponses.removeAll(where: {$0 == response})
        }else{
            emotionResponses.append(response)
        }
    }
    
    /**
     Sets the state emotion when state button is pressed. Toggles it on and off
     */
    func stateButtonPress(_ state : EmotionStates){
        if(stateEmotion == state){
            stateEmotion = nil
        }else{
            stateEmotion = state
        }
    }
    
    
    
    /**
     Builds an episode report from the current report data and saves it to the database
     */
    func buildEpisode(context moc : NSManagedObjectContext){
        //TODO: Validate data first
        //TODO: Link trauma relationship

        if let unwrappedEvent = eventType, let unwrappedTrigger = trigger, let unwrappedState = stateEmotion {
            
            let insertTrigger : TriggerEvent = TriggerEvent(context: moc)
            let insertEpisode : Episode = Episode(context: moc)
            
            insertTrigger.eventDescription = triggerDescription
            insertTrigger.setEventType(unwrappedEvent)
            insertTrigger.setTriggerType(unwrappedTrigger)
            insertTrigger.eventName = eventName
            insertTrigger.date = episodeDate
            insertTrigger.id = UUID()
            insertTrigger.episode = insertEpisode
            
            insertEpisode.id = UUID()
            insertEpisode.date = episodeDate
            insertEpisode.setState(unwrappedState)
            insertEpisode.setResponses(emotionResponses)
            insertEpisode.setCopingMethods(copingMethods)
            insertEpisode.sleepQty = sleepQuantity
            insertEpisode.sleepQuality = Int16(sleepQuality)
            insertEpisode.trigger = insertTrigger
            insertEpisode.stressLevel = Int16(stressQuantity)
            insertEpisode.trigger = insertTrigger
            
            
        }
        try? moc.save()
        
        
    }
}
