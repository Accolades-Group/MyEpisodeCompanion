//
//  MainTabView.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/28/22.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var stateManager : StateManager
    
    var body: some View {
        TabView(selection: $stateManager.tabViewSelection){
            
            NavigationView{
                HomeView()
                    .environmentObject(stateManager)
                
            }.tabItem{
                
                Image(systemName: stateManager.tabViewSelection == .Home ? "house.fill" : "house")
                
                Text("Home")
                    .fontWeight(stateManager.tabViewSelection == .Home ? .bold : .medium)
                
            }.tag(StateManager.Tab.Home)
            
            
            NavigationView{
                HistoryView()
                    .environmentObject(stateManager)
            }.tabItem{
                
                Image(systemName: stateManager.tabViewSelection == .History ? "clock.fill" : "clock")
                
                Text("History")
                    .fontWeight(stateManager.tabViewSelection == .History ? .bold : .medium)
                
            }.tag(StateManager.Tab.History)
            
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(StateManager())
    }
}
