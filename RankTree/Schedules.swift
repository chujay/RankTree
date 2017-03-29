//
//  Schedules.swift
//  RankTree
//
//  Created by Chujay on 21/03/2017.
//  Copyright © 2017 Chujay. All rights reserved.
//

struct Schedules {

    var title: String
    var startTime: [Int]
    var endTime: [Int]
    let context: String
    let level: String

    init(title: String, startTime: [Int], endTime: [Int], context: String, level: String) {
        self.title = title
        self.context = context
        self.level = level
        self.startTime = startTime
        self.endTime = endTime
    }

    func toAnyObject() -> Any {
        return [
            "title": self.title,
            "description": self.context,
            "startTime": self.startTime,
            "endTime": self.endTime,
            "level": self.level
        ]
    }
}
