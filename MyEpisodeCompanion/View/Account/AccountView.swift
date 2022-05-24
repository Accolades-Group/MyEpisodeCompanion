//
//  AccountView.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 4/25/22.
//

import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var stateManager : StateManager
    @Environment(\.managedObjectContext) var moc
    
    @State var notificationToggle: Bool = myUserSettings.isCheckinReminderApproved
    @State var notificationTime: Date = myUserSettings.checkinReminderTime
    @State var hasWatch : Bool = myUserSettings.hasWatch
    
    @FetchRequest(sortDescriptors: []) var checkinHistory : FetchedResults<Checkin>
    
    @FetchRequest(sortDescriptors: []) var episodeHistory : FetchedResults<Episode>
    
    var body: some View {
        
        GeometryReader { g in
            VStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .background(Color.yellow)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .padding(.bottom, 10)
                Text("\(myUserSettings.firstName) \(myUserSettings.lastName)")
                    .font(.system(size: 20))
                    
                Form {
                    
                    Section(header: Text("Personal Information")) {
                        
                        Text("user@email.com")
                        
                       NavigationLink(destination: DiagnosisInfo()) {
                            Text("Diagnosis Information")
                        }
                       
                        NavigationLink(destination: VStack{
                            Text("therapist@email.com")
                            Text("doctor@email.com")
                        }, label: {Text("Care Providers")})
                    }
                    
                    Section(header: Text("Apple Watch")) {
                        Toggle(isOn: self.$hasWatch){
                            Text("Pair Watch")
                        }
                    }
                    
                    Section(footer: Text("Allow push notifications to get reminders for mental health checkins")) {
//                        Toggle(isOn: self.$locationUsage) {
//                              Text("Location Usage")
//                        }
                        Toggle(isOn: self.$notificationToggle) {
                            Text("Checkin Reminders")
                        }.onChange(of: self.notificationToggle) { newValue in
                            myUserSettings.isCheckinReminderApproved = newValue
                        }
                        if(self.notificationToggle){
                            
                            DatePicker("Reminder Time", selection: $notificationTime, displayedComponents: .hourAndMinute ).onChange(of: self.notificationTime) { newValue in
                                myUserSettings.checkinReminderTime = newValue
                            }
                        }
                    }
                    
                    Section(header: Text("Debug")){
                        Toggle("Debug Data", isOn: $stateManager.isDebugData)
                        if(stateManager.isDebugData){
                            HStack{
                                Text("Check ins: \(checkinHistory.count)")
                                Text("Episodes: \(episodeHistory.count)")
                            }
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
                                Spacer()
                                Button("Add Check"){
                                    let check = Checkin(context: moc)
                                    
                                    check.buildFeelings(core: EmotionConstants.Cores.Joy, state: EmotionConstants.States.Fiero, response: "I am feeling Fiero")
                                    check.buildVals(sleepQty: 7.5, sleepQual: 8, headspace: "My thoughts are all about my fun weekend plans", needQuestion: "I need someone to enjoy this feelng with", stresslvl: 136)
                                    
                                    check.buildCopingString(copingMethods: [EmotionConstants.CopingMethods.caffeine, EmotionConstants.CopingMethods.meditation])
                                    
                                    
                                    try? moc.save()
                                }
                            }
                            
                            HStack{
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
                                }
                                Spacer()
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
                                }
                            }
                        }
                    }
                        
            }.background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
            .navigationBarTitle("Account Info")
            .navigationBarTitleDisplayMode(.inline)
         }
        }

        
    }
}

struct DiagnosisInfo : View {
    
    var body: some View{
        
        VStack{
            Text("HARD CODED INFO").font(.title).foregroundColor(.red)
            
            Form{
                Section(header: Text("Diagnosis 1")){
                    Text("NAME: ").fontWeight(.bold)
                    +
                    Text("ADHD")
                    
                    Text("MEDICATION: ").fontWeight(.bold)
                    +
                    Text("Adderal - 40mg AM/PM")
                }
                
                Section(header: Text("Diagnosis 2")){
                    Text("NAME: ").fontWeight(.bold)
                    +
                    Text("Depression")
                    
                    Text("MEDICATION: ").fontWeight(.bold)
                    +
                    Text("Zoloft - 20mg PM")
                }
                
                Section(header: Text("Diagnosis 3")){
                    Text("NAME: ").fontWeight(.bold)
                    +
                    Text("General Anxiety Disorter")
                    
                    Text("MEDICATION: ").fontWeight(.bold)
                    +
                    Text("Alprazolam - 40mg PM")
                }
                
            }
        }
        
    }
    
}



struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        //AccountView().environmentObject(StateManager())
        DiagnosisInfo()
    }
}
