//
//  EpisodeDataReportViewController.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/19/22.
//

import Foundation
import HealthKit

final class EpisodeRecordViewModel : ObservableObject {
    @Published var testVar : String = ""
    
    @Published var episodeStart : Date
    
    @Published var query : HKQuery?
    
    @Published var dataValues: [HKStatistics] = []
    
    
    init(){
        
        episodeStart = Date.now
        
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        myHealthStore?.requestAuthorization(toShare: [stepType], read: [stepType]){(success, error) in
            
            if success {
                self.calculateDailyStepCountForPastWeek()
            }
            
        }
        
    }
    
    func readData() -> String {
        if let val = dataValues.first{
            //if let val.quantityType.v
            if let qty = val.sumQuantity(){
                return "\(qty)"
            }
            return "count: \(dataValues.count)"
      //      return "\(val.quantityType.identifier)"
        }
        return "No Data"
    }
    
    func calculateDailyStepCountForPastWeek() {
        //TODO: change this to heart rate?
        
        let stepType = HKSampleType.quantityType(forIdentifier: .stepCount)!
        //let monday = mondayAt3Am() ??
        
        let cal = NSCalendar.current
        var anchorComponents = cal.dateComponents([.day, .month, .year, .weekday], from: NSDate() as Date)
        
        let offset = (7 + anchorComponents.weekday! - 2) % 7
        anchorComponents.day! -= offset
        anchorComponents.hour = 2
        guard let anchorDate = Calendar.current.date(from: anchorComponents) else {
            fatalError("*** unable to create a valid date from given components")
        }
        
        let daily = DateComponents(day: 1)
        let exactlySevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let oneWeekAgo = HKQuery.predicateForSamples(withStart: exactlySevenDaysAgo, end: nil, options: .strictStartDate)
        
        var query = HKStatisticsCollectionQuery(
            quantityType: stepType,
            quantitySamplePredicate: oneWeekAgo,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: daily)
        
        query.initialResultsHandler = { query, statisticsCollection, error in
            if let statisticsCollection = statisticsCollection {
                self.updateUIFromStatistics(statisticsCollection)
            }
        }
        
        myHealthStore?.execute(query)
        
        print("Calculated...")
    }
    
    func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection){
        DispatchQueue.main.async {
            self.dataValues = []
            let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
            let endDate = Date()
            
            statisticsCollection.enumerateStatistics(from: startDate, to: endDate){ [weak self](statistics, stop) in
                self?.dataValues.append(statistics)
            }
           // self.reloadData()
        }
    }
    
}




/*
 Sample data sample
 
 //Create start and end times for data sample
 let startDate = Date.now
 let intervalDate = Calendar.current.date(byAdding: .minute, value: 5, to: startDate)!
 
 //construct a quantity, representing the value and unit for the data (sample = walked 500ft)
 let distanceQuantity = HKQuantity(unit: HKUnit.foot(), doubleValue: 500.0)
 
 //build the sample
 let sample = HKQuantitySample(
     type: HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
     quantity: distanceQuantity,
     start: startDate, end: intervalDate)
 
 healthStore?.save(sample) { success, error in
     if success {
         print("success!")
     } else {
         print("oh no! We couldn't successfully save for some reason")
     }
 }
 //21:58
 */
