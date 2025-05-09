//
//  MonsterDetail.swift
//  DandDMonsters
//
//  Created by John Kearon on 5/9/25.
//

import Foundation

struct MonsterDetail: Codable {
    // Shift/Control/Click enables the creation of multiple cursors so that you can edit multiple lines at the same time
    var name: String = ""
    var size: String = ""
    var type: String = ""
    var alignment: String = ""
    var hit_points: Int = 0
    var image: String? = ""
}
