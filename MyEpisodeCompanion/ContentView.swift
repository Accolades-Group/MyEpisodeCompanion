//
//  ContentView.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/19/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationView{
        
        NavigationLink(
            "Record Episode",
            destination: EpisodeRecordView())
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
