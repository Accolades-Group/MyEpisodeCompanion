//
//  HistoryModel.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/29/22.
//

import Foundation
import SwiftUI
import CoreData

final class HistoryViewModel : ObservableObject  {
    

    var checkinHistory : [UnwrappedCheckin]
    var episodeHistory : [Episode]
    
    
    
    init(checks: [Checkin], episodes : [Episode]) {
    
        
        
        //checkinHistory = checks
        checkinHistory = []
        episodeHistory = episodes
        
        //for debugging
        if(checks.isEmpty){
            checkinHistory.append(UnwrappedCheckin(
                date: Date.now,
                id: UUID(),
                sleepQuantity: 7.8,
                sleepQuality: 7,
                core: EmotionConstants.Cores.Joy,
                state: EmotionConstants.States.Ecstasy,
                stateResponse: "I feel extasy because It's a great day",
                headspaceResponse: "This is the response to what my headspace is like",
                needs: "I need to drink more water?",
                stressLevel: 82,
                copingMethods: [EmotionConstants.CopingMethods.meditation, EmotionConstants.CopingMethods.alcohol, EmotionConstants.CopingMethods.gambling]
                /*
            hasSecondary: false,
                secondaryCore: nil,
                secondaryState: nil,
                secondaryResponse: nil
                 */
            ))
        }else{
            checks.forEach{check in
                if let unwrapped = check.unwrapCheckin(){
                    checkinHistory.append(unwrapped)
                }
            }
        }
    }
    
    //TODO: Define stress ranges more specifically, this is just a prelim
    func getStressText() -> Text{
        let avg = getStressAvg()
        return Text("\(avg)/100").foregroundColor(avg >= 80 ? .red : (60...79).contains(avg) ? .orange : (40...59).contains(avg) ? .yellow : .green)
    }
    
    func getSleepQuantityText() -> Text{
        var sleep : Float = 0
        //TODO: checkin wtih most sleep from that day?
        checkinHistory.forEach{check in
            if check.sleepQuantity > sleep {
                sleep = check.sleepQuantity
            }
        }
        return Text("\(sleep, specifier: "%.1f") hrs").foregroundColor(sleep > 12 ? .orange : sleep > 7 ? .green : sleep > 5 ? .orange : .red )
    }
    
    func getSleepQualityText() -> Text{
        //TODO: Average?
        var quality = 0
        checkinHistory.forEach{check in
            quality += Int(check.sleepQuality)
        }
        quality /= checkinHistory.count
        return Text("\(quality)/10").foregroundColor(quality > 7 ? .green : quality > 6 ? .yellow : quality > 4 ? .orange : .red)
    }
    
    func getStressAvg() -> Int {
        var retAvg = 0
        checkinHistory.forEach{check in
            
            retAvg += Int(check.stressLevel)
            
        }
        
        return Int(retAvg/checkinHistory.count)
    }
    
    func getCopingText(_ checkin : UnwrappedCheckin) -> String{
        
        var returnString : String = ""
        
        checkin.copingMethods.forEach{method in
            returnString.append(method.name)
            returnString.append(", ")
        }
        return String(returnString.dropLast(2))
    }
}
