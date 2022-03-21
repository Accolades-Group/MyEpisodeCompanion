//
//  ContentView.swift
//  MyEpisodeCompanion WatchKit Extension
//
//  Created by Tanner Brown on 3/19/22.
//

import SwiftUI
import HealthKit

struct StartView: View {
    @EnvironmentObject var workoutManager : WorkoutManager
    var workoutTypes : [HKWorkoutActivityType] = [.walking /*, .cooldown*/]
    var body: some View {
        List(workoutTypes){workoutType in
            NavigationLink("Record Episode",
                           destination: SessionPagingView(),
                           tag: workoutType,
                           selection: $workoutManager.selectedEpisode
            ).padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5)
            )
        }.listStyle(.carousel)
            .navigationBarTitle("Workouts")
            .onAppear{
                workoutManager.requestAuthorization()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}

extension HKWorkoutActivityType : Identifiable {
    public var id: UInt {
        rawValue
    }
    
    var name: String{
        switch self{
        case .cooldown : return "Cool Down"
        case .mindAndBody : return "Episode"
        default : return ""
        }
    }
}
