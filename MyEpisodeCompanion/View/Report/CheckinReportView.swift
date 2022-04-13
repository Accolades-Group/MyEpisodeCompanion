//
//  CheckinReportView.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 4/5/22.
//

import SwiftUI


struct CheckinReportView: View {
    @EnvironmentObject var stateManager : StateManager
    @Environment(\.managedObjectContext) var moc
    
    @StateObject var viewModel : CheckinReportViewModel = CheckinReportViewModel()
    
    init(){
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        
        
            QuestionNavigationView(viewModel: viewModel, viewSection: .emotionQuestion)
            .alert(viewModel.alertText, isPresented: $viewModel.isShowingAlert){
            Button("OK", role: .cancel){
                viewModel.alertText = ""
            }
        }//Alert for confirming submission of data
        .alert("Confirm Submission?", isPresented: $viewModel.isShowingSubmitConfirmation){
            HStack{
                Button("Submit"){
                    //TODO: Throw error?
                    viewModel.buildCheckin(context: moc)
                    stateManager.goHome()
                }
                Button("Cancel", role: .cancel){
                    //?
                }
            }
        }
        
        
        
//
//        EmotionSelectionView(viewModel: viewModel)
//            .environmentObject(viewModel)
//            .alert(viewModel.alertText, isPresented: $viewModel.isShowingAlert){
//                Button("OK", role: .cancel){
//                    viewModel.alertText = ""
//                }
//            }//Alert for confirming submission of data
//            .alert("Confirm Submission?", isPresented: $viewModel.isShowingSubmitConfirmation){
//                HStack{
//                    Button("Submit"){
//                        //TODO: Throw error?
//                        viewModel.buildCheckin(context: moc)
//                        stateManager.goHome()
//                    }
//                    Button("Cancel", role: .cancel){
//                        //?
//                    }
//                }
//            }
            
        
//        NavigationView{
//            getCurrentView()
//                .environmentObject(viewModel)
//        }
//        .navigationTitle("")//TODO:?
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarBackButtonHidden(true)
//        .toolbar(){
//            Button{
//                viewModel.nextQuestion()
//            } label : {
//                Text("Next")
//            }
//        }
//
        /*
        VStack{
            //Question Text
            HStack{
                viewModel.questionText.font(.title2).fontWeight(.bold).multilineTextAlignment(.center)
            }.padding()
            
            //Main Question Body switch statement
            GeometryReader{geo in
                
                getCurrentView()
                    .environmentObject(viewModel)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
            }
        
        
        //Bottom Buttons
        HStack{
            //Previous button, disabled on first question
            if(viewModel.sectionIndex > 0){
                Button("Previous"){
                    viewModel.previousQuestion()
                }.buttonStyle(NextButtonStyle())
            }
            
            Button(viewModel.sectionIndex == 7 ? "Submit" : "Next"){
                viewModel.nextQuestion()
            }.buttonStyle(NextButtonStyle())
        }
            
        }//Alerts for  notifying of improper data
        .alert(viewModel.alertText, isPresented: $viewModel.isShowingAlert){
            Button("OK", role: .cancel){
                viewModel.alertText = ""
            }
        }//Alert for confirming submission of data
        .alert("Confirm Submission?", isPresented: $viewModel.isShowingSubmitConfirmation){
            HStack{
                Button("Submit"){
                    //TODO: Throw error?
                    viewModel.buildCheckin(context: moc)
                    stateManager.goHome()
                }
                Button("Cancel", role: .cancel){
                    //?
                }
            }
        }
        */
    }
}



/**
 A view used for determining the user's emotion and state
 */
fileprivate struct EmotionSelectionView : View {
    
    /** The view model passed in from the parent view */
    //@EnvironmentObject var viewModel : CheckinReportViewModel
    @StateObject var viewModel : CheckinReportViewModel

    
    var body: some View{

            //Content
            VStack{
                
                //Content...
                //The grid of core emotion buttons
                LazyVGrid(columns: [GridItem(.fixed(120)), GridItem(.fixed(120)), GridItem(.fixed(120))], alignment: .center, spacing: 30){
                    
                    ForEach(EmotionConstants.Cores.getAll()){core in
                        
                        Button {
                            //Cleaner method
                            //viewModel.core = viewModel.core == core ?  nil : core
                            
                            //Better readability
                            if viewModel.core == core {
                                viewModel.core = nil
                            } else {
                                viewModel.core = core
                            }
                            //Always reset state when changing core
                            viewModel.state = nil
                            
                        } label : {
                            Text(core.name)
                        }.buttonStyle(EmotionButtonStyle(
                            color: getEmotionColors(core, isSelected: viewModel.core == core),
                            size: .large))
                    }
                }
                
                //Description of most recently selected core emotion, or state emotion
                VStack{
                    viewModel.getEmotionDescription().multilineTextAlignment(.center).padding(.horizontal, 50)
                    
                }.frame(height: 150, alignment: .center).padding(.horizontal)
                
                //The grid of state emotions
                
                LazyVGrid(columns: [GridItem(.fixed(200)),GridItem(.fixed(200))
                                   ]){
                    ForEach(viewModel.getStateOptions()){state in
                        Button{
                            
                            if(viewModel.state == state){
                                viewModel.state = nil
                            }else{
                                viewModel.state = state
                            }
                            
                        } label : {
                            Text(state.name)
                        }.buttonStyle(EmotionButtonStyle(
                            color: getEmotionColors(state.core, isSelected: viewModel.state == state),
                            size: .medium))
                    }
                }.padding().frame(height: 300, alignment: .center)
            }
        
    }
}

/**
 A view used for answering various questions with a textbox
 */
fileprivate struct TextQuestionView : View {
    /** The view model passed in from the parent view */
    //@EnvironmentObject var viewModel : CheckinReportViewModel
    @StateObject var viewModel : CheckinReportViewModel

    let textQuestion : TextQuestions
    
    /** An enum for the types of questions this view can use */
    enum TextQuestions : String {
        case headspace, needs, emotionExplination
    }
    
    
    var body: some View{
        ZStack{
            
            Image("chatleft").resizable().frame(width: 294, height: 176).offset(x: -50 ,y: -250)
            
            
            Image("chatright").resizable().frame(width: 280, height: 171).offset(x: 50, y: 200)
            
            TextEditor(text: textQuestion == .headspace ? $viewModel.whereIsMyHeadspace : textQuestion == .needs ? $viewModel.whatDoIFeelINeed : $viewModel.emotionExplination).padding().frame(width: 300, height: 300, alignment: .center).background(.thinMaterial).cornerRadius(20)
        }
    }
}

/**
 A view containing a slider for answering various value based questions
 */
fileprivate struct SliderView : View {
    /** The view model passed in from the parent view */
    @StateObject var viewModel : CheckinReportViewModel
    
    /** The question type for the current view */
    let question : SliderQuestions
    
    /** An enum for the types of questions this view can use */
    enum SliderQuestions : String {
        case sleep, stress
    }
    
    var body: some View{
        VStack{
            
            if(question == .sleep){
                Text("Hrs Slept").font(.title3)
            }
            
            HStack{
                Text("0")
                if(question == .sleep){
                    Slider(value: $viewModel.sleepQuantity, in: 0...16)
                    Text("16")
                }else if question == .stress{
                    Slider(value: $viewModel.stressQuantity, in: 0...100)
                    Text("100")
                }
            }
            Text(question == .sleep ? "\(viewModel.sleepQuantity, specifier: "%.1f")" : "\(viewModel.stressQuantity, specifier: "%.f")")
            
            
            //Sleep quality slider for sleep question
            if(question == .sleep){
                
                Spacer().frame(height: 40)
                
                Text("Sleep Quality").font(.title3)
                HStack{
                    Text("0")
                    Slider(value: $viewModel.sleepQuality, in: 0...10)
                    Text("10")
                }
                Text("\(viewModel.sleepQuality, specifier: "%.f")/10")
            }
        }.padding()
            .onAppear(){
                viewModel.sectionIndex = question == .sleep ? .sleepQuestion : .stressLevelQuestion
            }
    }
}

/**
 A view for determing the ways a user coped with emotions or stress
 */
fileprivate struct CopingSelectionView: View {
    /** The view model passed in from the parent view */
    @StateObject var viewModel : CheckinReportViewModel
    
    var body: some View{

            VStack{
                
                //Description for selected coping method
                HStack{
                    Text(viewModel.copingMethods.last?.description ?? "").multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                    if(viewModel.isDidntCope){
                        Text("You haven't done any coping today. That can be a good thing! Try doing some positive reflection or meditation to improve today's outcome.")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)
                    }
                }
                .frame(height: 130, alignment: .center)
                .padding(.bottom, 10)
                
                
                //Grid of different coping methods
                LazyVGrid(columns: [GridItem(.fixed(120)),GridItem(.fixed(120)), GridItem(.fixed(120))]){
                    
                    ForEach(EmotionConstants.CopingMethods.getAllMethods()){method in
                        Button{
                            if viewModel.copingMethods.contains(method){
                                viewModel.copingMethods.removeAll(where: {$0 == method})
                            }else{
                                viewModel.copingMethods.append(method)
                            }
                            //Set to false every time a coping method is selected
                            viewModel.isDidntCope = false
                        } label: {
                            Text(method.name)
                                .multilineTextAlignment(.center)
                        }.buttonStyle(EmotionButtonStyle(
                            color: viewModel.copingMethods.contains(method) ? .blue : .gray,
                            size: .small))
                    }
                    
                }
                
                //Button for not having done any coping that day
                Button{
                    viewModel.isDidntCope.toggle()
                    viewModel.copingMethods.removeAll()
                } label : {
                    Text("Nothing")
                }.buttonStyle(EmotionButtonStyle(
                    color: viewModel.isDidntCope ? .blue : .gray,
                    size: .medium))
            }

    }
}

/**
 A view for reviewing details from the 
 */
fileprivate struct ReviewView : View {
    /** The view model passed in from the parent view */
    //@EnvironmentObject var viewModel : CheckinReportViewModel
    @StateObject var viewModel : CheckinReportViewModel
    
    var body: some View{
        VStack{
            
            
            //Emotion
            Group{
            Text("You are feeling: ")
            +
            Text("\(viewModel.state?.name ?? "No state specified")")
                .foregroundColor(getEmotionColors(viewModel.core ?? EmotionConstants.Cores.Other))
                .fontWeight(.bold)
            +
            Text(" which is a state of ")
            +
            Text("\(viewModel.core?.name ?? "No Emotion Specified").")                .foregroundColor(getEmotionColors(viewModel.core ?? EmotionConstants.Cores.Other))
                .fontWeight(.bold)
            }.padding(.vertical)
            
            //Emotion explination
            Group{
                Text("The reason you gave for feeling this way is: ")
                +
                Text("\(viewModel.emotionExplination)").italic()
            }.padding(.vertical)
            
            Divider()
            
            //Numbers
            Group{
                Text("Your stress level is at ")
                +
                Text("\(viewModel.stressQuantity, specifier: "%.f")/100")
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.stressQuantity < 50 ? .green : viewModel.stressQuantity < 75 ? .orange : .red)
                    
                Spacer().frame(height: 10)
                
                Text("You slept ")
                +
                Text("\(viewModel.sleepQuantity, specifier: "%.1f")")
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.sleepQuantity > 7.5 ? .green : viewModel.sleepQuantity < 5 ? .red : .orange)
                +
                Text(" hrs last night")
                
                Spacer().frame(height: 10)
                
                Text("Your sleep quality was ")
                +
                Text("\(viewModel.sleepQuality, specifier: "%.f")/10")
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.sleepQuality > 8 ? .green : viewModel.sleepQuality > 5 ? .orange : .red)
                
                Spacer().frame(height: 10)
            }
            
            Divider()
            
            Group{
                
                if(viewModel.isDidntCope){
                    Text("You didn't cope with stress or emotions in any way today")
                }else{
                    Text("You are coping with these things by: ")
                    ForEach(viewModel.copingMethods){cm in
                        Text("\(cm.name) ")
                            .fontWeight(.bold)
                    }
                }
                
                Spacer().frame(height: 10)
                
                
                Text("You feel you currently need: \(viewModel.whatDoIFeelINeed)")
                
                Spacer().frame(height: 10)
                
                Text("Your headspace was filled with thoughts of: \(viewModel.whereIsMyHeadspace)")
                
                
            }
        }.padding().multilineTextAlignment(.center)
    }
}


struct DebugQuestionView : View {
   // @StateObject var viewModel : CheckinReportViewModel
    @State var debugText : String = ""
    @FocusState var isFocused : Bool
    var body: some View {
        

        
        TextEditor(text: $debugText).padding().frame(width: 300, height: 300, alignment: .center).background(.thinMaterial).cornerRadius(20)

        }
        
    
}

fileprivate struct QuestionNavigationView : View {
     
    @StateObject var viewModel : CheckinReportViewModel
    //Needed for tracking the view section of the current view for navigation
    let viewSection : CheckinReportViewModel.ViewSection
    
    var body: some View {
        
    //    GeometryReader{ geo in
        
        NavigationView{
            //Body content
            ZStack {
                
                //Background
                Image(
                    viewSection == .sleepQuestion ? "sleepBackground" :
                        viewSection == .headspaceQuestion ? "" :
                        viewSection == .emotionExplanationQuestion ? "" :
                        viewSection == .needQuestion ? "feelMissingBackground":
                        viewSection == .headspaceQuestion ? "headspaceBackground"
                    : "lineBackground")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                
                

                
                
                switch self.viewSection{
                case .emotionQuestion :
                    EmotionSelectionView(viewModel: viewModel)
                case .emotionExplanationQuestion :
                    TextQuestionView(viewModel: viewModel, textQuestion: .emotionExplination)
                case .headspaceQuestion : TextQuestionView(viewModel: viewModel, textQuestion: .headspace)
                case .sleepQuestion :
                    SliderView(viewModel: viewModel, question: .sleep)
                case .needQuestion : TextQuestionView(viewModel: viewModel, textQuestion: .needs)
                case .stressLevelQuestion : SliderView(viewModel: viewModel, question: .stress)
                case .copeQuestion : CopingSelectionView(viewModel: viewModel)
                case .review : ReviewView(viewModel: viewModel)
                default: Text("How did you get here? \(viewSection.rawValue)") //Keep for futureproofing
                }
                
                
                //Question on top layer
                
                HStack{
                    viewModel.questionText
                        .font(.title2).fontWeight(.bold).multilineTextAlignment(.center).padding()
                }.frame(width: UIScreen.main.bounds.width, height: 100, alignment: .center)
                    .offset(x: 0, y: 50 - UIScreen.main.bounds.height/2 )
                 
            }.ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationTitle("")//TODO:?
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(){

            let debug : Bool = false

            if (viewSection == .review){
                Button("Submit"){
                    viewModel.isShowingSubmitConfirmation = true
                }
            } else if(viewModel.isValidResponse() || debug){

                    NavigationLink(
                        destination: QuestionNavigationView(
                            viewModel: viewModel,
                            viewSection: viewModel.nextSection(viewSection)),
                        label: {Text("Next")}
                    )
                } else {
                    Text("Next")
                        .foregroundColor(.gray)
                        .onTapGesture{
                            viewModel.setAlert()
                    }
                }
            }
            .onAppear(){
                viewModel.sectionIndex = viewSection
            }
    }
}


struct CheckinReportView_Previews: PreviewProvider {
    static var previews: some View {
        CheckinReportView()
       // TextQuestionView(viewModel: CheckinReportViewModel(), textQuestion: .headspace)
    }
}
