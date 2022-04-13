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

final class CheckinReportViewModel : ObservableObject {
    
    /**
     The core emotion for this checkin. These are basic emotions such as anger, sadness or joy
     */
    @Published var core : CoreEmotion?
    
    /**
     The state emotion for this checkin. These are states of core emotions, such as frustration, sorrow or pride
     */
    @Published var state : EmotionState?
    
    /**
     An explination for why the user feels the emotion
     */
    @Published var emotionExplination : String = ""
    
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
    @Published var sleepQuality : Float = 5
    /**
     A number to represent the amount of time the user slept for
     */
    @Published var sleepQuantity : Float = 8
    
    /**
     For future use:
     A boolean for tracking if sleep amount was recorded from the user's Health Kit Data
     */
    @Published var didGetSleepFromHK : Bool = false
    
    /**
     A number to represnt the amount of stress a user is feeling in a range of 0-100
     */
    @Published var stressQuantity : Float = 50
    
    /**
     The user's response to the question of what they feel they need emotionally at the time of this checkin
     */
    @Published var whatDoIFeelINeed : String = ""
    /**
     The user's response to the question of where their headspace is at the time of this checkin
     */
    @Published var whereIsMyHeadspace : String = ""
    
    //viewbindings

    enum ViewSection : Int, CaseIterable {
        case
        emotionQuestion = 0,
        emotionExplanationQuestion = 1,
        headspaceQuestion = 2,
        stressLevelQuestion = 3,
        needQuestion = 4,
        sleepQuestion = 5,
        copeQuestion = 6,
        review = 7
    }
    
    func nextSection(_ section : ViewSection) -> ViewSection {
        switch section {
        case .emotionQuestion : return .emotionExplanationQuestion
        case .emotionExplanationQuestion: return .headspaceQuestion
        case .headspaceQuestion : return .stressLevelQuestion
        case .stressLevelQuestion : return .needQuestion
        case .needQuestion : return .sleepQuestion
        case .sleepQuestion : return .copeQuestion
        case .copeQuestion : return .review
        case .review : return .review
        }
    }
    
    
    //Alert variables
    @Published var isShowingAlert : Bool = false
    @Published var alertText : String = ""
    @Published var isShowingSubmitConfirmation : Bool = false
    

    /**
     The text for the current question being asked
     */
    var questionText : Text {
        switch self.sectionIndex.rawValue{
        case 0: return Text("What emotion are you feeling?")
        case 1: return Text("Can you explain why you are feeling ") + Text(state?.name ?? "").foregroundColor(getEmotionColors(core ?? EmotionConstants.Cores.Joy)) + Text("?")
        case 2: return Text("What thoughts are taking up most of your headspace?")
        case 3: return Text("What is your stress level currently at?")
        case 4: return Text("What do you feel you need in this moment?")
        case 5: return Text("What was your sleep like?")
        case 6: return Text("What have you done today to cope with your stress or ") + Text(core?.name ?? "").foregroundColor(getEmotionColors(core ?? EmotionConstants.Cores.Joy)) + Text("?")
        case 7: return Text("Please review your Check In")
        default: return Text("")
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
    @Published var sectionIndex : ViewSection = .emotionQuestion
    
    init(){
        //TODO: Grab sleep from healthkit if available
        //TODO: Grab biometrics from healthkit if available
        if let unwrappedStore = myHealthStore {
            if let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis){
                let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
                let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]){(query, tmpResult, error ) -> Void in
                    
                    if error != nil {
                        //TODO: Log error
                        return
                    }
                    if let result = tmpResult {
                        for item in result {
                            if let sample = item as? HKCategorySample {
                                
                                let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
                                if(value.contains("Asleep")){
                                    let sleeptime = Calendar.current.dateComponents([.hour, .minute], from: sample.startDate, to: sample.endDate)
                                    print(sleeptime)
                                    //TODO: Save as sleep time float. Make sleeptime a string and convert it?
                                }
                                
                                
                            }
                        }
                    }
                }
                
                unwrappedStore.execute(query)
            }
        }
    }
    
    /**
     Gets the state options for the currently selected core emotion
     */
    func getStateOptions() -> [EmotionState]{
        var retArr : [EmotionState] = []

        //TODO: Clean this up and make work with animation
        if let unwrappedCore = core {
            retArr = EmotionConstants.Cores.getStatesByCore(unwrappedCore)
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
    
    func setAlert() {
        switch self.sectionIndex.rawValue{
        case 0:
            alertText = core == nil ? "Please select an emotion" : state == nil ? "Please select a state" : "Unknown error"
            isShowingAlert = true
            
        case 1:
            alertText = emotionExplination.isEmpty ? "Please write a response" : emotionExplination.count < 5 ? "Response too short!" : "Unknown error"
            isShowingAlert = true
            
        case 2:
            alertText = whereIsMyHeadspace.isEmpty ? "Please write a response" : whereIsMyHeadspace.count < 5 ? "Response too short!" : "Unknown error"
            isShowingAlert = true
            
        case 4:
            alertText = whatDoIFeelINeed.isEmpty ? "Please write a response" : whatDoIFeelINeed.count < 5 ? "Response too short!" : "Unknown error"
            isShowingAlert = true
            
        case 6:
            alertText = copingMethods.isEmpty ? "Please make a selection, or select 'Nothing' to indicate that you didn't cope today" : "Unknown error"
            isShowingAlert = true
            
        default: return
        }
    }
    
    /**
     Checks if the currently given data is valid for a response, if not, it triggers an alert to the user
     */
    func isValidResponse() -> Bool {
        switch self.sectionIndex{
        case .emotionQuestion:
            return core != nil && state != nil


        case .emotionExplanationQuestion:
            return !emotionExplination.isEmpty && emotionExplination.count >= 5
        
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
        }
    }
    
    /**
     Builds a checkin from the current checkin data and saves it to the database
     */
    func buildCheckin(context moc : NSManagedObjectContext){
        //TODO: Validate data first
        let checkin = Checkin(context: moc)
        
        checkin.date = Date.now
        checkin.id = UUID()
        checkin.howAmIFeeling = (core?.name ?? "No Core") + "+" + (state?.name ?? "No State") + "+" + (emotionExplination)
        var copeStr : String = ""
        
        copingMethods.forEach{method in
            copeStr.append(contentsOf: method.name+"+")
        }
        checkin.howHaveICoped = String(copeStr.dropLast())
        checkin.sleepQuality = NSNumber(value: sleepQuality)
        checkin.sleepQuantity = NSNumber(value: sleepQuantity)
        checkin.stressLevel = NSNumber(value: stressQuantity)
        checkin.whereIsMyHeadSpace = whereIsMyHeadspace
        checkin.whatDoIFeelINeed = whatDoIFeelINeed
        
        print("Here!")
        try? moc.save()
        
        
    }
}
