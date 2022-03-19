//
//  MyEpisodeCompanionApp.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/19/22.
//

import SwiftUI
import HealthKit

@main
struct MyEpisodeCompanionApp: App {
    
    var healthStore : HKHealthStore?
    
    init(){
        if HKHealthStore.isHealthDataAvailable(){
            
            print("Yay!")
            healthStore = HKHealthStore()
            
        } else {
            
            print("Boo!")
            
        }
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
