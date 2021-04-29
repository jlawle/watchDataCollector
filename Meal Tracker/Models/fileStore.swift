//
//  fileStore.swift
//  watchSensorData-v1
//
//  Created by John Lawler on 4/22/21.
//

import Foundation


public class fileStore {
    
    init() {}
    
    // function to get documents directory url
    func getURL() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                   return url
               } else {
                   fatalError("Could not create URL for specified directory!")
               }
    }
    
    
    // encode and store data
    func saveToFile (_ dataToEncode: fileData, fileName: String){
        
        let url = getURL().appendingPathComponent(fileName, isDirectory: false)
                
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(dataToEncode)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    
    
    // Check if a file exists
    func fileExists(_ fileName: String) -> Bool {
        let url = getURL().appendingPathComponent(fileName, isDirectory: false)
        return FileManager.default.fileExists(atPath: url.path)
    }

}
    
    
    

