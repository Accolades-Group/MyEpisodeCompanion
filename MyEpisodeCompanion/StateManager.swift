//
//  StateManager.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/28/22.
//

import Foundation

final class StateManager : ObservableObject {
    
    //Debugging
    @Published var isDebugging = false
    @Published var debugView = ContentView()
    
    //TODO: Verify login
    @Published var isLoggedIn : Bool = true
    
    //Tabs
    enum Tab : Int{
        case Home = 0, History = 1
    }
    @Published var tabViewSelection : Tab = .Home
}
