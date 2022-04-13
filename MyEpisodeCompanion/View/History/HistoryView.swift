//
//  HistoryView.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/31/22.
//
// Hero Animation: https://www.youtube.com/watch?v=AjiLR9ORhzM&t=311s


//TODO: Remove space above calendar, before <back button
//TODO: sometimes fullscreen detail view gets "stuck" when minimizing
import SwiftUI

struct HistoryView: View {
    
    //var checkIns : [Checkin]
    //var episodes : [Episode]
    
    var date : Date
    
    @StateObject var viewModel : HistoryViewModel
    @State var currentItem : UnwrappedCheckin?
    @State var showDetailPage: Bool = false
    
    // Matched Geometry Effect
    @Namespace var animation
    
    // MARK: Detail Animation Properties
    @State var animateView: Bool = false
    @State var animateContent: Bool = false
    @State var scrollOffset: CGFloat = 0
    
    var body: some View {
        VStack{
            DateView(date: date)
            ScrollView(.vertical, showsIndicators: false){
                
                HStack{
                    
                    if(!viewModel.episodeHistory.isEmpty){
                        EpisodeStatisticsView(viewModel: viewModel)
                    }
                    
                    if(!viewModel.checkinHistory.isEmpty){
                        CheckinStatisticsView(viewModel: viewModel)
                    }
                    
                }.padding(.top, 10)
                
                VStack(spacing: 30){
                    HStack(alignment: .bottom){
                        VStack(alignment: .leading, spacing: 8){
                            ForEach(viewModel.checkinHistory){check in
                                
                                Button{
                                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)){
                                        currentItem = check
                                        showDetailPage = true
                                    }
                                } label: {
                                    
                                    CheckinCardView(checkin: check)
                                        .scaleEffect(currentItem?.id == check.id && showDetailPage ? 1 : 0.93)
                                    
                                }.buttonStyle(ScaledButtonStyle())
                                    .opacity(showDetailPage ? (currentItem?.id == check.id ? 1 : 0) : 1)//hide other items if not selected
                                
                            }
                        }
                    }
                }
            }
            .overlay{
                if let currentItem = currentItem,showDetailPage {
                    DetailView(checkin: currentItem)
                        .ignoresSafeArea(.container, edges: .top)
                }
            }
            .background(alignment: .top){
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(getEmotionColors(currentItem?.core ?? EmotionConstants.Cores.Other))//where does it show up?
                    .frame(height: animateView ? nil : 350, alignment: .top)
                    .scaleEffect(animateView ? 1 : 0.93)
                    .opacity(animateView ? 1 : 0)
                    .ignoresSafeArea()
            }
        }
    }
    
    // MARK: CardView
    @ViewBuilder
    func CheckinCardView(checkin : UnwrappedCheckin) -> some View{
        VStack(alignment: .leading, spacing: 25){
            ZStack(alignment: .center){
                
                
                
                //Episode Description
                GeometryReader{proxy in
                    
                    getEmotionColors(checkin.core)//.opacity(0.8)
                    
                   // let size = proxy.size
                    
                    VStack{
                        //Core & State name
                        Group{
                            Text(checkin.core.name)
                            +
                            Text(" - ")
                            +
                            Text(checkin.state.name).fontWeight(.bold)
                        }
                        .font(.title)
                        .padding()
                    
                        //State Description
//                        Group{
//                        Text(checkin.state.description).italic()
//                        }
//                        .padding()
                        
                        //State explanation from user
                        Group{
                            Text("You felt ")
                            +
                            Text(checkin.state.name).bold()
                            +
                            Text(" because \(checkin.stateResponse)")
                        }.padding()
                        
                        //Headspace
                        Group{
                        Text("Your headspace was filled with thoughts of: ")
                        +
                        Text(checkin.headspaceResponse)
                        }
                        .padding()
                        
                        //Needed
                        Group{
                            Text("You felt you needed: \n")
                            +
                            Text(checkin.needs)
                        }.padding()
                        
                        //Coping
                        Group{
                            Text("You coped with these feelings by: \n")
                            +
                            Text(viewModel.getCopingText(checkin))
                        }.padding()
                        
                    }.multilineTextAlignment(.center)
                    
                }
                .frame(height: 400)
                .clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: 15))
                .foregroundColor(.primary)
                //wrong spot?
                //.offset(y: currentItem?.id == checkin.id && animateView ? safeArea().top : 0)
                
                
                
            }
            //.offset(y: currentItem?.id == checkin.id && animateView ? safeArea().top : 0)
        }
        .matchedGeometryEffect(id: checkin.id, in: animation)
    }
    
    // MARK: Detail View
    func DetailView(checkin: UnwrappedCheckin) -> some View{
        ScrollView(.vertical, showsIndicators: false){
            VStack{
                //Text("Test view stuff ")
                CheckinCardView(checkin: checkin)
                    .scaleEffect(animateView ? 1 : 0.93)
                
                //non scrolling vstack
                VStack{
                    
                }
                
                //InnerScrolling VStack
                VStack(spacing: 15){
                    //detail text
                    Text("Lorem Ipsum")
                }
                .padding()
                .offset(y: scrollOffset > 0 ? scrollOffset : 0)
                .opacity(animateContent ? 1 : 0)
                .scaleEffect(animateView ? 1 : 0, anchor: .top)
            }
            .offset(y: scrollOffset > 0 ? -scrollOffset : 0)
            .offset(offset: $scrollOffset)
        }
        .coordinateSpace(name: "SCROLL")
        .overlay(alignment: .topTrailing){
            Button{
                //closing view
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)){
                    animateView = false
                    animateContent = true
                }
                
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.05)){
                    currentItem = nil
                    showDetailPage = false
                }
                
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.white)
            }
            .padding()
            .opacity(animateView ? 1 : 0)
        }
        .onAppear{
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)){
                animateView = true
            }
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.1)){
                animateContent = true
            }
        }
        .transition(.identity)
    }
    
    /*
     Old method
    var body: some View {
        GeometryReader{geo in
            VStack(){
                
                DateView(date: date)
                    .frame(width: geo.size.width, height: 50, alignment: .center)
                
                
                
                HStack(spacing: 10){
                    if(!viewModel.episodeHistory.isEmpty){
                        EpisodeStatisticsView(viewModel : viewModel)
                            .frame(height: 165)
                            .background(.thinMaterial)
                            .cornerRadius(15)
                    }
                    
                    if(!viewModel.checkinHistory.isEmpty){
                        CheckinStatisticsView(viewModel : viewModel)
                            .frame(height: 165)
                            .cornerRadius(15)
                    }
                }.padding(.horizontal)

                //ScrollView Showing individual checks in
                ScrollView{
                    //TODO: For Each...
                   // if let check = viewModel.checkinHistory.first{
                    
                    ForEach(viewModel.checkinHistory){check in
                        
                        CheckinDetailView(checkin: check)
                            .frame(alignment: .center)
                            .cornerRadius(15)
                            .padding()
                        
                    }
                    
//                        CheckinDetailView()
//                        .frame(alignment: .center)
//                        .cornerRadius(15)
//                        .padding()
//
//                    EpisodeDetailView()
//                        .frame(alignment: .center)
//                        .cornerRadius(15)
//                        .padding()
//
//                    CheckinDetailView2()
//                    .frame(alignment: .center)
//                    .cornerRadius(15)
//                    .padding()
                }
            }
            
        }
    }
    */
}

fileprivate struct EpisodeDetailView : View {
    //let episode : Episode
    
    let stateEmotion : EmotionState = EmotionConstants.States.Fury
    //TODO: Hash edged border
    var body: some View {
        ZStack{
            Color.red.opacity(0.8)
            
            RoundedRectangle(cornerRadius: 15)
                .stroke(style: StrokeStyle(lineWidth: 10, dash: [10]))
                .foregroundColor(.black)
              
            //TODO: Biometrics etc
            Text("28 min").offset(x: -130, y: -210)
            
            
            VStack{
                Group{
                    Text(stateEmotion.name).bold().padding(.top)
                Text(stateEmotion.description).italic()
                
                Text("This was triggered by:")
                    .fontWeight(.bold)
                    .padding(.top)
                Text("Being insulted by a coworker")
                
                Text("This felt like")
                    .fontWeight(.bold)
                    .padding(.top)
                Text("Rejection")
                
                Text("And reminded you of")
                    .fontWeight(.bold)
                    .padding(.top)
                Text("Getting fired")
                }
                Group{
                
                Text("You reacted by")
                    .fontWeight(.bold)
                    .padding(.top)
                Text("Screaming, Undermining, Insulting, and Walking Away")
                
                Text("You were")
                    .fontWeight(.bold)
                    .padding(.top)
                Text("Shaking, Sweating, and your Heart was Racing")
                }
            }.padding().multilineTextAlignment(.center)
        }
    }
}

fileprivate struct CheckinDetailView : View {
    
    let checkin : UnwrappedCheckin
    
  //  let checkin : Checkin
    let sleepQty : Float = 7.7
    let sleepQuality : Int16 = 7
    let stateEmotion : EmotionState = EmotionConstants.States.Anxiety
    let coreEmotion : CoreEmotion = EmotionConstants.Cores.Fear
    let headSpace = "Guilt, Ex Girlfriend"
    let feelINeed = "Companionship, water, exercise"
    let stressLevel : Int16 = 72
    
    let copingMethods : [CopingMethod] = [
        EmotionConstants.CopingMethods.eating,
        EmotionConstants.CopingMethods.electronics, //Video Games, Sex
        EmotionConstants.CopingMethods.venting
    ]
    
    var body: some View {
        ZStack{
            
            //TODO: Core emotion color
            //TODO: Intensity?
            getEmotionColors(checkin.core).opacity(0.8)
          //  Color.purple.opacity(0.5)
            
            VStack{
                
                Text("\(checkin.state.name)").fontWeight(.bold)
                
                Text(checkin.state.description).italic().multilineTextAlignment(.center)
                
                Text("You felt **\(checkin.state.name)** because \(checkin.stateResponse).").padding(.vertical).multilineTextAlignment(.center)
                
                
                Text("\(checkin.headspaceResponse) *(wording about headspace?)*").padding(.vertical).multilineTextAlignment(.center)
                
                
                Text("You felt you needed:")
                Text("\(checkin.needs)")

                
                Text("You coped with your feelings with").padding(.top)
                ForEach(checkin.copingMethods){method in
                     Text("- \(method.name)").bold()
                }
            }.multilineTextAlignment(.center).padding()
        }
    }
}

fileprivate struct CheckinDetailView2 : View {
  //  let checkin : Checkin
    let sleepQty : Float = 7.7
    let sleepQuality : Int16 = 7
    let stateEmotion : EmotionState = EmotionConstants.States.Frustration
    let coreEmotion : CoreEmotion = EmotionConstants.Cores.Fear
    let headSpace = "Guilt, Ex Girlfriend"
    let feelINeed = "Companionship, water, exercise"
    let stressLevel : Int16 = 72
    
    let copingMethods : [CopingMethod] = [
        EmotionConstants.CopingMethods.eating,
        EmotionConstants.CopingMethods.electronics, //Video Games, Sex
        EmotionConstants.CopingMethods.venting
    ]
    
    var body: some View {
        ZStack{
            
            //TODO: Core emotion color
            //TODO: Intensity?
            Color.red.opacity(0.5)
            
            VStack{
                
                Text("\(stateEmotion.name)").fontWeight(.bold)
                
                Text(stateEmotion.description).italic().multilineTextAlignment(.center)
                
                Text("You felt **Frustration** because of work.").padding(.vertical).multilineTextAlignment(.center)
                

                //Text("howAmIFeeling: Afraid+Anxious")
                
                Text("How hard it is to find a job that will pay rent. *(wording about headspace?)*").padding(.vertical).multilineTextAlignment(.center)
                
                
                Text("You felt you needed:")
                Text("Space, Help, Money").bold()
                
                Text("You coped with your stress with").padding(.top)
                Text("Smoking, Drinking").bold()
                
                //Text("stressLevel: 72")
            }.padding()
        }
    }
}

fileprivate struct EpisodeStatisticsView : View {
    @StateObject var viewModel : HistoryViewModel
    
    var body: some View {
        ZStack{
            //Color.gray
            VStack{
                Text("What info do we need for episodes that wouldn't be included in an episode card?")
            }
        }
    }
}

fileprivate struct CheckinStatisticsView : View {
    @StateObject var viewModel : HistoryViewModel
    
    var body: some View {
        ZStack{
        Color.gray
            VStack{
                Text("Stress: ")
                +
                viewModel.getStressText()
                
                
                Text("Sleep Qty: ")
                +
                viewModel.getSleepQuantityText()
                
                
                Text("Sleep Quality: ")
                +
                viewModel.getSleepQualityText()
            }
        }//.background(.thinMaterial)
    }
}
//TODO: Make scrollable?
//TODO: Show episode data from other days?
//TODO: Unhide future days?
fileprivate struct DateView : View {
    let date : Date
    
    var body: some View {
            HStack(spacing: 25){
                
                VStack{
                    
                    let tmpDate = Calendar.current.date(byAdding: .day, value: -3, to: date)!
                    
                    Text(tmpDate.formatted(.dateTime.day()))
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                    
                    Text(tmpDate.formatted(.dateTime.weekday()))
                        .font(.system(size: 12))
                    
                }
                VStack{
                    let tmpDate = Calendar.current.date(byAdding: .day, value: -2, to: date)!
                    
                    Text(tmpDate.formatted(.dateTime.day()))
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                    Text(tmpDate.formatted(.dateTime.weekday()))
                        .font(.system(size: 12))
                    
                }
                VStack{
                    let tmpDate = Calendar.current.date(byAdding: .day, value: -1, to: date)!
                    
                    Text(tmpDate.formatted(.dateTime.day()))
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                    Text(tmpDate.formatted(.dateTime.weekday()))
                        .font(.system(size: 12))
                    
                }
                VStack{
                    
                    Text(date.formatted(.dateTime.day())).fontWeight(.bold)
                        .font(.system(size: 18))
                        .foregroundColor(.red)
                    Text(date.formatted(.dateTime.weekday()))
                        .font(.system(size: 12))
                        .fontWeight(.light).foregroundColor(.red)
                    
                }
                
                VStack{
                    
                    
                    let tmpDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                    
                    //in future, result is 1
                    //today or in past, result is -1
                    
                    let isFuture = tmpDate.compare(Date.now).rawValue == 1
                    
                    
                    Text(tmpDate.formatted(.dateTime.day()))
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(isFuture ? .gray : .black)
                    
                    Text(tmpDate.formatted(.dateTime.weekday()))
                        .font(.system(size: 12))
                        .foregroundColor(isFuture ? .gray : .black)
                    
                }
                
                VStack{
                    
                    let tmpDate = Calendar.current.date(byAdding: .day, value: 2, to: date)!
                    
                    let isFuture = tmpDate.compare(Date.now).rawValue == 1
                    
                    
                    Text(tmpDate.formatted(.dateTime.day()))
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(isFuture ? .gray : .black)
                    
                    Text(tmpDate.formatted(.dateTime.weekday()))
                        .font(.system(size: 12))
                        .foregroundColor(isFuture ? .gray : .black)
                    
                }
                
                VStack{
                    
                    let tmpDate = Calendar.current.date(byAdding: .day, value: 3, to: date)!
                    
                    let isFuture = tmpDate.compare(Date.now).rawValue == 1
                    
                    
                    Text(tmpDate.formatted(.dateTime.day()))
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(isFuture ? .gray : .black)
                    
                    Text(tmpDate.formatted(.dateTime.weekday()))
                        .font(.system(size: 12))
                        .foregroundColor(isFuture ? .gray : .black)
                    
                }
                
                
        }
    }
}

struct HistoryView_Previews: PreviewProvider {

    static var previews: some View {

        HistoryView(
            date: Date.now,
            viewModel: HistoryViewModel(checks: [], episodes: [Episode()]))
    }
}

// MARK: ScaledButton Style
struct ScaledButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

// Safe Area Value
extension View{
    func safeArea()->UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else{
            return .zero
        }
        
        return safeArea
    }
    
    // MARK: ScrollView Offest
    func offset(offset: Binding<CGFloat>)-> some View{
        return self
            .overlay{
                GeometryReader{geo in
                    let minY = geo.frame(in: .named("SCROLL")).minY
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                }
                .onPreferenceChange(OffsetKey.self){ value in
                    offset.wrappedValue = value
                }
            }
    }
}

// MARK: Offset Key
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value : inout CGFloat, nextValue: () -> CGFloat){
        value = nextValue()
    }
}
