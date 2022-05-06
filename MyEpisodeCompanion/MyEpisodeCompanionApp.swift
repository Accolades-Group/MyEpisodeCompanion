//
//  MyEpisodeCompanionApp.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/19/22.
//

import SwiftUI
import HealthKit


// Global variables
var myHealthStore : HKHealthStore?
var myUserSettings : UserSettings = UserSettings()
//var myHealthHistory : History = History()



@main
struct MyEpisodeCompanionApp: App {
    
    @StateObject var stateManager = StateManager()
    @StateObject private var dataController = DataController()
    //var myHealthHistory : History = History()
    
    init(){
        

        
        if HKHealthStore.isHealthDataAvailable(){
            
          //  print("Yay!")
            myHealthStore = HKHealthStore()
            
            //Request access to following data types
                /*
                 Heart Rate,
                 HRV
                 V02Max
                 Respitory Rate
                 Temp
                 Blood Oxygen
                 Step Count
                 */
            let allTypes = Set([
                HKQuantityType.quantityType(forIdentifier: .heartRate)!,
                HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
                HKQuantityType.quantityType(forIdentifier: .vo2Max)!,
                HKQuantityType.quantityType(forIdentifier: .respiratoryRate)!,
                HKQuantityType.quantityType(forIdentifier: .bodyTemperature)!,
                HKQuantityType.quantityType(forIdentifier: .oxygenSaturation)!,
                HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
                               ])

            myHealthStore?.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
                if success {
                    // save the sample here or call method that saves sample
                } else {
                    // Handle the error here. Failed to request, not denied auth, you can retry
                }
            }
            
            
        } else {
            
            print("Boo!")
            
        }
        
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(stateManager)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
