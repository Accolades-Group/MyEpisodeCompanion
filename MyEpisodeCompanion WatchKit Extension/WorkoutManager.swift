//
//  EpisodeManager.swift
//  MyEpisodeCompanion WatchKit Extension
//
//  Created by Tanner Brown on 3/21/22.
//

import Foundation
import HealthKit

class WorkoutManager : NSObject, ObservableObject {
    
    var selectedEpisode : HKWorkoutActivityType? {
        didSet {
            guard let selectedEpisode = selectedEpisode else { return }
            startEpisode(workoutType: selectedEpisode)
        }
    }
    
    @Published var showingSummaryView : Bool = false {
        didSet {
            // Sheet dismissed
            if showingSummaryView == false {
                resetWorkout()
            }
        }
    }
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    func startEpisode(workoutType: HKWorkoutActivityType){
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .unknown //TODO:
        
        do {
            session = try HKWorkoutSession(
                healthStore: healthStore,
                configuration: configuration
            )
            builder = session?.associatedWorkoutBuilder()
        } catch {
            //Handle any exceptions.
            return
        }
        
        builder?.dataSource = HKLiveWorkoutDataSource(
            healthStore: healthStore,
            workoutConfiguration: configuration
        )
        
        session?.delegate = self
        builder?.delegate = self
        
        //start the episode "workout" session and begin data collection
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
            //The "workout" has started
        }
        
    }
    // Request authorization to access HealthKit.
    func requestAuthorization() {
        //the quantity type to write to the health store
        let typesToShare : Set = [
            HKQuantityType.workoutType()
        ]
        
        //the quantity types to read from the health store.
        let typesToRead : Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!, //HR
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!, //Cals
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!, //Distance
            HKQuantityType.quantityType(forIdentifier: .stepCount)!, //Step Count
            HKQuantityType.quantityType(forIdentifier: .environmentalAudioExposure)!, //Audio Exposure
            HKQuantityType.quantityType(forIdentifier: .respiratoryRate)!, //Respitory Rate TODO: Can we retrieve this?
            HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!, //HRV
            HKQuantityType.quantityType(forIdentifier: .vo2Max)!, //vo2Max TODO: Can we retrieve this?
            HKQuantityType.quantityType(forIdentifier: .oxygenSaturation)!, //Blood Oxygen Levels
            //TODO: Body temp?
            HKObjectType.activitySummaryType()
        ]
        
        //request auth for those quantity types
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead){ (success, error) in
            //handle error.
            
        }
        
    }
    
    // MARK: - State Control
    
    // The episode session state.
    @Published var running = false
    
    func pause() {
        session?.pause()
    }
    
    func resume() {
        session?.resume()
    }
    
    func togglePause() {
        if running == true {
            pause()
        } else {
            resume()
        }
    }
    
    func endEpisode() {
        session?.end()
        showingSummaryView = true
    }
    
    // MARK: - Workout Metrics
    @Published var averageHeartRate : Double = 0
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var distance: Double = 0
    @Published var steps: Double = 0
    @Published var soundDb : Double = 0
    @Published var averageSoundDb : Double = 0
    @Published var respiratoryRate : Double = 0
    @Published var hRV : Double = 0
    @Published var v02Max : Double = 0
    @Published var oxygenSaturation : Double = 0
    @Published var workout : HKWorkout?
    
    func updateForStatistics(_ statistics : HKStatistics?){
        guard let statistics = statistics else { return }
        
        DispatchQueue.main.async {
            switch statistics.quantityType {
                //Heart Rate
            case HKQuantityType.quantityType(forIdentifier: .heartRate) :
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                
                //Cal Burn
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
                
                //Distance Walking TODO: Step count instead?
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
                
                //Steps
            case HKQuantityType.quantityType(forIdentifier: .stepCount):
                let stepUnit = HKUnit.count()
                self.steps = statistics.sumQuantity()?.doubleValue(for: stepUnit) ?? 0
                
                //Audio Exposure
            case HKQuantityType.quantityType(forIdentifier: .environmentalAudioExposure):
                let dbUnit = HKUnit.decibelHearingLevel()
                self.soundDb = statistics.sumQuantity()?.doubleValue(for: dbUnit) ?? 0
                self.averageSoundDb = statistics.averageQuantity()?.doubleValue(for: dbUnit) ?? 0
                
                //Respitory rate
            case HKQuantityType.quantityType(forIdentifier: .respiratoryRate):
                let respUnit = HKUnit.count() //TODO: per minute?
                self.respiratoryRate = statistics.sumQuantity()?.doubleValue(for: respUnit) ?? 0
                
              //HRV
            case HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN):
                let hRVUnit = HKUnit.second() //TODO: second -> ms?
                self.hRV = statistics.sumQuantity()?.doubleValue(for: hRVUnit) ?? 0
                
              //v02
            case HKQuantityType.quantityType(forIdentifier: .oxygenSaturation):
                let oxygenSatUnit = HKUnit.percent()
                self.oxygenSaturation = statistics.sumQuantity()?.doubleValue(for: oxygenSatUnit) ?? 0
                
            default:
                return
            }
        }
    }
    //Resets all model variables back to initial state
    func resetWorkout() {
        selectedEpisode = nil
        builder = nil
        session = nil
        workout = nil
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
        distance = 0
    }
}

// MARK: - HKWorkoutSessionDelegate

extension WorkoutManager : HKWorkoutSessionDelegate {
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        //TODO?
    }
    

    func workoutSession(
        _ episodeSession : HKWorkoutSession,
        didChangeTo toState: HKWorkoutSessionState,
        from fromState: HKWorkoutSessionState,
        date: Date) {
            DispatchQueue.main.async {
                print("Running...")
                self.running = toState == .running
            }
            
            // Wait for the session to transition states before ending the builder
            if toState == .ended {
                builder?.endCollection(withEnd: date) { (sucess,error) in
                    self.builder?.finishWorkout(){ (workout, error) in
                        DispatchQueue.main.async {
                            self.workout = workout
                        }
                    }
                }
            }
        }
}

// MARK: - HKLiveWorkoutBuilderDelegate
extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { return }
            
            let statistics = workoutBuilder.statistics(for: quantityType)
            
            //update the published values.
            updateForStatistics(statistics)
        }
    }
    
}














