//
//  MyEpisodeCompanionApp.swift
//  MyEpisodeCompanion WatchKit Extension
//
//  Created by Tanner Brown on 3/19/22.
//

import SwiftUI

@main
struct MyEpisodeCompanionApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
