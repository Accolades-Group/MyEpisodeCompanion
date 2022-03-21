//
//  SessionPagingView.swift
//  MyEpisodeCompanion WatchKit Extension
//
//  Created by Tanner Brown on 3/21/22.
//

import SwiftUI
import WatchKit

struct SessionPagingView: View {
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @State private var selection : Tab = .metrics
    
    @EnvironmentObject var episodeManager : WorkoutManager
    
    enum Tab {
        case controls, metrics, grounding
    }
    
    var body: some View {
        TabView(selection: $selection){
            ControlsView().tag(Tab.controls)
            MetricsView().tag(Tab.metrics)
            NowPlayingView().tag(Tab.grounding)
        }
        .navigationTitle(episodeManager.selectedEpisode?.name ?? "")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(selection == .grounding)
        .onChange(of: episodeManager.running){ _ in
            displayMetricsView()
        }
        .tabViewStyle(
            PageTabViewStyle(indexDisplayMode: isLuminanceReduced ? .never : .automatic)
        )
        .onChange(of: isLuminanceReduced){ _ in
            displayMetricsView()
        }
    }
    private func displayMetricsView() {
        withAnimation(){
            selection = .metrics
        }
    }
}

struct SessionPagingView_Previews: PreviewProvider {
    static var previews: some View {
        SessionPagingView()
    }
}
