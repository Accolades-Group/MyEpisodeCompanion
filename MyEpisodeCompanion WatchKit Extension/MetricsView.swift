//
//  MetricsView.swift
//  MyEpisodeCompanion WatchKit Extension
//
//  Created by Tanner Brown on 3/21/22.
//

import SwiftUI
import HealthKit

struct MetricsView: View {
    @EnvironmentObject var episodeManager : WorkoutManager
    
    var body: some View {
        TimelineView(
            MetricsTimelineSchedule(
                from: episodeManager.builder?.startDate ?? Date()
            )
        ) { context in
            
            ScrollView(.vertical){
                
            
            VStack(alignment: .leading){
                
                //Elapsed Time
                
                ElapsedTimeView(
                    elapsedTime: episodeManager.builder?.elapsedTime ?? 0,
                    showSubseconds: context.cadence == .live
                )
                .foregroundColor(.yellow)
                //            //Cals
                //            Text(Measurement(
                //                value: episodeManager.activeEnergy,
                //                unit: UnitEnergy.kilocalories)
                //                .formatted(
                //                    .measurement(
                //                        width: .abbreviated,
                //                        usage: .workout,
                //                        numberFormatStyle: .number.precision(.fractionLength(0))
                //                    )
                //                )
                //            )
                //BPM
                
                //Heart Rate
                Text(
                    episodeManager.heartRate
                        .formatted(
                            .number.precision(.fractionLength(0))
                        )
                    + " bpm"
                ).foregroundColor(.red)
                
                //Respitory Rate TODO: this
                Text(
                    episodeManager.respiratoryRate.formatted(
                        .number.precision(.fractionLength(0))
                    )
                    + " br/pm"
                ).foregroundColor(.blue)
                
                //Steps
                Text(
                    episodeManager.steps.formatted(
                        .number.precision(.fractionLength(0))
                    )
                    + " steps"
                )
                
                //Text()
                
                //Distance
                            Text(
                                Measurement(
                                    value: episodeManager.distance,
                                    unit: UnitLength.meters
                                ).formatted(
                                    .measurement(
                                        width: .abbreviated,
                                        usage: .road
                                    )
                                )
                            )
                
                //Noise
                Text(
                    episodeManager.soundDb.formatted(
                        .number.precision(.fractionLength(0))
                    )
                    + " dB"
                ).foregroundColor(.yellow)
                
                
                //HRV
                Text(
                    episodeManager.hRV.formatted(
                        .number.precision(.fractionLength(0))
                    )
                    + " ms"
                )
                
                //o2Sat
                Text(
                    episodeManager.oxygenSaturation.formatted(
                        .number.precision(.fractionLength(0))
                    )
                    + " %"
                )
            }
            .font(.system(.title, design: .rounded)
                .monospacedDigit()
                  //.lowercaseSmallCaps()
            )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .ignoresSafeArea(edges: .bottom)
            .scenePadding()
        }
    }
}

private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate : Date
    init(from startDate: Date){
        self.startDate = startDate
    }
    
    func entries(from startDate: Date, mode: TimelineScheduleMode) ->
    PeriodicTimelineSchedule.Entries {
        PeriodicTimelineSchedule(
            from: self.startDate,
            by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0)
        ).entries(
            from: startDate,
            mode: mode)
    }
}



struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
    }
}
