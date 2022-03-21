//
//  ControlsView.swift
//  MyEpisodeCompanion WatchKit Extension
//
//  Created by Tanner Brown on 3/21/22.
//

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var episodeManager : WorkoutManager
    var body: some View {
        HStack { //To create side-by-side buttons if second is needed
            VStack{
                Button {
                    episodeManager.endEpisode()
                } label: {
                    Image(systemName: "xmark").padding()
                }
                .tint(.green)
                .font(.title2)
                Text("End Episode")
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
