//
//  EpisodeManager.swift
//  MyEpisodeCompanion WatchKit Extension
//
//  Created by Tanner Brown on 3/21/22.
//

import Foundation
import HealthKit
import AVFoundation
import Combine

class WorkoutManager : NSObject, ObservableObject {
    
    let audioSession = AVAudioSession.sharedInstance()
    var audioRecorder : AVAudioRecorder = AVAudioRecorder()//TODO: URL & Settings
    
    func initAudio() {
        
        do {
            
            let recordSettings = [
                AVSampleRateKey : NSNumber(value: Float(44100.0) as Float),
                AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC) as Int32),
                AVNumberOfChannelsKey : NSNumber(value: 1 as Int32),
                AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue) as Int32)
            ]
            //let fileManager = FileManager.default
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentDirectory = urls[0] as URL
            let soundURL = documentDirectory.appendingPathComponent("sound.m4a")
            
            try audioSession.setCategory(.playAndRecord) //TODO: set to .record
            audioRecorder = try AVAudioRecorder(url: soundURL, settings: recordSettings) //TODO: URL & Settings
            
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            try audioSession.setActive(true)
            audioRecorder.isMeteringEnabled = true
        } catch let err {
            print(err)
        }

    }
    
    func timerTick() {
        //checkAudio()
        
    }
    
    func checkAudio(){
        if(!audioRecorder.isRecording){
            initAudio()
        }
        let correction : Float = 100
        audioRecorder.updateMeters()
        self.soundDb = Double(audioRecorder.averagePower(forChannel: 0) + correction)//TODO: Peak power or average power?
    }
    
    
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
    
    @Published var timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    var subscription : Cancellable?
    
    /*
    func tick(){
        
        guard let id = HKSampleType.quantityType(forIdentifier: .environmentalAudioExposure) else { return }
        
        let now = Date.now
        
        let freq = HKQuantity(unit: .hertz(), doubleValue: 250.0)
        
        let leftSensitivity = HKQuantity(unit: HKUnit.decibelHearingLevel(), doubleValue: 34.0)
        let rightSensitivity = HKQuantity(unit: .decibelHearingLevel(), doubleValue: 27.0)
        

        
       // let sensitiityPoint = HKAudiogramSensitivityPoint(frequency: <#T##HKQuantity#>, leftEarSensitivity: <#T##HKQuantity?#>, rightEarSensitivity: <#T##HKQuantity?#>)
        
        //let audioSample = HKAudiogramSample(

       // let pred = HKQuery.predicateForSamples(
       //     withStart: NSCalendar.current.date(byAdding: .hour, value: -24, to: now),
       //     end: now)
        
       /* let query = HKSampleQuery(sampleType: id, predicate: pred, limit: 0, sortDescriptors: .none){ (sampleQuery, results, error) -> Void in
            
            if let results = results {
                
                results.forEach{ sample in
                    
                    if let unwrappedsample = sample as? HKDiscreteQuantitySample {
                        let sound = unwrappedsample.mostRecentQuantity
                        print("Updated")
                        print("\(sound) db")
                        print("Date: \(unwrappedsample.mostRecentQuantityDateInterval.end)")
                        print("---------------------")

                    }
                    
                    
                }
               */
//                if let last = results.last as? HKDiscreteQuantitySample {
//                    let soundlast = last.mostRecentQuantity
//                    self.soundDb = soundlast.doubleValue(for: .decibelAWeightedSoundPressureLevel())
//                    print("updated:  \(soundlast)  " )
//                    print(last.mostRecentQuantityDateInterval.end
//                }
                
                
                
                
                
 //           }
            
 //       }
        
      //  healthStore.execute(query)
    }
    */
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    func startEpisode(workoutType: HKWorkoutActivityType){
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .unknown //TODO:
        
        //timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
        
        let runLoop = RunLoop.main
        subscription = runLoop.schedule(after: runLoop.now, interval: .seconds(5) , tolerance: .milliseconds(100)) {
            //what happens when timer is fired
            print("Timer fired")
            self.checkAudio()
        }
        
        

        
        initAudio()
                
        
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
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: nil)
        let stepType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        
        let soundType = HKObjectType.quantityType(forIdentifier: .environmentalAudioExposure)!
        

        let stepsQuery = HKAnchoredObjectQuery(type: stepType, predicate: predicate, anchor: nil, limit: 0){(query, samples, deletedObjects, anchor, error) -> Void in
            
            //Handle when the query first returns results
            //TODO: Whatever you want with samples (not you are not on the main thread)

            
            
            if !samples!.isEmpty {
                print("Steps Query")
            }
            
        }
        
        stepsQuery.updateHandler = { (query, samples, deletedObjects, anchor, error) -> Void in
            
            //Handle update notifications after the query has initially run
            // TODO: do whatever you want with samples (note you are not on the main thread)
            print("Update Handle")
            print(samples?.debugDescription as Any)
            
        }
        
        let soundQuery = HKAnchoredObjectQuery(type: soundType, predicate: predicate, anchor: nil, limit: 0){(query, samples, deletedObjects, anchor, error) -> Void in
            
            //Handle when the query first returns results
            //TODO: Whatever you want with samples (not you are not on the main thread)

            
            
            if !samples!.isEmpty {
                print("sound Query")
            }
            
        }
        
        soundQuery.updateHandler = { (query, samples, deletedObjects, anchor, error) -> Void in
            
            //Handle update notifications after the query has initially run
            // TODO: do whatever you want with samples (note you are not on the main thread)
            print("Update Handle")
            
        }
        
        healthStore.execute(stepsQuery)
        healthStore.execute(soundQuery)
        
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
            HKQuantityType.quantityType(forIdentifier: .vo2Max)!, //vo2Max TODO: Can we retrieve this? probs not? Cardio Fitness?
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
        timer.upstream.connect().cancel()
        subscription?.cancel()
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
        
//print(statistics.quantityType.identifier.debugDescription)
        
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
            
//            print(statistics!.debugDescription)
            
            //update the published values.
            
            updateForStatistics(statistics)
            
        }
    }
}














