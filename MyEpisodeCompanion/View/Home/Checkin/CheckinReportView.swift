//
//  CheckinReportView.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 4/5/22.
//

import SwiftUI
import ConfettiSwiftUI


//TODO: Sleep question - 1) Pull data from HK, 2) "You have already recorded x amount of hours of sleep today, did you get more rest?"
//TODO: Allow adding more emotions and responses. "Would you like to report any other emotions today? Since your last checkin?
struct CheckinReportView: View {
    @EnvironmentObject var stateManager : StateManager
    @Environment(\.managedObjectContext) var moc

    @FetchRequest(sortDescriptors: [SortDescriptor(\.weight, order: .reverse)]) var stressors : FetchedResults<Stressor>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var checks : FetchedResults<Checkin>
    
    @StateObject var viewModel : CheckinReportViewModel = CheckinReportViewModel()
    
    @State var currentViewSection : CheckinReportViewModel.ViewSection = .emotionQuestion
    
    
    init(){
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        
        NavigationView{
            GeometryReader{ geo in
                
                //Background
                viewModel.getBackgroundImage()

                VStack{
                    //ZStack{
                        //Toolbar shape goes here
                        HStack{
                            Button{
                                
                                if(self.currentViewSection == .emotionQuestion){
                                    stateManager.goHome()
                                }else{
                                    self.currentViewSection = viewModel.previousSection(self.currentViewSection)
                                }
                                
                            } label: {
                                Image(systemName: "arrow.left")
                                    .frame(width: 30)
                            }
                            .frame(width: 90, alignment: .leading)
                            
                            Spacer()
                            
                            //Progress Dots
                            HStack(spacing: 10){
                                ForEach(0..<CheckinReportViewModel.ViewSection.review.rawValue){i in
                                   
                                    Circle().fill(i <= currentViewSection.rawValue ? viewModel.core?.colorSecondary ?? .gray : .gray).frame(width: 10, height: 10, alignment: .center)
                                    
                                }
                            }
                            
                            Spacer()

                            
                            Button(){
                                
                                
                                
                                if(currentViewSection == .stressLevelQuestion){
                                    viewModel.calculateStress(Array(stressors))
                                }
                                
                                //self.isActive.toggle()
                                if(currentViewSection == .review){
                                    viewModel.isShowingSubmitConfirmation = true
                                }else if(viewModel.isValidResponse(currentViewSection)){
                                    currentViewSection = viewModel.nextSection(currentViewSection)
                                }else{
                                    viewModel.setAlert(currentViewSection)
                                }
                            } label : {
                                if(currentViewSection == .congratulations){
                                    //Empty
                                }else if(currentViewSection == .review){
                                    Text("Submit")
                                }else{
                                    Image(systemName: "arrow.right").frame(width: 30).foregroundColor(viewModel.isValidResponse(currentViewSection) ? .blue : .gray)
                                }
                            }.frame(width: 80, alignment: .trailing)
                            
                            
                            
                        }
                        .padding(.horizontal, 8)
                        .frame(width: geo.size.width, height: 50)
                        .font(.system(size: 22))
                       

                    
                    HStack{
                        viewModel.getQuestionText(self.currentViewSection)
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .padding(10)
                    }.frame(width:geo.size.width, height: 90, alignment: .top)
                    
                    Spacer()
                    
                    //Content
                    VStack{
                        switch self.currentViewSection{
                        case .emotionQuestion:
                            EmotionSelectionView(viewModel: viewModel)
                            //DebugQuestionView()
                        case .emotionExplanationQuestion :
                            TextQuestionView(viewModel: viewModel, viewSection: self.currentViewSection)
                        case .headspaceQuestion : TextQuestionView(viewModel: viewModel, viewSection: self.currentViewSection)
                        case .sleepQuestion :
                            SleepQuestionView(viewModel: viewModel)
                        case .needQuestion : TextQuestionView(viewModel: viewModel, viewSection: self.currentViewSection)
                        case .stressLevelQuestion : StressStackView().environment(\.managedObjectContext, moc)
                        case .copeQuestion : CopingSelectionView(viewModel: viewModel)
                        case .review : ReviewView(viewModel: viewModel).environment(\.managedObjectContext, moc)
                        case .congratulations:
                            CongratulationsView()
                        default: Text("How did you get here? \(self.currentViewSection.rawValue)") //Keep for futureproofing
                        }
                    }
                    .frame(width: geo.size.width)
                    
                    Spacer()
                    
                }
                
            }
            .navigationBarHidden(true)
            .alert(viewModel.alertText, isPresented: $viewModel.isShowingAlert){
                Button("OK", role: .cancel){
                    viewModel.alertText = ""
                }
            }
            .alert("Confirm Submission?", isPresented: $viewModel.isShowingSubmitConfirmation){
                Button("Submit"){
                    //If no error returned
                    if nil != viewModel.buildCheckin(context: moc){
                        currentViewSection = .congratulations
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                            stateManager.goHome()
                        }
                    }
                }
            }
            
        }.onAppear{
            
            if let recent = checks.first?.unwrapCheckin(){
                viewModel.checkPrior(recent)
            }
        }
    }
}



fileprivate struct CongratulationsView : View {
    
    @State var confetti = 0
    
    var body: some View {
        
        VStack{
            Text("CONGRATULATIONS").font(.title)
        }.confettiCannon(counter: $confetti, confettiSize: 10, radius: 350, repetitions: 3)
            .onAppear{
                confetti += 2
            }
    }
    
}

/**
 A view used for determining the user's emotion and state
 */
fileprivate struct EmotionSelectionView : View {
    
    /** The view model passed in from the parent view */
    @StateObject var viewModel : CheckinReportViewModel
    
    var body: some View{
        
            VStack{

                Spacer()
                //Content...
                //The grid of core emotion buttons
                LazyVGrid(columns: [GridItem(.fixed(110)), GridItem(.fixed(110)), GridItem(.fixed(110))], alignment: .center, spacing: 15){
                    
                    ForEach(EmotionConstants.Cores.getAll()){core in

                        Button {
                            withAnimation(){
                                viewModel.toggleCore(core)
                            }

                        } label : {
                            Text(core.name).bold()
                        }.buttonStyle(EmotionButtonStyle2(color: core.colorSecondary, isSelected: viewModel.core == core))
                        
                        .buttonStyle(EmotionButtonStyle(
                            color: getEmotionColors(core, isSelected: viewModel.core == core),
                            size: .large))
                        
                    }
                }
                
                //Description of most recently selected core emotion, or state emotion
                VStack{
                    viewModel.getEmotionDescription().fontWeight(.bold).multilineTextAlignment(.center).padding(.horizontal)
                    
                }
                .frame(width: viewModel.core == nil ? 0 : UIScreen.main.bounds.width - 20, height: 130, alignment: .center)
                .cornerRadius(15)
                .padding(.top, 5)
                
                
                //The grid of state emotions
                let gridWidth = (UIScreen.main.bounds.width / 2) - 20
                
                LazyVGrid(columns: [GridItem(.fixed(gridWidth)),GridItem(.fixed(gridWidth))
                                   ]){
                    ForEach(viewModel.getStateOptions()){state in
                        
                        Button{
                            if(viewModel.state == state){
                                viewModel.state = nil
                            }else{
                                viewModel.state = state
                            }
                        } label : {
                            Text(state.name)//.bold()
                        }
                        .buttonStyle(StateEmotionButtonStyle(state: state, isSelected: viewModel.state == state))
                    }
                }.frame(height: 300, alignment: .center)
                
                
            }
    }
}

/**
 A view used for answering various questions with a textbox
 */
fileprivate struct TextQuestionView : View {
    /** The view model passed in from the parent view */
    @StateObject var viewModel : CheckinReportViewModel

    let viewSection : CheckinReportViewModel.ViewSection

    
    var body: some View{
        let gradientColors : [Color] = [viewModel.core?.colorTertiary ?? .gray, viewModel.core?.color ?? .gray]
        ZStack{
            
            TextEditor(text: viewSection == .headspaceQuestion ? $viewModel.whereIsMyHeadspace : viewSection == .needQuestion ? $viewModel.whatDoIFeelINeed : $viewModel.emotionExplination).padding().frame(width: 300, height: 300, alignment: .center)
                .background{
                    Color.white
                }.cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(LinearGradient(colors: gradientColors, startPoint: .bottomLeading, endPoint: .topTrailing), lineWidth: 3))
                

            Button{
                viewModel.toggleRecording(viewSection: viewSection)
            } label: {
                Image(systemName: viewModel.isRecording ? "mic.slash" : "mic").font(.system(size: 40)).foregroundColor(.black)
            }.offset(y: 200) //200 = 1/2 height of texteditor + 50 for padding :)
        }
    }
}

/**
 A view containing a slider for answering various value based questions
 */
fileprivate struct SleepQuestionView : View {
    /** The view model passed in from the parent view */
    @StateObject var viewModel : CheckinReportViewModel
    
    
    var body: some View{
        VStack{
            
            
            Text("Hrs Slept").font(.title3)
            SleepQtySlider(sleepQty: $viewModel.sleepQuantity)
            
            Divider().frame(width: 300, height: 20)
            
            Text("Sleep Quality").font(.title3)
            SleepQualitySlider(sleepQuality: $viewModel.sleepQuality)
            
            VStack{
                if(viewModel.didGetSleepFromPrior){
                    Text("Sleep Data Imported from Prior Checkin")
                }else if(viewModel.didGetSleepFromHK){
                    Text("Sleep Data Imported from Health Kit Data")
                }
            }.frame(width: UIScreen.main.bounds.width - 20, height: 30, alignment: .center)

        }.padding()
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
                }.frame(width: (viewModel.copingMethods.isEmpty && !viewModel.isDidntCope) ? 0 : UIScreen.main.bounds.width - 20, height: 120, alignment: .center)
                    .background(.thinMaterial)
                    .cornerRadius(20)

                ScrollView{
                
                let gridSize = CGFloat(150)
                let gridItems = [GridItem(.fixed(gridSize)), GridItem(.fixed(gridSize))]
                //Grid of different coping methods
                LazyVGrid(columns: gridItems){
                    
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
                        }.buttonStyle(CopingButtonStyle(isSelected: viewModel.copingMethods.contains(method), color: viewModel.core?.color ?? .blue))
                        
                    }
                    
                }.padding(10)
                
                //Button for not having done any coping that day
                Button{
                    viewModel.isDidntCope.toggle()
                    viewModel.copingMethods.removeAll()
                } label : {
                    Text("Nothing")
                }.buttonStyle(CopingButtonStyle(isSelected: viewModel.isDidntCope, color: viewModel.core?.color ?? .blue))

                }.frame(height: 400, alignment: .center)
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
        ScrollView{
            Spacer().frame(height: 10)
        VStack(alignment: .center, spacing: 5){
            
            
            //Emotion
            Spacer()
            Group{
            Text("You are feeling: ")
            +
                Text("\(viewModel.state?.name ?? "No state specified")")
                    .foregroundColor(viewModel.core?.colorSecondary ?? .black)
                    .fontWeight(.bold)
            
            Text(" which is a state of ")
            +
                Text("\(viewModel.core?.name ?? "No Emotion Specified").")                .foregroundColor(viewModel.core?.colorSecondary ?? .black)
                    .fontWeight(.bold)
            }
            
            //Emotion explination
            Group{
                Text("The reason why you feel this way is: ")
                
                Text("\(viewModel.emotionExplination) test stuff")
                    .bold()
                    .foregroundColor(viewModel.core?.colorSecondary ?? .black)
            }
            
            Spacer().frame(height: 10)
            //Numbers
            Group{
                Text("Your stress level: ")
                +
                Text("\(viewModel.stressQuantity)")
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.stressQuantity < 150 ? .green : viewModel.stressQuantity < 300 ? .orange : .red)
                
                Text("You slept ")
                +
                Text("\(viewModel.sleepQuantity, specifier: "%.1f")")
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.sleepQuantity > 7.5 ? .green : viewModel.sleepQuantity < 5 ? .red : .orange)
                +
                Text(" hrs last night")
                
                
                Text("Your sleep quality was ")
                +
                Text("\(viewModel.sleepQuality, specifier: "%.f")/10")
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.sleepQuality > 8 ? .green : viewModel.sleepQuality < 4 ? .red : .yellow)
                
                Spacer().frame(height: 10)
            }

            
            Group{
                
                if(viewModel.isDidntCope){
                    Text("You didn't cope with stress or emotions in any way today")
                }else{
                    Text("You are coping with these things by: ")
                    ForEach(viewModel.copingMethods){cm in
                        Text("\(cm.name) ")
                            .fontWeight(.bold).foregroundColor(viewModel.core?.colorSecondary ?? .black)
                    }
                }
                
                Text("You feel you currently need: ")
                Text(viewModel.whatDoIFeelINeed)
                    .bold()
                    .foregroundColor(viewModel.core?.colorSecondary ?? .black)
                
                
                Text("Your headspace is:")
                Text(viewModel.whereIsMyHeadspace)
                    .bold()
                    .foregroundColor(viewModel.core?.colorSecondary ?? .black)
                
                
                
                
            }
            Spacer()
            
            Button{
                //TODO:
            } label: {
                HStack{
                    Text("Share with care provider").underline()
                    Image(systemName: "square.and.arrow.up")
                }.foregroundColor(.green)
            }.padding(5)
        }
        .multilineTextAlignment(.center)
        }
        .frame(width: 300, height: 450).background(.thinMaterial)
        
    }
}


struct DebugQuestionView : View {
   // @StateObject var viewModel : CheckinReportViewModel
    @State var debugText : String = ""
    @FocusState var isFocused : Bool
    @State var isSel : Bool = false
    var body: some View {
        
       // VStack{
            
            TextEditor(text: $debugText).padding().frame(width: 300, height: 300, alignment: .center).background(.thinMaterial).cornerRadius(20)
         /*
         /   Button{
                //viewModel.toggleRecording(viewSection: viewSection)
                isSel.toggle()
            } label: {
                Image(systemName: isSel ? "mic.slash" : "mic").font(.system(size: 40)).foregroundColor(.black)
            }
          */
    }
        
    
}
/* Keeping for future reference
struct CheckinNavigationView<Content: View, Destination: View> : View {
    
    let destination : Destination
    let isRoot : Bool
    let isLast : Bool
 //   let color : Color
    let viewSection : CheckinReportViewModel.ViewSection
    let content: Content
    
    @State var isActive = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var viewModel : CheckinReportViewModel
    
    init(destination : Destination, isRoot : Bool, isLast: Bool, viewSection : CheckinReportViewModel.ViewSection, @ViewBuilder content: () -> Content){
        self.destination = destination
        self.isRoot = isRoot
        self.isLast = isLast
        self.viewSection = viewSection
      //  self.viewModel = viewModel
      //  self.color = color
        self.content = content()
    }
    
    
    var body: some View{
        NavigationView{
            GeometryReader{ geo in
                //Background
                Image("yellowcircle")
                VStack{
                    ZStack{
                        
                        //Nav bar shape here?
                        HStack{
                            Button(){
                                //Back button, dismiss the view
                                self.mode.wrappedValue.dismiss()
                                
                            } label : {
                                Image(systemName: "arrow.left").frame(width: 30)
                            }
                            
                            
                            Spacer()
                            
                            //Progress Dots
                            HStack(spacing: 10){
                                ForEach(CheckinReportViewModel.ViewSection.allCases.indices){i in
                                    Circle().fill(.blue).frame(width: 10, height: 10, alignment: .center)
                                }
                            }
                            
                            Spacer()

                            
                            Button(){
                                self.isActive.toggle()
                            } label : {
                                if(self.isLast){
                                    Text("Submit")
                                }else{
                                    Image(systemName: "arrow.right").frame(width: 30)
                                }
                            }
                            NavigationLink(
                                destination: destination.navigationBarHidden(true),
                                isActive: self.$isActive,
                                label: {
                                    //No label
                                })
                        }
                        .padding([.horizontal, .top], 8)
                        .frame(width: geo.size.width)
                        .font(.system(size: 22))
                    }
                    .frame(width: geo.size.width, height: 30)
                    //.edgesIgnoringSafeArea(.top)
                    
                    Spacer()
                    
                    
                    self.content
                        //.padding()
                        //.background(.blue)
                        //.cornerRadius(20)
                    Spacer()
                }
            }.navigationBarHidden(true)
        }
    }
    
    

    
}

/**
 Wrapper for a question being asked that includes navigation logic
 */
fileprivate struct QuestionNavigationView : View {
    
    @StateObject var viewModel : CheckinReportViewModel
    //Needed for tracking the view section of the current view for navigation
    let viewSection : CheckinReportViewModel.ViewSection
    
    @Environment(\.managedObjectContext) var moc
    
    
    
    var body: some View {
        
            NavigationView{

                ZStack {
                    //var image : String = ""
//                    if let unwrappedCore = viewModel.core {
//                        image = (unwrappedCore == EmotionConstants.Cores.Joy) ? "yellowcircle" : (unwrappedCore == EmotionConstants.Cores.Anger) ? "redcircle" : (unwrappedCore == EmotionConstants.Cores.Disgust) ? "greencircle" : (unwrappedCore == EmotionConstants.Cores.Sadness) ? "bluecircle" :
//                        (unwrappedCore == EmotionConstants.Cores.Fear) ? "purplecircle" : ""
//
//
//
//                            //.resizable()
//                            //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
//                            //.position(x: UIScreen.main.bounds.width / 2, y: (UIScreen.main.bounds.height / 2) - 50)
//
//
//
//                    }
                    Image(viewModel.core == EmotionConstants.Cores.Joy ? "yellowcircle" : viewModel.core == EmotionConstants.Cores.Anger ? "redcircle" : viewModel.core == EmotionConstants.Cores.Fear ? "purplecircle" : viewModel.core == EmotionConstants.Cores.Sadness ? "bluecircle" : viewModel.core == EmotionConstants.Cores.Disgust ? "greencircle" : "yellowcircle")
                    
                VStack{
                    HStack{
                        ForEach(0..<CheckinReportViewModel.ViewSection.allCases.count - 1){i in
                            Circle().fill(i <= viewSection.rawValue ? viewModel.core?.colorSecondary ?? .gray : .gray).frame(width: 10, height: 10, alignment: .center)
                        }
                    }
                    HStack{
                            viewModel.getQuestionText(viewSection)
                                .font(.title2).fontWeight(.bold).multilineTextAlignment(.center).padding()
                    }.frame(width: UIScreen.main.bounds.width, height: 100, alignment: .top)
                    
                    Spacer().frame(minHeight: 0)
                    
                    GeometryReader{ geo in
                        VStack{
                            
                            switch self.viewSection{
                            case .emotionQuestion:
                                EmotionSelectionView(viewModel: viewModel)
                                //DebugQuestionView()
                            case .emotionExplanationQuestion :
                                TextQuestionView(viewModel: viewModel, viewSection: self.viewSection)
                            case .headspaceQuestion : TextQuestionView(viewModel: viewModel, viewSection: self.viewSection)
                            case .sleepQuestion :
                                SliderView(viewModel: viewModel, question: .sleep)
                            case .needQuestion : TextQuestionView(viewModel: viewModel, viewSection: self.viewSection)
                            case .stressLevelQuestion : StressStackView().environment(\.managedObjectContext, moc)
                            case .copeQuestion : CopingSelectionView(viewModel: viewModel)
                            case .review : ReviewView(viewModel: viewModel).environment(\.managedObjectContext, moc)
                            default: Text("How did you get here? \(viewSection.rawValue)") //Keep for futureproofing
                            }
                            
                        }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    }
                    Spacer().frame(minHeight: 0)
                    

                }
                }
                //.navigationTitle("")
                //.navigationBarHidden(true)
            }
            .toolbar(){
                
                HStack{
                
                    Button(){
                        print("Help")
                    } label : {
                        Image(systemName: "questionmark.circle").foregroundColor(.gray)
                    }.padding(.trailing)//.offset(x: 10 - (UIScreen.main.bounds.width / 2), y: 0)
                    

                    
                if (viewSection == .review){
                    
                    Button("Submit"){
                        viewModel.isShowingSubmitConfirmation = true
                    }
                } else if(viewModel.isValidResponse(viewSection)){
                    
                    NavigationLink(
                        destination: QuestionNavigationView(
                            viewModel: viewModel,
                            viewSection: viewModel.nextSection(viewSection)),
                        label: {
                            Text("Next")
                        })
                } else {
                    Text("Next")
                        .foregroundColor(.gray)
                        .onTapGesture{
                            viewModel.setAlert(viewSection)
                        }
                }
                }
            }
            
            
        
    }
}
 */

struct CheckinReportView_Previews: PreviewProvider {
    static var previews: some View {
        CheckinReportView()

       // TextQuestionView(viewModel: CheckinReportViewModel(), textQuestion: .headspace)
    }
}
