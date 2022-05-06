//
//  HomeView.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/28/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var stateManager : StateManager
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: []) var checkinHistory : FetchedResults<Checkin>
    @FetchRequest(sortDescriptors: []) var trackedEpisodes : FetchedResults<TrackedEpisode>

    //TODO: Make these buttons in custom styles
    let backgroundColor : Color = Color(red: 0.858, green: 1, blue: 0.915)
    let textColor : Color = Color(red: 0.067, green: 0.35, blue: 0.259)
    
    var body: some View {
            //ZStack{

                
                VStack(spacing: 50){
                                        
              
                NavigationLink(
                    destination: CheckinReportView().environmentObject(stateManager)
                        .environment(\.managedObjectContext, moc)
                        .navigationBarHidden(true)
                        .navigationBarTitle("", displayMode: .inline),//.hiddenNavigationBarStyle(),
                    isActive: $stateManager.checkinReportIsShown,
                    label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 55).frame(width: 305, height: 180, alignment: .center).foregroundColor(backgroundColor)
                            HStack{
                                //Image(systemName: "calendar").resizable().frame(width: 35, height: 35, alignment: .center).foregroundColor(.purple)
                                Image("check-in")
                                    .resizable()
                                    .frame(width: 125, height: 125, alignment: .center)
                                Text("Check In")
                                    .fontWeight(.bold)
                                    .frame(width: 120, alignment: .center).foregroundColor(textColor)
                            }
                        }
                    })
                
                NavigationLink(
                    destination:
                        EpisodeReportView()
                        .environmentObject(stateManager)
                        .environment(\.managedObjectContext, moc),
                    isActive: $stateManager.episodeReportIsShown,
                    label: {
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 55).frame(width: 305, height: 180, alignment: .center).foregroundColor(backgroundColor).overlay{
                                //let count = trackedEpisodes.count
                                if(!trackedEpisodes.isEmpty){
                                Image(systemName: "exclamationmark")
                                    .resizable()
                                    .frame(width: 10, height: 50).foregroundColor(.red)
                                    .position(x: 250, y: 30)
                                }
                            }
                            HStack{

                                Image("episodeReport") //TODO: Resize Image
                                    .resizable()
                                    .frame(width: 125, height: 125, alignment: .center)
                                
                                Text("Report an Episode")
                                    .fontWeight(.bold)
                                    .frame(width: 120, alignment: .center).foregroundColor(textColor)
                            }
                            
                            
                            
                                //.position(x: 5, y: 5)
                        }
                        
                    })
                
                //    Text("Tracked Episode Count: \(trackedEpisodes.count)")

                }

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(StateManager())
    }
}

