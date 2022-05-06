//
//  MainTabView.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/28/22.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var stateManager : StateManager
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        
        
        
        
        TabView(selection: $stateManager.tabViewSelection){
            
            
            
            NavigationView{
                HomeView()
                    .environmentObject(stateManager)
                    .environment(\.managedObjectContext, moc)                
            }.tabItem{
                
                Image(systemName: stateManager.tabViewSelection == .Home ? "house.fill" : "house")
                
                Text("Home")
                    .fontWeight(stateManager.tabViewSelection == .Home ? .bold : .medium)
                
            }.tag(StateManager.Tab.Home)
            
            
            NavigationView{
                HistoryCalendarView()
                    .environmentObject(stateManager)
                    .environment(\.managedObjectContext, moc)
                
            }.tabItem{
                
                Image(systemName: stateManager.tabViewSelection == .History ? "clock.fill" : "clock")
                
                Text("History")
                    .fontWeight(stateManager.tabViewSelection == .History ? .bold : .medium)
                
            }.tag(StateManager.Tab.History)
            
            NavigationView{
                ResourcesView()
                    .environmentObject(stateManager)
                    .environment(\.managedObjectContext, moc)
            }.tabItem{
                
                Image(systemName: stateManager.tabViewSelection == .Resources ? "newspaper.fill" : "newspaper")
                
                Text("Resources")
                    .fontWeight(stateManager.tabViewSelection == .Resources ? .bold : .medium)
                
            }.tag(StateManager.Tab.Resources)
            

                NavigationView{
                    AccountView()
                        .environmentObject(stateManager)
                        .environment(\.managedObjectContext, moc)
                }.tabItem{
                    
                    Image(systemName: stateManager.tabViewSelection == .Account ? "person.crop.circle.fill" : "person.crop.circle")
                    Text("Account")
                    
                }.tag(StateManager.Tab.Account)
                
           

        }
        .onAppear{
//            let appearance = UITabBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            if #available(iOS 15.0, *){
//                UITabBar.appearance().scrollEdgeAppearance = appearance
//            }
        }
        
        
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(StateManager())
    }
}
