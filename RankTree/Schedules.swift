//
//  Schedules.swift
//  RankTree
//
//  Created by Chujay on 21/03/2017.
//  Copyright © 2017 Chujay. All rights reserved.
//

enum Level {
    case low
    case medium
    case high
}

struct Schedules{
    
    var title: String
    var time: String
    let location: String?
    let context: String?
    let level: Level
    
    init(title: String, time: String, location: String, context: String, level: Level) {
        self.title = title
        self.context = context
        self.level = level
        self.time = time
        self.location = location
    }
    
    init(title: String, time: String) {
        self.title = title
        self.time = time
        self.context = ""
        self.level = .medium
        self.location = nil
    }
}






