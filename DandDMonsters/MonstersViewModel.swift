//
//  MonstersViewModel.swift
//  DandDMonsters
//
//  Created by John Kearon on 5/8/25.
//

import Foundation

@Observable // macro that will watch objects for changes so that SwiftUI will redraw the interfaces when needed
class MonstersViewModel {
    
    struct Results: Codable {
        var count: Int
        var results: [Monster]  
    }
    
    var count: Int = 0
    var monsters: [Monster] = []
    let baseURL = URL(string: "https://www.dnd5eapi.co")
    let urlString = "https://www.dnd5eapi.co/api/2014/monsters"
    
    func getData() async {
        print("🕸️ We are accessing the url \(urlString)")
        
        // Ceate a URL
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a URL from \(urlString)")
            return
        }
        
        do {
            let configuration = URLSessionConfiguration.ephemeral // Only need emphemeral lines due to bug in Xcode 16.3 Simulator w/URL
            let session = URLSession(configuration: configuration)
            let (data, _) = try await session.data(from: url)  // if this dow not work then it will be caught and the catch logic will be used
            
            guard let returned = try? JSONDecoder().decode(Results.self, from: data) else {
                print("😡 JSON ERROR: Could not decode returned JSON data at \(urlString)")
                return
            }
            print("😎 JSON returned! count: \(returned.results.count) monsters")
 
            // Pro Tip:
            // If you've got an async function that might take some time, but it's updating values that impact the user interface, push them to the main thread using @MianActor. There are many ways to do this, but TASK { @MainActor in works well

            Task {@MainActor in  // forces this code to run on the main thread
                self.count = returned.count
                self.monsters = returned.results
            }

        } catch {
            print("😡 JSON ERROR: Could not get data from \(urlString) \(error.localizedDescription)")
        }
        
        
//        let (data, _) = try await URLSession.shared.data(from: URL(string: urlString)!)
//        let results = try JSONDecoder().decode(Results.self, from: data)
//        self.count = results.count
//        self.monsters = results.monsters
    }
}
