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
    @Published var debugView = DebugQuestionView()
    @Published var isDebugData = true
    
    //TODO: Verify login
    @Published var isLoggedIn : Bool = true
    
    //Tabs
    enum Tab : Int{
        case Home = 0, History = 1, Delete = 2
    }
    @Published var tabViewSelection : Tab = .Home
    @Published var checkinReportIsShown : Bool = false
    @Published var episodeReportIsShown : Bool = false
    
    func goHome() {
        tabViewSelection = .Home
        checkinReportIsShown = false
        episodeReportIsShown = false
    }
}
