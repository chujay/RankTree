//
//  Data.swift
//  RankTree
//
//  Created by Chujay on 28/03/2017.
//  Copyright © 2017 Chujay. All rights reserved.
//

import Foundation

class Data{
    
    func produceData() -> [Schedules]{
        
        var scheduleData: [Schedules] = []
        var count = 0
        while count < 10 {
            let dayStart = arc4random_uniform(3) + 26
            let hourStart = arc4random_uniform(12)
            let minStart = arc4random_uniform(59)
            
            let startTime = [2017, 3, dayStart, hourStart, minStart]
            
            let dayEnd = dayStart + arc4random_uniform(3)
            let hourEnd = hourStart + arc4random_uniform(5)
            let minEnd = arc4random_uniform(59)
            
            let endTime = [2017, 3, dayEnd, hourEnd, minEnd]
            let titleName = "Process\(count)"
            let context = ""
            let level = "Median level"
            
            let schedule = Schedules(title: titleName, startTime: startTime, endTime: endTime, context: context, level: level)
            scheduleData.append(schedule)
            count += 1
        }
        return scheduleData
    }
    
}

