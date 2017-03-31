//
//  Schedules.swift
//  RankTree
//
//  Created by Chujay on 21/03/2017.
//  Copyright © 2017 Chujay. All rights reserved.
//

struct Schedules: Equatable {

    var title: String = " title "
    var startTime: [Int] = [0, 0, 0, 0, 0]
    var endTime: [Int] = [0, 0, 0, 0, 0]
    var context: String = " "
    var level: String = "Medium level"

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

    static func == (lhs: Schedules, rhs: Schedules) -> Bool {
        return lhs.title == rhs.title && lhs.context == rhs.context && lhs.level == rhs.level && lhs.startTime == rhs.startTime && lhs.endTime == rhs.endTime
    }

}
