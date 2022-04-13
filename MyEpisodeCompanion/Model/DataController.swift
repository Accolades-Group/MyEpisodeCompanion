//
//  DataController.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 3/29/22.
//

import CoreData
import Foundation
import SwiftUI


class DataController : ObservableObject {
    
    let container = NSPersistentContainer(name: "HealthHistory")
    //Shared instance
    static let shared = DataController()
    
    init() {
        container.loadPersistentStores { description, error in
            
            if let error = error {
                print("Core data failed to load: \(error.localizedDescription)")
            }
            
        }
    }
    
}
