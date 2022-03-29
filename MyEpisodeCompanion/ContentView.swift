//
//  ContentView.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/19/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var stateManager : StateManager
    
    var body: some View {
        
        //Debug
        if(stateManager.isDebugging){
            stateManager.debugView
        }
        
        else if(stateManager.isLoggedIn){
            
            MainTabView()
                .environmentObject(stateManager)
            
        }
        
        //Login / Register
        else {
            
            LoginRegisterView()
            
        }
        

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(StateManager())
    }
}
