//
//  ControlsView.swift
//  MyEpisodeCompanion WatchKit Extension
//
//  Created by Tanner Brown on 3/21/22.
//

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var episodeManager : WorkoutManager
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: []) var trackedEpisodes : FetchedResults<TrackedEpisode>

    var body: some View {
        HStack { //To create side-by-side buttons if second is needed
            VStack{
                Button {
                    episodeManager.endEpisode(context: moc)
                } label: {
                    Image(systemName: "xmark").padding()
                }
                .tint(.green)
                .font(.title2)
                Text("End Episode")
                
                Text("Tracked Episode Count: \(trackedEpisodes.count)")

            }
            
//            VStack{
//                Button {
//
//                } label: {
//                    Image(systemName: "xmark")
//                }
//                .tint(.green)
//                .font(.title2)
//                Text("End Episode")
//            }
            
        }
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView()
    }
}
