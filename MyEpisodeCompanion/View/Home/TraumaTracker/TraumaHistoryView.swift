//
//  TraumaHistoryView.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 5/11/22.
//

import SwiftUI

struct TraumaHistoryView: View {
    
    @StateObject var viewModel : TraumaHistoryViewModel = TraumaHistoryViewModel()
    
    @State var traumaHistory : [TestTrauma] =
    [
        TestTrauma(age: 12, name: "Car Crash", core: EmotionConstants.Cores.Fear),
        TestTrauma(age: 15, name: "Sexual Assault", core: EmotionConstants.Cores.Anger),
        TestTrauma(age: 16, name: "Physical Abuse", core: EmotionConstants.Cores.Fear)
        
    ]
    
    
    var body: some View {
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
            
            HStack{

                
                ForEach(traumaHistory){trauma in
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(trauma.core.colorSecondary)
                        .frame(width: 100, height: 80, alignment: .center)
                        
                        .overlay{
                            VStack{
                                Text("Age: \(trauma.age)")
                                Text(trauma.name)
                            }
                        }
                    
                }
            }
            
        }
    }
}

struct TestTrauma : Identifiable {
    let id: UUID = UUID()
    var age : Int
    var name : String
    var core : CoreEmotion
}

struct TraumaHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        TraumaHistoryView()
    }
}
