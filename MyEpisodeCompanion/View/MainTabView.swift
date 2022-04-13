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
    
    @FetchRequest(sortDescriptors: []) var checkinHistory : FetchedResults<Checkin>
    
    @FetchRequest(sortDescriptors: []) var episodeHistory : FetchedResults<Episode>
    
    var body: some View {
        
        
        
        
        TabView(selection: $stateManager.tabViewSelection){
            
            NavigationView{
                HomeView()
                    .environmentObject(stateManager)
                    .environment(\.managedObjectContext, moc)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                
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
            if(stateManager.isDebugData){
                NavigationView{
                    VStack{
                    HStack{
                        Button("Add Episode"){
                            let episode = Episode(context: moc)
                            episode.id = UUID()
                            episode.date = Date.now
                            //TODO: Precondition checksin?
                            episode.howDidIFeel = "Anger+Fury+TestResponse"
                            episode.howDidIReact = "ScreamYell,Undermine,Insult,WalkAway"
                            episode.whatTriggeredMe = "Rejection+Insulted"
                            episode.physicalChanges = "Shaking,HeartRacing,Sweating"
                            episode.whatDidItFeelLike = "Rejection"
                            episode.whatDidThatRemindMeOf = "Getting Fired"
                            episode.howDidICopeAfterComeDown = "Drugs+Tobacco"
                            
                            try? moc.save()
                            
                        }
                        Button("Add Check"){
                            let check = Checkin(context: moc)
                            check.date = Date.now
                            check.id = UUID()
                            check.sleepQuality = NSNumber(7)
                            check.sleepQuantity = NSNumber(7.7)
                            check.howAmIFeeling = "Fear+Anxiety+Response"
                            check.whereIsMyHeadSpace = "Breaking Up With GF"
                            check.whatDoIFeelINeed = "Space and time to myself"
                            check.stressLevel = NSNumber(72)
                            check.howHaveICoped = "Smoked,Drank"
                            
                            try? moc.save()
                        }
                    }
                    Button{
                        
                        for episode in episodeHistory {
                            moc.delete(episode)
                            try? moc.save()
                        }
                        
                        for checkin in checkinHistory {
                            moc.delete(checkin)
                            try? moc.save()
                        }
                        
                    } label : {
                        Text("DELETE ALL HISTORY").foregroundColor(.red).fontWeight(.bold)
                    }.padding()
                        
                        Button{
                            
                            for episode in episodeHistory.filter({
                                
                                Calendar.current.isDate(Date.now, equalTo: $0.date!, toGranularity: .day)
                                
                            }) {
                                moc.delete(episode)
                                try? moc.save()
                            }
                            
                            for checkin in checkinHistory.filter({
                                Calendar.current.isDate(Date.now, equalTo: $0.date!, toGranularity: .day)
                            }) {
                                moc.delete(checkin)
                                try? moc.save()
                            }
                            
                        } label : {
                            Text("DELETE TODAY HISTORY").foregroundColor(.red).fontWeight(.bold)
                        }.padding()
                    }
                }.tabItem{
                    
                    Image(systemName: "exclamationmark.triangle")
                    Text("Modify History")
                    
                }.tag(StateManager.Tab.Delete)
                
            }//.ignoresSafeArea(.keyboard, edges: .bottom)
        }
        
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(StateManager())
    }
}
