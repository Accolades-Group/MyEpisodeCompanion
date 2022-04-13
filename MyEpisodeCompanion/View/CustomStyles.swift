//
//  CustomStyles.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 4/5/22.
//

import SwiftUI


func getEmotionColors(_ core : CoreEmotion, isSelected: Bool = true) -> Color{
    

    
    switch core{
    case EmotionConstants.Cores.Anger: return isSelected ? Color(red: 0.969, green: 0.384, blue: 0.384) : Color(red: 0.839, green: 0.733, blue: 0.733)
        
    case EmotionConstants.Cores.Sadness: return isSelected ? Color(red: 0, green: 0.733, blue: 0.941) : Color(red: 0.762, green: 0.86, blue: 0.887)
        
    case EmotionConstants.Cores.Disgust: return isSelected ? Color(red: 0.137, green: 0.639, blue: 0.578) : Color(red: 0.692, green: 0.754, blue: 0.746)
        
    case EmotionConstants.Cores.Fear: return isSelected ? Color(red: 0.589, green: 0.325, blue: 0.655) : Color(red: 0.826, green: 0.795, blue: 0.833)
        
    case EmotionConstants.Cores.Joy: return isSelected ? Color(red: 0.98, green: 0.737, blue: 0.255) : Color(red: 0.842, green: 0.801, blue: 0.719)
        
    default:
        return isSelected ? Color(red: 0.191, green: 0.187, blue: 0.192) : Color(red: 0.606, green: 0.582, blue: 0.613)
    }
}


struct NextButtonStyle: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View{
        configuration.label
            .padding()
            .frame(width: 150, height: 30, alignment: .center)
            .background(Color(red: 0.376, green: 0.4, blue: 0.816))
            .cornerRadius(5)
            .opacity(configuration.isPressed ? 0.5 : 1)
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
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 17.5))
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
        getEmotionColors(EmotionConstants.Cores.Joy),
        getEmotionColors(EmotionConstants.Cores.Fear)
    ], center: .center)
    let colors : [Color] = [
        getEmotionColors(EmotionConstants.Cores.Fear),
        getEmotionColors(EmotionConstants.Cores.Anger)
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

struct CustomStyles: View {
    @State var isSelected = false
    let core : CoreEmotion = EmotionConstants.Cores.Anger
    var body: some View {
        VStack{
            Spacer()
            Button("Continue"){
                
            }.buttonStyle(NextButtonStyle())
            Spacer()
            CalendarShape()
            
            Spacer()
        Button(){
            isSelected.toggle()
            print(isSelected)
        }label:{
            Text(core.name)
        }.buttonStyle(EmotionButtonStyle(color: getEmotionColors(core, isSelected: isSelected)))
            
            Spacer()
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
