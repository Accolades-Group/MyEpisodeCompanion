//
//  HomeView.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/28/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var stateManager : StateManager

    
    var body: some View {
        
        Text("Hello, Home View")
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
