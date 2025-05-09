//
//  MonsterDetailViewModel.swift
//  DandDMonsters
//
//  Created by John Kearon on 5/9/25.
//

import Foundation

@Observable // macro that will watch objects for changes so that SwiftUI will redraw the interfaces when needed
class MonsterDetailViewModel {
    
    // Shift/Control/Click enables the creation of multiple cursors so that you can edit multiple lines at the same time
    var name: String = ""
    var size: String = ""
    var type: String = ""
    var alignment: String = ""
    var hitPoints: Int = 0
    var imageURL: String = ""

    let baseURL = "https://www.dnd5eapi.co"
    var urlString = "https://www.dnd5eapi.co/api/2014/monsters"
    var isLoading = false
    
    func getData() async {
        isLoading = true
        print("🕸️ We are accessing the url \(urlString)")
        
        // Ceate a URL
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a URL from \(urlString)")
            isLoading = false
            return
        }
        
        do {
            let configuration = URLSessionConfiguration.ephemeral // Only need emphemeral lines due to bug in Xcode 16.3 Simulator w/URL
            let session = URLSession(configuration: configuration)
            let (data, _) = try await session.data(from: url)  // if this dow not work then it will be caught and the catch logic will be used
            
            guard let monsterDetail = try? JSONDecoder().decode(MonsterDetail.self, from: data) else {
                print("😡 JSON ERROR: Could not decode returned JSON data at \(urlString)")
                isLoading = false
                return
            }
            print("😎 JSON returned! results containing: \(monsterDetail.name) from MonsterDetail")
 
            // Pro Tip:
            // If you've got an async function that might take some time, but it's updating values that impact the user interface, push them to the main thread using @MianActor. There are many ways to do this, but TASK { @MainActor in works well

            Task {@MainActor in  // forces this code to run on the main thread
                self.name = monsterDetail.name  // self.name in this program returned.name (from JSON) defined in MonsterDetail struct
                self.size = monsterDetail.size
                self.type = monsterDetail.type
                self.alignment = monsterDetail.alignment
                self.hitPoints = monsterDetail.hit_points
                self.imageURL = baseURL + (monsterDetail.image ?? "")
                isLoading = false
            }

        } catch {
            isLoading = false
            print("😡 JSON ERROR: Could not get data from \(urlString) \(error.localizedDescription)")
        }
        
    }
}
