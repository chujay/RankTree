//
//  Data.swift
//  RankTree
//
//  Created by Chujay on 28/03/2017.
//  Copyright © 2017 Chujay. All rights reserved.
//

import Foundation

class Data {

    static var scheduleArray: [Schedules] = []

    var startTime = [
        [2017, 3, 28, 2, 51],
        [2017, 3, 26, 9, 21],
        [2017, 3, 27, 10, 27],
        [2017, 3, 28, 8, 8],
        [2017, 3, 26, 8, 12],
        [2017, 3, 27, 1, 20],
        [2017, 3, 27, 5, 5],
        [2017, 3, 28, 0, 47],
        [2017, 3, 26, 2, 46],
        [2017, 3, 28, 10, 41]
    ]
    
    var endTime = [
        [2017, 3, 28, 2, 11],
        [2017, 3, 27, 12, 11],
        [2017, 3, 29, 14, 29],
        [2017, 3, 30, 11, 53],
        [2017, 3, 26, 8, 27],
        [2017, 3, 27, 3, 17],
        [2017, 3, 28, 7, 27],
        [2017, 3, 29, 2, 34],
        [2017, 3, 26, 6, 28],
        [2017, 3, 28, 11, 8]
        
    ]
    
    func produceData() {

        var scheduleData: [Schedules] = []
        var count = 0
        while count < 3 {
            
            let titleName = "Process\(count)"
            let context = ""
            let level = "Median level"

            let schedule = Schedules(title: titleName, startTime: startTime[count], endTime: endTime[count], context: context, level: level)
            scheduleData.append(schedule)
            count += 1
        }
        Data.scheduleArray = scheduleData
    }

}
