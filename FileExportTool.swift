//
//  FileExportTool.swift
//  MyEpisodeCompanion
//
//  Created by Tanner Brown on 4/28/22.
//

import Foundation


func createCSV() {
    
    createCoreDataCSV()
    
    
    
}

func createCoreDataCSV(){
    
    var csvString = "\("Name"),\("Description"),\("State Description"),\("Response Description"),\("Color")\n\n"
    
    EmotionConstants.Cores.getAll().forEach{core in
        csvString = csvString.appending("\(core.name),\(core.description),\(core.stateDescription),\(core.responseDescription),\(core.color)\n")
    }
    
    //let fileManager = FileManager.default
    do{
        //let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
        //let fileURL = path.appendingPathComponent("CoreEmotions.csv")
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = paths[0].appendingPathComponent("CoreEmotions.csv")
        
        try csvString.write(to: url, atomically: true, encoding: .utf8)
        print("Core CSV Created @ \(url)")
        
    }catch{
        print("Error creating core csv file")
    }
    
}
