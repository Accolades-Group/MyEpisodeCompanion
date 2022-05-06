//
//  EpisodeReportView.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 4/14/22.
//

import SwiftUI

struct EpisodeReportView: View {
    
    @EnvironmentObject var stateManager : StateManager
    @Environment(\.managedObjectContext) var moc

    @StateObject var viewModel : EpisodeReportViewModel = EpisodeReportViewModel()

    init(){
        UITextView.appearance().backgroundColor = .clear
    }

    
    var body: some View {
        QuestionNavigationView(viewModel: viewModel, viewSection: .coreQuestion)
        //Alert for invalid response
            .alert(viewModel.alertText, isPresented: $viewModel.isShowingAlert){
                Button("OK", role: .cancel){
                    viewModel.alertText = ""
                }
            }//Alert for confirming submission of data
            .alert("Confirm Submission?", isPresented: $viewModel.isShowingSubmitConfirmation){
                HStack{
                    Button("Submit"){
                        //TODO: Throw error?
                        viewModel.buildEpisode(context: moc)
                        stateManager.goHome()
                    }
                    Button("Cancel", role: .cancel){
                        //?
                    }
                }
            }
    }
}

/**
 View for asking a user to select a core emotion
 */
fileprivate struct CoreQuestionView : View {
    @StateObject var viewModel : EpisodeReportViewModel
    
    var body: some View{
        VStack{
            //Core buttons
            HStack{
                ForEach(EmotionConstants.Cores.getEpisodeCores()){core in
                    
                    Button{
                        viewModel.coreButtonPress(core)
                    } label: {
                        Text(core.name)
                    }.buttonStyle(EmotionButtonStyle(color: getEmotionColors(core, isSelected: viewModel.coreEmotion == core), size: .large))
                    
                }
            }
            
            //Core Description
            HStack{
            if let unwrappedCore = viewModel.coreEmotion {
                
                Text(unwrappedCore.description).bold().font(.title3).foregroundColor(getEmotionColors(unwrappedCore)).multilineTextAlignment(.center).padding()
                
            }
            }.frame(height: 300, alignment: .center)
        }
    }
}


fileprivate struct ResponseActionQuestionView: View {
    @StateObject var viewModel : EpisodeReportViewModel
    
    @State var showAllOptions : Bool = false
    var body: some View {
        VStack{
            Spacer()
            if let unwrappedCore = viewModel.coreEmotion {

                HStack{
                    Text(viewModel.emotionResponses.last?.description ?? "").foregroundColor(getEmotionColors(unwrappedCore)).font(.title3).fontWeight(.medium).multilineTextAlignment(.center).padding(.horizontal, 10)
                }.frame(height: 120)
            
            
            let gridItem : GridItem = GridItem(.flexible(minimum: 175, maximum: 200))
                
                LazyVGrid(columns: [gridItem, gridItem]){
                    ForEach(EmotionConstants.Responses.getAllResponsesByCore(unwrappedCore)){response in
                        
                        Button{
                            
                            viewModel.responseButtonPress(response)
                            
                        } label: {
                            Text(response.name)
                        }.buttonStyle(EmotionButtonStyle(color: getEmotionColors(unwrappedCore, isSelected: viewModel.emotionResponses.contains(response)), size: .medium))
                        
                    }
                }
            }
            Spacer()
        }
    }
}

fileprivate struct StateSelectionView : View {
    @StateObject var viewModel : EpisodeReportViewModel
    
    @State var isViewAll : Bool = false
    @State var hasSuggestions : Bool = false
    
    @State var options : [EmotionState] = []
    
    var body: some View{
        VStack{
        let gridItem : GridItem = GridItem(.flexible(minimum: 10, maximum: 200))
        

            HStack{
                if let unwrappedState = viewModel.stateEmotion {
                    Text(unwrappedState.description).font(.title3).fontWeight(.bold).foregroundColor(getEmotionColors(unwrappedState.core)).padding(.horizontal).multilineTextAlignment(.center)
                }
            }.frame(height: 100, alignment: .center)
            
            LazyVGrid(columns: [gridItem, gridItem]){
                ForEach(options){state in
                    
                    Button{
                        viewModel.stateButtonPress(state)
                    } label: {
                        Text(state.name).fontWeight(.bold)
                    }.buttonStyle(EmotionButtonStyle(color: getEmotionColors(state.core, isSelected: viewModel.stateEmotion == state), size: .medium))
                    
                }
            }.frame(height: 300, alignment: .center)
            
            if(hasSuggestions){
                HStack{
                    
                    Button{
                        withAnimation(){
                            
                            isViewAll.toggle()
                            
                            if let unwrappedCore = viewModel.coreEmotion, isViewAll{
                                
                                options = EmotionConstants.getStatesByCore(unwrappedCore)
                                
                            } else {
                                options = EmotionConstants.getStatesByResponses(viewModel.emotionResponses)
                            }
                        }
                    } label: {
                        
                        Text(isViewAll ? "Show Suggestions" : "Show All").foregroundColor(.white).fontWeight(.bold).padding(10)
                        
                    }.frame(height: 35, alignment: .center).background(.blue).cornerRadius(15)
                    
                    
                }
            }
            
        }
        .onAppear{
            
            if let unwrappedCore = viewModel.coreEmotion {
                
                options = EmotionConstants.getStatesByResponses(viewModel.emotionResponses)
                
                hasSuggestions = !options.isEmpty &&
                options.count != EmotionConstants.getStatesByCore(unwrappedCore).count
                
                if !hasSuggestions, let unwrappedCore = viewModel.coreEmotion{
                    options = EmotionConstants.getStatesByCore(unwrappedCore)
                }
            }
            
        }
    }
}

fileprivate struct TriggerSelectionView : View {
    @StateObject var viewModel : EpisodeReportViewModel
    
    //Subject -> (Type : Name ) + Event -> (Type : Name) + Perception -> (Type : Name)
    var sampletrigger = "Person:Jake+Noise:Loud Bang+TYPE?:Gunshot"

    
    @State var trigger : String = ""
    @State var subject : SubjectType = .none
    @State var subjectName : String = ""
    @State var triggerEvent : EventType = .noEvent
    @State var eventName : String = ""
    
    
    enum SubjectType : String {
        case person, place, thing, none
        
        var eventOptions : [EventType] {
            switch self{
            
            case .person:
                return [
                    .disagreement,
                    .criticism,
                    .yelling,
                    .violence,
                    .abuse,
                    .crossedBoundary,
                    .beingIgnored,
                    .beingMisunderstood,
                    .abandonment,
                    .lie,
                    .accusation,
                    .gasLighting,
                    .passiveAggression,
                    .manipulation,
                    .likeAbuser
                ]
            case .place:
                return [
                    .hospitals
                ]
            case .thing:
                return [
                    .enclosedSpace,
                    .lights,
                    .illness,
                    .doctors,
                    .bloodGore,
                    .holidays,
                    .religion,
                    .money,
                    .anObject
                ]
            case .none:
                return []
            }
        }
    }
    enum EventType : String {
        case
        noEvent,
        //person
        disagreement,
        criticism,
        yelling,
        violence,
        abuse,
        crossedBoundary = "Crossed Boundary",
        beingIgnored = "Being Ignored",
        beingMisunderstood = "Being Misunderstood",
        abandonment,
        lie,
        accusation,
        gasLighting,
        passiveAggression = "Passive Aggression",
        manipulation,
        likeAbuser = "Like Abuser",//Abuse?
        
        //place
        hospitals,
        
        //thing
        enclosedSpace = "Enclosed Space",
        lights,
        illness,
        doctors, //Person?
        bloodGore = "Blood/Gore",
        holidays,
        religion,
        money,
        anObject = "An Object"
        
        
        //categories: Reframing?
        /*
         
         Failure:
         
         Rejection:
         
         Threat:
         
            a) Want:
         
         
            b) Danger:
         
         
         */
        
        //todo?
        /*
         Discrimination
         coercion
         possessiveness
         crossed boundary
         authority
         invalidation
         lonliness
         
         rejection ( rejected how? ->
            - Being told no,
            - being criticized,
            - Being left out,
         
         
         failure
            - tests/grades,
            - being late,
            - trying hard and it doesn't work out
         
         connection
            - being touched
            - sex
         
         beingDependedOn
         expressingNeeds needing help?
         inconsistency
         suddenMovements
         noise
         responsibility
         pressure
         mistakes
         crowd
         family,
         positivity
         therapy
        
         + Beth's list
         waiting
         hunger
         cheating
         too much to do
         rumors gossip
         
         hurt or pain
         being scared
         bad news
         
         unfair treatment
         being tired
         //
         disrespect
         being bumped into
         losing
         an accident?
         an interruption
         ridicule
         oppression
         being bullied
         things not going as planned
         things not fair
         not understanding what to do
         being told what to do
         being taken for granted
         someone yelling your name
         teasing
         being blamed for someone else's mistake
         unexpected situations
         being dismissed
         
         */
        
    }
    
    var body: some View {

        VStack{
            
            //Subject Type
            HStack{
                

                
                Button("Person"){
                    self.subject = .person
                }.buttonStyle(EmotionButtonStyle(color: getEmotionColors(viewModel.coreEmotion ?? EmotionConstants.Cores.Other, isSelected: self.subject == .person)))
                
                Button("Place"){
                    subject = .place
                }.buttonStyle(EmotionButtonStyle(color: getEmotionColors(viewModel.coreEmotion ?? EmotionConstants.Cores.Other, isSelected: subject == .place)))
                
                Button("Thing"){
                    subject = .thing
                }.buttonStyle(EmotionButtonStyle(color: getEmotionColors(viewModel.coreEmotion ?? EmotionConstants.Cores.Other, isSelected: subject == .thing)))
                
            }.padding(.top, 50)
            
            //Subject Name
            VStack{
                if subject != .none {
                    
                    Text("\(subject.rawValue.capitalized) Name")
                    TextField("Placeholder Text", text: $subjectName).padding().frame(width: 300, height: 50).background(.thinMaterial).cornerRadius(5)
                    
                }
            }.frame(height: 150, alignment: .center)
            
            
            //Event Type
            VStack{
                
                let gridItems = [GridItem(), GridItem()]
                
                LazyVGrid(columns: gridItems){
                    
                    ForEach(subject.eventOptions, id: \.self){event in
                        
                        Button(event.rawValue){
                            
                            triggerEvent = event
                            eventName = ""
                            
                        }.buttonStyle(EmotionButtonStyle(color: getEmotionColors(
                            viewModel.coreEmotion ??
                            EmotionConstants.Cores.Other, isSelected: triggerEvent == event)))
                        
                    }
                }
            }.frame(height: 300, alignment: .center)
            
            //Event Name
            VStack{
                if triggerEvent != .noEvent {
                    
                    
                    Text("\(triggerEvent.rawValue.capitalized) Name")
                    TextField("Placeholder Text", text: $eventName).padding().frame(width: 300, height: 50).background(.thinMaterial).cornerRadius(5)
                    
                }
            }.frame(height: 150, alignment: .center)
            
        }
        
    }
}

/**
 Wrapper for a question being asked that includes navigation logic
 */
fileprivate struct QuestionNavigationView : View {
     
    @StateObject var viewModel : EpisodeReportViewModel
    //Needed for tracking the view section of the current view for navigation
    let viewSection : EpisodeReportViewModel.ViewSection
    
    
    var body: some View {
        
        
        NavigationView{
            //Body content
            ZStack {
                //Backround bottom layer
                Image(viewSection.backgroundImage)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                
                
                //Question content middle layer
                switch viewSection {
                case .coreQuestion:
                    CoreQuestionView(viewModel: viewModel)
                case .responseQuestion:
                    ResponseActionQuestionView(viewModel: viewModel)
                case .stateQuestion :
                    StateSelectionView(viewModel: viewModel)
                case .triggerQuestion:
                    TriggerSelectionView(viewModel: viewModel)
                default: Text("How did you get here? Section: \(viewSection.rawValue)")
                }
                
                
                //Question on top layer
                HStack{
                    viewModel.getQuestionText(viewSection)
                        .font(.title2).fontWeight(.bold).multilineTextAlignment(.center).padding()
                }.frame(width: UIScreen.main.bounds.width, height: 100, alignment: .center)
                    .offset(x: 0, y: 50 - UIScreen.main.bounds.height/2 )
                 
            }
        }
        .navigationTitle("")//TODO:?
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(){
            
            if viewSection == .review {
                Button("Submit"){
                    viewModel.isShowingSubmitConfirmation = true
                }
            } else if viewModel.isValidResponse(viewSection){
                
                NavigationLink(
                    destination: QuestionNavigationView(viewModel: viewModel, viewSection: viewSection.next),
                    label: {Text("Next")}
                )
            } else {
                
                Button{
                    viewModel.setAlert(viewSection)
                } label: {
                    Text("Next").foregroundColor(.gray)
                }
            }
        }
    }
}





struct EpisodeReportView_Previews: PreviewProvider {
    static var previews: some View {
        //EpisodeReportView()
        QuestionNavigationView(viewModel: EpisodeReportViewModel(), viewSection: .triggerQuestion)
    }
}
