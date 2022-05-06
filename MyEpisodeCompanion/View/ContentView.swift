//
//  ContentView.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/19/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @EnvironmentObject var stateManager : StateManager
    @Environment(\.managedObjectContext) var moc

    @FetchRequest(sortDescriptors: []) var checkinHistory : FetchedResults<Checkin>
    
    
    var body: some View {
        VStack{
        //Debug
            if(stateManager.isDebugging){
                
                stateManager.debugView
                    .environmentObject(stateManager)
                    .environment(\.managedObjectContext, moc)
                
            }
            
            
            else if(stateManager.isLoggedIn){

                MainTabView()
                    .environmentObject(stateManager)
                    .environment(\.managedObjectContext, moc)

            }
            
            //Login / Register
            else {
                
                LoginRegisterView()
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
            .environmentObject(StateManager())
    }
}
