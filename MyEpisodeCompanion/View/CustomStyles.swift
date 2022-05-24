//
//  CustomStyles.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 4/5/22.
//

import SwiftUI


func getEmotionColors(_ core : CoreEmotion, isSelected: Bool = true) -> Color{
    

    
    switch core{
    case EmotionConstants.Cores.Anger: return isSelected ? Color.Anger.Primary : .Anger.Tertiary
        
    case EmotionConstants.Cores.Sadness: return isSelected ? Color.Sadness.Primary : .Sadness.Tertiary
        
    case EmotionConstants.Cores.Disgust: return isSelected ? Color.Disgust.Primary : .Disgust.Tertiary
        
    case EmotionConstants.Cores.Fear: return isSelected ? Color.Fear.Primary : .Fear.Tertiary
        
    case EmotionConstants.Cores.Joy: return isSelected ? Color.Joy.Primary : .Joy.Tertiary
        
    default:
        return isSelected ? Color(red: 0.191, green: 0.187, blue: 0.192) : Color(red: 0.606, green: 0.582, blue: 0.613)
    }
}


struct NextButtonStyle: ButtonStyle{
    
    func makeBody(configuration: Configuration) -> some View{
        configuration.label
            .padding()
            .frame(width: 130, height: 30, alignment: .center)
            .background(Color(red: 0.376, green: 0.4, blue: 0.816))
            .cornerRadius(5)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

struct DeleteButtonStyle: ButtonStyle{
    
    func makeBody(configuration: Configuration) -> some View{
        configuration.label
            .padding()
            .frame(width: 130, height: 30, alignment: .center)
            .background(Color(red: 0.876, green: 0.4, blue: 0.416))
            .cornerRadius(5)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

struct CopingButtonStyle: ButtonStyle {
    
    var isSelected : Bool
    var color : Color
    //let selectedColor : Color = .blue
    let unSelectedColor : Color = .gray.opacity(0.2)
    
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .font(.body)
            .foregroundColor(isSelected ? .white : .black)
            .padding(5)
            .frame(minWidth: 100, idealWidth: 120, maxWidth: 150, alignment: .center)
            .background(isSelected ? color : unSelectedColor)
            .clipShape(Capsule())
            .overlay{
                Capsule().stroke(color, lineWidth: 2).frame(minWidth: 100, maxWidth: 150)
            }
            
    }
    
}

struct EmotionButtonStyle: ButtonStyle{
    
    var color: Color
    var size: ButtonSizes = .medium
    
    enum ButtonSizes {
        case small, medium, large
    }
    
    func makeBody(configuration : Configuration) -> some View{
        configuration.label
            .font(size == .small ? .callout : size == .medium ? .body : .title3)
            .foregroundColor(.white)
            .padding(.horizontal, size == .small ? 5 : size == .medium ? 10 : 15)
            .padding(.vertical, 5)
            .frame(width: 170)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 17.5))
    }
}

struct StateEmotionButtonStyle: ButtonStyle{
    
    var state: EmotionState
    //var color: Color
    var isSelected: Bool
    var size: ButtonSizes = .medium
    
    enum ButtonSizes {
        case small, medium, large
    }
    
    func makeBody(configuration : Configuration) -> some View{
        
        let colors = state.getColorGradient()
        
        configuration.label
            .font(size == .small ? .callout : size == .medium ? .body : .title3)
            .foregroundColor(isSelected ? .white : .black)
            .padding(.horizontal, size == .small ? 5 : size == .medium ? 10 : 15)
            .padding(.vertical, 5)
            .frame(width: 170)
            .background{
                ZStack{
                    //state.core.colorTertiary.opacity(0.1)
                    Color.white
                LinearGradient(colors:
                                        isSelected ? [state.core.color] :
                                       // [.white]
                                       colors
                                       , startPoint: .leading, endPoint: .trailing)
                }
            }
            .clipShape(Capsule())
            
            .overlay(
                
                Capsule().stroke(state.core.color, lineWidth: 2)
            )
        

    }
    /*
    func makeGradient() -> [Color]{
        
        let min = state.intensity.lowerBound
        let max = state.intensity.upperBound
        let mid = (max + min) / 2
        
        var colors : [Color] = []
        
        ForEach(min..<max){index in
            if((0...3).contains(index)){
                colors.append(state.core.colorTertiary)
            }else if((4...7).contains(index)){
                colors.append(state.core.colorSecondary)
            }else if((7...10).contains(index)){
                colors.append(state.core.color)
            }
        }
        
        return colors
    }
     */
     
}


struct EmotionButtonStyle2: ButtonStyle{
    
    var color: Color
    var isSelected : Bool
    var size: ButtonSizes = .medium
    
    enum ButtonSizes {
        case small, medium, large
    }
    
    func makeBody(configuration : Configuration) -> some View{
        configuration.label
            .font(size == .small ? .callout : size == .medium ? .body : .title3)
            .foregroundColor(isSelected ? .white  : color)
            .padding(.horizontal, size == .small ? 5 : size == .medium ? 10 : 15)
            .padding(.vertical, 5)
            //.frame(width: 100)
            .frame(minWidth: 100, maxWidth: 150)
            .background(isSelected ? color : .white)
            .clipShape(Capsule())
            .overlay(
                //Capsule().stroke(color, lineWidth: 2).frame(width: 100)
                Capsule().stroke(color, lineWidth: 2).frame(minWidth: 100, maxWidth: 180)
            )
            //.clipShape(RoundedRectangle(cornerRadius: 17.5))
    }
    
}

struct CustomCorner: Shape {
    var corners : UIRectCorner
    var radius: CGFloat
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}

struct CalendarShape: View{
    let gradient = AngularGradient(colors: [
        EmotionConstants.Cores.Joy.color,
        EmotionConstants.Cores.Fear.color
    ], center: .center)
    let colors : [Color] = [
        EmotionConstants.Cores.Fear.color,
        EmotionConstants.Cores.Anger.color
    ]
    var body: some View{
        
        ZStack{
            
            ForEach(colors.indices){i in
                Rectangle().fill(colors[i]).rotationEffect(Angle(degrees: Double(15 * i))).frame(width: 35, height: 35, alignment: .center)
            }
            
        
        Text("30")
            .hidden()
            //.padding(8)
            .padding(4)
            .background(gradient) //TODO: Angular Gradient
            .clipShape(Circle())
            .padding(.vertical, 4)
            .overlay(
                Text("31").foregroundColor(.black)
            )
    }
    }
}

struct StressShape : View {
    
    let color : Color
    let width : CGFloat
    let height : CGFloat
    let stressor : Stressor
    
    var body: some View {
        

            
        
        RoundedRectangle(cornerRadius: 2)
            //.stroke(color, lineWidth: 2)
            .fill(.thinMaterial)
            
            .frame(
                width: width,
                height: height)
            .overlay(

                  RoundedRectangle(cornerRadius: 2)
                    .stroke(color, lineWidth: 2).overlay{
                        VStack{
                            Text(stressor.name ?? "No Name")
                            Text("\(stressor.weight)")
                        }
                    }

                
            )
            

            
    }
}

struct SleepQualitySlider : View {
    @State var offset : CGFloat
    
    @Binding var sliderValue : Float
    let minVal : CGFloat = 0
    let maxVal : CGFloat = 10
    @State var color : Color
    
    let barHeight : CGFloat = 20
    let barWidth : CGFloat = 300
    let circleWidth : CGFloat = 25
    let circleOutlineWidth : CGFloat = 5
    let circleRadius : CGFloat = 15 //(circle width + outlineWidth) / 2 = r
    let minOffX : CGFloat = 15 // radius
    let maxOffX : CGFloat = 285 // bar width - radius
    
    init(sleepQuality : Binding<Float>){
        
        self._sliderValue = sleepQuality
        
        let sleepValue = sleepQuality.wrappedValue
        
        self.offset = (CGFloat(maxOffX - minOffX) / CGFloat(10)) * CGFloat(sleepValue)
        
        self.color =
        sleepValue < 3 ? .red :
        (3...4).contains(sleepValue) ? .orange :
        (4...7).contains(sleepValue) ? .yellow :
            .green
        
    }
    
    var body: some View{
        
        
        VStack(alignment: .center){
            
            GeometryReader{geo in
                
                VStack{
                    
                    HStack{
                        Text("\(sliderValue, specifier: "%.f")")
                    }.frame(width: barWidth)
                    
                    ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)){
                        
                        //Background empty
                        Capsule()
                            .fill(Color.black.opacity(0.25))
                            .frame(width: barWidth, height: barHeight)
                        
                        //Background Filled
                        Capsule()
                            .fill(color)
                            .frame(width: offset + circleRadius, height: barHeight) //circle radius = 15
                        
                        //Increment Dots
                        //12 hour lines + 12 30 min lines = 24 lines
                        //300 /
                        let spacing = barWidth / (maxVal) - 0.5
                        HStack(spacing: spacing){
                            
                            ForEach(0..<Int(maxVal)){index in
                                
                                let color : Color = index == 0 ? Color.clear : .white
                                
                                
                                let height : CGFloat = barHeight - 5

                                Rectangle()
                                    .fill(color)
                                    .frame(width: 1, height: height)
                                
                            }
                        }
                        
                        //Slider Button
                        Circle()
                            .fill(color)
                            .frame(width: 25, height: 25)
                            .background(Circle().stroke(Color.white, lineWidth: 5))
                            //.background()
                            .offset(x: offset)
                            .gesture(
                                DragGesture().onChanged({(value) in
                                
                                    let centerVal = CGFloat(value.location.x) - circleRadius
                                
                                //if in range
                                if centerVal >= -15
                                    && centerVal <= maxOffX {
                                    
                                    //set offset (circle radius = 15)
                                    offset = centerVal
                                    
                                    
                                    updateValue()
                                }
                                
                                
                                })
                                /*.onEnded{value in
                                    
                                    let centerVal = CGFloat(value.location.x) - circleRadius
                                    
                                    //sliderValue = Float(centerVal)
                                    
                                    let rem = centerVal.truncatingRemainder(dividingBy: spacing)
                                    
                                    if rem < spacing / 2 {
                                        offset -= rem
                                    } else {
                                        offset += rem
                                    }
                                    
                                    
                                    updateValue()
                                    
                                }*/
                            )
                            
                    }
                    
                    HStack{
                        Text("\(Int(minVal))")
                        Spacer()
                        
                        Text("\(Int(maxVal))")
                    }.frame(width: barWidth)
                   // Text("Geo w: \(geo.size.width)")
                }
            }.frame(width: barWidth, height: 100, alignment: .center)
        }
    }
    
    func updateValue(){
        if offset < 0 {
            sliderValue = Float(minVal)
            
        } else if offset >= maxOffX - (circleRadius / 2){
            sliderValue = Float(maxVal)
            
        }else{

            //let val = ceil(maxOffX / offset)
            //let val = (offset / 12).rounded()
            sliderValue = Float(ceil((offset / maxOffX) * 10))
        }
        
        withAnimation(){
            self.color =
            sliderValue < 3 ? .red :
            (3...4).contains(sliderValue) ? .orange :
            (4...7).contains(sliderValue) ? .yellow :
                .green
        }
        //value = sliderValue
        
    }
    
}

/**
 Source: https://www.youtube.com/watch?v=z0PqbaHHjfA
 */
struct SleepQtySlider : View {
    
    @State var offset : CGFloat
    
    @Binding var sliderValue : Float
    
    
    let minVal : CGFloat = 0
    let maxVal : CGFloat = 12
    @State var color : Color
    
    let barHeight : CGFloat = 20
    let barWidth : CGFloat = 300
    let circleWidth : CGFloat = 25
    let circleOutlineWidth : CGFloat = 5
    let circleRadius : CGFloat = 15 //(circle width + outlineWidth) / 2 = r
    let minOffX : CGFloat = 15 // radius
    let maxOffX : CGFloat = 285 // bar width - radius
    
    init(sleepQty : Binding<Float>){
        
        self._sliderValue = sleepQty
        
        let sleepValue = sleepQty.wrappedValue
        
        self.offset = (CGFloat(maxOffX - minOffX) / CGFloat(12)) * CGFloat(sleepValue)
        
        color = sleepValue < 3 ? .red :
        (3..<5).contains(sleepValue) ? .orange :
        (5..<7).contains(sleepValue) ? .yellow :
        (7..<9).contains(sleepValue) ? .green :
        (9...10).contains(sleepValue) ? .blue :
            .black
    }
    
    var body: some View{
        
        
        VStack(alignment: .center){
            
            GeometryReader{geo in
                
                VStack{
                    
                    HStack{
                        Text("\(sliderValue, specifier: "%.1f")")
                    }.frame(width: barWidth)
                    
                    ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)){
                        
                        //Background empty
                        Capsule()
                            .fill(Color.black.opacity(0.25))
                            .frame(width: barWidth, height: barHeight)
                        
                        //Background Filled
                        Capsule()
                            .fill(color)
                            .frame(width: offset + circleRadius, height: barHeight) //circle radius = 15
                        
                        //Increment Dots
                        //12 hour lines + 12 30 min lines = 24 lines
                        //300 /
                        let spacing = barWidth / (maxVal * 2) - 0.5
                        HStack(spacing: spacing){
                            
                            ForEach(0..<Int(maxVal * 2)){index in
                                
                                let color : Color =
                                (index == 0 || index == Int(maxVal * 2)) ? Color.clear : .white
                                
                                
                                let height : CGFloat = index % 2 == 0 ? barHeight - 5 : barHeight - 12

                                Rectangle()
                                    .fill(color)
                                    .frame(width: 1, height: height)
                                
                            }
                        }
                        
                        //Slider Button
                        Circle()
                            .fill(color)
                            .frame(width: 25, height: 25)
                            .background(Circle().stroke(Color.white, lineWidth: 5))
                            //.background()
                            .offset(x: offset)
                            .gesture(
                                DragGesture().onChanged({(value) in
                                
                                    let centerVal = CGFloat(value.location.x) - circleRadius
                                
                                //if in range
                                if centerVal >= -15
                                    && centerVal <= maxOffX {
                                    
                                    //set offset (circle radius = 15)
                                    offset = centerVal 
                                    
                                    
                                    updateValue()
                                }
                                
                                
                                })
                                /* TODO: Snap to value?
                                .onEnded{value in
                                    
                                    let centerVal = CGFloat(value.location.x) - circleRadius
                                    
                                    //sliderValue = Float(centerVal)
                                    
                                    let rem = centerVal.truncatingRemainder(dividingBy: spacing)
                                    
                                    if rem < spacing / 2 {
                                        offset -= rem
                                    } else {
                                        offset += rem
                                    }
                                    
                                    
                                    updateValue()
                                    
                                }
                                 */
                            )
                            
                    }
                    
                    HStack{
                        Text("\(Int(minVal))")
                        Spacer()
                        
                        Text("\(Int(maxVal))")
                    }.frame(width: barWidth)
                   // Text("Geo w: \(geo.size.width)")
                }
            }.frame(width: barWidth, height: 100, alignment: .center)
        }
    }
    
    func updateValue(){
        if offset < 0 {
            sliderValue = Float(minVal)
            
        } else if offset >= maxOffX - (circleRadius / 2){
            sliderValue = Float(maxVal)
            
        }else{
            //let denominator = 2
            let val = ceil((offset / (maxVal * 2)) / 0.5) * 0.5
            //let val = (offset / 12).rounded()
            sliderValue = Float(val)
        }
        
        updateColor()
        //value = sliderValue
        
    }
    func updateColor(){
        withAnimation(){
            color = sliderValue < 3 ? .red :
            (3..<5).contains(sliderValue) ? .orange :
            (5..<7).contains(sliderValue) ? .yellow :
            (7..<9).contains(sliderValue) ? .green :
            (9...10).contains(sliderValue) ? .blue :
                .black
        }
    }
}

struct CustomStyles: View {
    @State var isSelected = false
    let core : CoreEmotion = EmotionConstants.Cores.Anger
    let state : EmotionState = EmotionConstants.States.Argumentativeness
    let stressor : Stressor = Stressor()
    @State var sliderValue : Float = 8.0
    var body: some View {
        VStack{
            
            
            
            Group{
                //StressShape(color: .red, width: 200, height: 80, stressor: stressor)
                SleepQtySlider(sleepQty: $sliderValue)
                SleepQualitySlider(sleepQuality: $sliderValue)
            }
            Spacer()
            Button("Continue"){
                
            }.buttonStyle(NextButtonStyle())
            Button("Delete"){
                
            }.buttonStyle(DeleteButtonStyle())
            Spacer()
            CalendarShape()
            
            Spacer()
            Group{
                
                Button("Work"){
                    isSelected.toggle()
                }.buttonStyle(CopingButtonStyle(isSelected: isSelected, color: .green))
            
        Button(){
            isSelected.toggle()
            print(isSelected)
        }label:{
            Text(EmotionConstants.States.Annoyance.name)
        }.buttonStyle(StateEmotionButtonStyle(state: EmotionConstants.States.Annoyance, isSelected: isSelected))
            
            
            
            Button(){
                isSelected.toggle()
                print(isSelected)
            }label:{
                Text(EmotionConstants.States.Frustration.name)
            }.buttonStyle(StateEmotionButtonStyle(state: EmotionConstants.States.Frustration, isSelected: isSelected))
                
                Button(){
                    isSelected.toggle()
                    print(isSelected)
                }label:{
                    Text(EmotionConstants.States.Exasperation.name)
                }.buttonStyle(StateEmotionButtonStyle(state: EmotionConstants.States.Exasperation, isSelected: isSelected))
                
                
                Button(){
                    isSelected.toggle()
                    print(isSelected)
                }label:{
                    Text(EmotionConstants.States.Argumentativeness.name)
                }.buttonStyle(StateEmotionButtonStyle(state: EmotionConstants.States.Argumentativeness, isSelected: isSelected))
                

                
                Button(){
                    isSelected.toggle()
                    print(isSelected)
                }label:{
                    Text(EmotionConstants.States.Bitterness.name)
                }.buttonStyle(StateEmotionButtonStyle(state: EmotionConstants.States.Bitterness, isSelected: isSelected))
                

                
                Button(){
                    isSelected.toggle()
                    print(isSelected)
                }label:{
                    Text(EmotionConstants.States.Vengefulness.name)
                }.buttonStyle(StateEmotionButtonStyle(state: EmotionConstants.States.Vengefulness, isSelected: isSelected))
                
                
                Button(){
                    isSelected.toggle()
                    print(isSelected)
                }label:{
                    Text(EmotionConstants.States.Fury.name)
                }.buttonStyle(StateEmotionButtonStyle(state: EmotionConstants.States.Fury, isSelected: isSelected))
            
            }
            Spacer()
            
            Button(){
                isSelected.toggle()
                print(isSelected)
            }label:{
                Text(core.name)
            }.buttonStyle(EmotionButtonStyle2(color: core.color, isSelected: isSelected))
                
                
        }

    }
}


//for allowing background(color) on textview
//extension UITextView {
//    open override var backgroundColor: UIColor?: CGRect {
//        didSet {
//            backgroundColor = .clear //<<here clear
//            drawsBackground = true
//        }
//
//    }
//}

struct CustomStyles_Previews: PreviewProvider {
    static var previews: some View {
        CustomStyles()
    }
}
