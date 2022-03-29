//
//  MyEpisodeCompanionApp.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/19/22.
//

import SwiftUI
import HealthKit


// Global variables
var healthStore : HKHealthStore?
var myUserSettings : UserSettings = UserSettings()




@main
struct MyEpisodeCompanionApp: App {
    
    @StateObject var stateManager = StateManager()
    
    
    init(){
        
        if HKHealthStore.isHealthDataAvailable(){
            
            print("Yay!")
            healthStore = HKHealthStore()
            
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
                HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
                               ])

            healthStore?.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
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
            ContentView()
                .environmentObject(stateManager)
        }
    }
}
