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
final class EpisodeReportViewModel : ObservableObject {
    @Published var tempText : String = "Hello Episode Report View!"
    
    //Alert variables
    @Published var isShowingAlert : Bool = false
    @Published var alertText : String = ""
    @Published var isShowingSubmitConfirmation : Bool = false
    
    
    //Question Responses
    @Published var coreEmotion : CoreEmotion?
    @Published var emotionResponses : [EmotionResponseAction] = []
    @Published var stateEmotion : EmotionState?
    
    
    init(){
        //TODO: 1
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
            Text("\(coreEmotion?.name ?? "This way")").foregroundColor(getEmotionColors(coreEmotion ?? EmotionConstants.Cores.Other))
            +
            Text("?")
            )
        case .stateQuestion:
            return
             (Text("What state of ")
             +
             Text("\(coreEmotion?.name ?? "emotion") ").foregroundColor(getEmotionColors(coreEmotion ?? EmotionConstants.Cores.Other))
             +
             Text("did you feel?"))
        case .triggerQuestion:
            
                
                let firstLineStr : String = coreEmotion == EmotionConstants.Cores.Sadness ? "What loss triggered your " : coreEmotion == EmotionConstants.Cores.Fear ? "What threat gave you " : "What was the source of your "
                
                let secondLineStr : String = coreEmotion == EmotionConstants.Cores.Anger ? " that triggered your " : " and made you feel "
                return (
                
                    Text(firstLineStr)
                    +
                    Text(coreEmotion?.name ?? "Emotion" ).foregroundColor(getEmotionColors(coreEmotion ?? EmotionConstants.Cores.Other))
                    +
                    Text(secondLineStr)
                    +
                    Text(stateEmotion?.name ?? "State" ).foregroundColor(getEmotionColors(coreEmotion ?? EmotionConstants.Cores.Other))
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
    
    
    func isValidResponse(_ viewSection : ViewSection) -> Bool {
        switch viewSection {
            
        case .coreQuestion:
            return coreEmotion != nil
        case .responseQuestion:
            return !emotionResponses.isEmpty
        case .stateQuestion:
            return stateEmotion != nil
        case .triggerQuestion:
            return true
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
    func coreButtonPress(_ core : CoreEmotion){
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
    func responseButtonPress(_ response : EmotionResponseAction){
        if(emotionResponses.contains(response)){
            emotionResponses.removeAll(where: {$0 == response})
        }else{
            emotionResponses.append(response)
        }
    }
    
    /**
     Sets the state emotion when state button is pressed. Toggles it on and off
     */
    func stateButtonPress(_ state : EmotionState){
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

        try? moc.save()
        
        
    }
}
