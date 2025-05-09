//
//  Monster.swift
//  DandDMonsters
//
//  Created by John Kearon on 5/8/25.
//

import Foundation

struct Monster: Codable, Identifiable {
 // variable names must exactly match the key names in the JSON file
    let id = UUID().uuidString
    var index: String
    var name: String
    var url: String
    
    enum CodingKeys: CodingKey {
        case index, name, url  // these are the 3 fields we want to decode
    }
}
