//
//  CheckinReportViewModel.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 4/5/22.
//

import Foundation
import CoreData
import HealthKit
import SwiftUI
import Speech
import AVFoundation

final class CheckinReportViewModel : ObservableObject {
    
    
    
    /**
     The core emotion for this checkin. These are basic emotions such as anger, sadness or joy
     */
    @Published var core : CoreEmotion?
    @Published var secondaryCore : CoreEmotion?
    
    /**
     The state emotion for this checkin. These are states of core emotions, such as frustration, sorrow or pride
     */
    @Published var state : EmotionState?
    @Published var secondaryState : EmotionState?
    
    /**
     An explination for why the user feels the emotion
     */
    @Published var emotionExplination : String = ""
    @Published var secondaryEmotionExplination : String = ""
    
    /**
    A flag to indicate if a secondary emotion and response has been added
     */
    @Published var hasSecondary : Bool?
    
    
    
    /**
     An array for the methods a user engagued in to cope with their feelings
     */
    @Published var copingMethods : [CopingMethod] = []
    /**
     A boolean that is flagged if the user didn't cope with any emotions
     */
    @Published var isDidntCope : Bool = false
    
    /**
     A number to represent the quality of sleep a user had
     */
    @Published var sleepQuality : Float = 0
    /**
     A number to represent the amount of time the user slept for
     */
    @Published var sleepQuantity : Float = 0
    
    /**
     For future use:
     A boolean for tracking if sleep amount was recorded from the user's Health Kit Data
     */
    @Published var didGetSleepFromHK : Bool = false
    
    /**
     A boolean for tracking if the sleep data was retrieved from a previous checkin
     */
    @Published var didGetSleepFromPrior : Bool = false
    
    /**
     A number to represnt the amount of stress a user is feeling in a range of 0-100
     */
    @Published var stressQuantity : Int = 0
    
    /**
     The user's response to the question of what they feel they need emotionally at the time of this checkin
     */
    @Published var whatDoIFeelINeed : String = ""
    /**
     The user's response to the question of where their headspace is at the time of this checkin
     */
    @Published var whereIsMyHeadspace : String = ""
    
    
    //Alert variables
    @Published var isShowingAlert : Bool = false
    @Published var alertText : String = ""
    @Published var isShowingSubmitConfirmation : Bool = false
    
    //view variables
    @Published var isRecording : Bool = false
    @Published var speechRecognizer : SpeechRecognizer = SpeechRecognizer()
    @Published var transcribeText : String = ""
    
    
    
    
    func toggleRecording(viewSection : ViewSection) {
        isRecording.toggle()
        if(isRecording){
            speechRecognizer.transcribe()
            transcribeText = speechRecognizer.transcript
        }else{
            speechRecognizer.stopTranscribing()
            if(viewSection == .needQuestion){
                whatDoIFeelINeed += speechRecognizer.transcript
            }else if(viewSection == .headspaceQuestion){
                whereIsMyHeadspace += speechRecognizer.transcript
            }else if(viewSection == .emotionExplanationQuestion){
                emotionExplination += speechRecognizer.transcript
            }
            speechRecognizer.reset()
        }
    }


    enum ViewSection : Int, CaseIterable {
        
        case
        
        emotionQuestion,
        emotionExplanationQuestion,
        /* TODO: Secondary emotions?
        hasSecondEmotionQuestion,
        secondEmotionQuestion,
        secondEmotionExplinationQuestion,
        */
        headspaceQuestion,
        stressLevelQuestion,
        needQuestion,
        sleepQuestion,
        copeQuestion,
        review,
        congratulations
        
    }
    
    @Published var currentSection : ViewSection?
    
    
    //TODO: Clean up, less clunky, get viewSection++?
    func nextSection(_ section : ViewSection) -> ViewSection {
        
        return ViewSection.allCases.first(where: {$0.rawValue == (section.rawValue + 1)}) ?? section
    }
    
    func previousSection(_ section : ViewSection) -> ViewSection {
        return ViewSection.allCases.first(where: {$0.rawValue == (section.rawValue) - 1}) ?? section
    }

    /**
     The text for the current question being asked
     */
    func getQuestionText(_ viewSection : ViewSection) -> Text {
        switch viewSection{
        case .emotionQuestion: return Text("What emotion are you feeling?")
        case .emotionExplanationQuestion: return Text("Can you explain why you are feeling ") + Text(state?.name ?? "").foregroundColor(core?.color ?? EmotionConstants.Cores.Joy.color) + Text("?")
           
            /* TODO: Secondary Emotions?
        case .hasSecondEmotionQuestion: return Text("Would you like to report feeling a secondary emotion?")
        case .secondEmotionQuestion: return Text("What other emotion are you feeling?")
        case .secondEmotionExplinationQuestion: return Text("Can you explain why you are feeling ") + Text(secondaryState?.name ?? "").foregroundColor(secondaryCore?.color ?? EmotionConstants.Cores.Joy.color) + Text("?")
            */
            
        case .headspaceQuestion: return Text("What thoughts are taking up most of your headspace?")
        case .stressLevelQuestion: return Text("What is your stress level currently at?")
        case .needQuestion: return Text("What do you feel you need in this moment?")
        case .sleepQuestion: return Text("What was your sleep like?")
        case .copeQuestion: return Text("How have you coped with your stress or ") + Text(core?.name ?? "").foregroundColor(getEmotionColors(core ?? EmotionConstants.Cores.Joy)) + Text(" today?")
        case .review: return Text("Please review your Check In")
        case .congratulations: return Text("") // empty
        //default: return Text("")
        }
    }
    

    
    /*
     0 = Emotion & State selection
     1 = Explanation of emotion & state
     2 = Headspace question
     3 = Stress Level
     4 = What do I feel I need
     5 = Sleep Analysis
     6 = Coping
     7 = Review & submit
     */
   // @Published var sectionIndex : ViewSection = .emotionQuestion
    
    init(){
        
        //TODO: Grab biometrics from healthkit if available
        
        if let unwrappedStore = myHealthStore {
            // First, define the object type we want
            if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis){
                //Use sortDescriptor to get the recent data first
                let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
                
                //query with a block completion to execute
                let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 30, sortDescriptors: [sortDescriptor]){ (query, tmpResult, error) -> Void in
                    
                    if error != nil {
                        print(" ***** Error! ***** ")
                        print(error?.localizedDescription as Any)
                        return
                    }
                    
                    if let result = tmpResult {
                        
                        //do something with my data
                        for item in result {
                            if let sample = item as? HKCategorySample {
                                if sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue {
                                    //TODO: within last 24 hrs?
                                    
                                    print("Asleep Time : \(sample.startDate) \(sample.endDate) \(sample.description)")
                                    var duration = (sample.endDate.timeIntervalSince(sample.startDate) / 60) / 60
                                    duration = round(duration * 0.5)/0.5
                                    print("Duration : \(duration)")
                                    print("Done")
                                    
                                    if(duration > 0){
                                        DispatchQueue.main.async{
                                            self.sleepQuantity = Float(duration)
                                            self.didGetSleepFromHK = true
                                            
                                        }
                                    }
                                }
                            }
                        }
                    } else {print("No results")}
                    
                }
                
                unwrappedStore.execute(query)
                
            }else{print("failed sleep type")}
        } else {print("Failed to unwrap store")}
        

         
    }
    
    
    func checkPrior(_ check : UnwrappedCheckin){
        
        if Calendar.current.isDateInToday(check.date){
            sleepQuality = Float(check.sleepQuality)
            sleepQuantity = check.sleepQuantity
            didGetSleepFromPrior = true
        }
        
    }
    
    func getBackgroundImage() -> Image {
        var imgStr : String
        switch self.core {
        case EmotionConstants.Cores.Sadness: imgStr = "bluecircle"
        case EmotionConstants.Cores.Fear: imgStr = "purplecircle"
        case EmotionConstants.Cores.Joy: imgStr = "yellowcircle"
        case EmotionConstants.Cores.Anger: imgStr = "redcircle"
        case EmotionConstants.Cores.Disgust: imgStr = "greencircle"
            
        default: imgStr = ""
        }
        
        return Image(imgStr)
    }
    
    /**
     Gets the state options for the currently selected core emotion
     */
    func getStateOptions() -> [EmotionState]{
        var retArr : [EmotionState] = []

        //TODO: Clean this up and make work with animation
        if let unwrappedCore = core {
            retArr = EmotionConstants.getStatesByCore(unwrappedCore)
        }
        return retArr
    }
    
    /**
     Gets the description for the current selected state emotion, or core emotion, depending on what is selected
     */
    func getEmotionDescription() -> Text {
        
        if let unwrappedState = state {
            return Text(unwrappedState.description)
                .foregroundColor(getEmotionColors(unwrappedState.core))
        }else if let unwrappedCore = core{
            return Text(unwrappedCore.description)
                .foregroundColor(getEmotionColors(unwrappedCore))
        }else{
            return Text("")
        }
        
    }
    
    func toggleCore(_ coreEmotion : CoreEmotion){
        
        core = core == coreEmotion ? nil : coreEmotion
        state = nil
    }
    
    func setAlert(_ viewSection : ViewSection) {
        switch viewSection{
        case .emotionQuestion:
            alertText = core == nil ? "Please select an emotion" : state == nil ? "Please select a state" : "Unknown error"
            isShowingAlert = true
            
        case .emotionExplanationQuestion:
            alertText = emotionExplination.isEmpty ? "Please write a response" : emotionExplination.count < 5 ? "Response too short!" : "Unknown error"
            isShowingAlert = true
            
        case .headspaceQuestion:
            alertText = whereIsMyHeadspace.isEmpty ? "Please write a response" : whereIsMyHeadspace.count < 5 ? "Response too short!" : "Unknown error"
            isShowingAlert = true
            
        case .needQuestion:
            alertText = whatDoIFeelINeed.isEmpty ? "Please write a response" : whatDoIFeelINeed.count < 5 ? "Response too short!" : "Unknown error"
            isShowingAlert = true
            
        case .copeQuestion:
            alertText = copingMethods.isEmpty ? "Please make a selection, or select 'Nothing' to indicate that you didn't cope today" : "Unknown error"
            isShowingAlert = true
            
        default: return
        }
    }
    
    /**
     Checks if the currently given data is valid for a response, if not, it triggers an alert to the user
     */
    func isValidResponse(_ viewSection : ViewSection) -> Bool {
        switch viewSection{
        case .emotionQuestion:
            return core != nil && state != nil

        case .emotionExplanationQuestion:
            return !emotionExplination.isEmpty && emotionExplination.count >= 5
            
            /* TODO: Secondary Emotion?
        case .hasSecondEmotionQuestion:
            return hasSecondary != nil
            
        case .secondEmotionQuestion:
            return  (secondaryCore != nil && secondaryState != nil)
            
        case .secondEmotionExplinationQuestion:
            return  (secondaryEmotionExplination.isEmpty && secondaryEmotionExplination.count >= 5)
        */
            
        case .headspaceQuestion:
            return !whereIsMyHeadspace.isEmpty && whereIsMyHeadspace.count >= 5
            
        case .stressLevelQuestion:
            return true //TODO: Validate?
            
        case .needQuestion:
            return !whatDoIFeelINeed.isEmpty && whatDoIFeelINeed.count >= 5
            
        case .sleepQuestion:
            return true //TODO: Validate?
            
        case .copeQuestion:
            return !copingMethods.isEmpty || isDidntCope

            
        case .review:
            //isShowingSubmitConfirmation = true
            return false
            
        case .congratulations:
            return false //never should be called
        }
    }
    
    func calculateStress(_ stressors: [Stressor]){
        self.stressQuantity = 0
        stressors.forEach{stressor in
            self.stressQuantity += Int(stressor.weight)
        }
        print(self.stressQuantity)
    }
    
    /**
     Builds a checkin from the current checkin data and saves it to the database
     */
    func buildCheckin(context moc : NSManagedObjectContext) -> Error?{
        //TODO: Validate data first!!!!
        if let unwrappedCore = core, let unwrappedState = state {
        let checkin = Checkin(context: moc)
        
        checkin.buildVals(date : Date.now, uuid : UUID(), sleepQty: sleepQuantity, sleepQual: Int(sleepQuality), headspace: whereIsMyHeadspace, needQuestion: whatDoIFeelINeed, stresslvl: stressQuantity)
        
        checkin.buildCopingString(copingMethods: copingMethods)
        checkin.buildFeelings(core: unwrappedCore, state: unwrappedState, response: emotionExplination)

            do{
                try moc.save()
                
            }catch{
                print(error)
                return error
            }
            
        } else {
            //TODO: Return error
            
        }
        return nil
    }
}

