//
//  EpisodeDataReportView.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/19/22.
//

import SwiftUI

struct EpisodeRecordView: View {
    
    @StateObject var viewModel : EpisodeRecordViewModel = EpisodeRecordViewModel()
    
    var body: some View {
        VStack{
            Text("Statistics Data").font(.title)
            Text(viewModel.readData())
            
        }

    }
}

struct EpisodeRecordView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeRecordView()
    }
}
