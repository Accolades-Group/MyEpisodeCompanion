//
//  MyEpisodeCompanionApp.swift
//  MyEpisodeCompanion WatchKit Extension
//
//  Created by Tanner Brown on 3/19/22.
//

import SwiftUI

@main
struct MyEpisodeCompanionApp: App {
    
    @StateObject var episodeManager = WorkoutManager()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
            }.sheet(isPresented: $episodeManager.showingSummaryView){
                SummaryView()
            }
            .environmentObject(episodeManager)
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
