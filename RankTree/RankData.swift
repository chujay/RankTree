//
//  RankData.swift
//  RankTree
//
//  Created by Chujay on 28/03/2017.
//  Copyright © 2017 Chujay. All rights reserved.
//

import Foundation

class RankData {
    
    typealias SplitDayType = [String: [String: [String:[Schedules]]]]
    
    private func splitDay(rankArray: [Schedules]) -> SplitDayType {
        
        var groupEntry = [String: [String: [String:[Schedules]]]]()
        
        for object in rankArray {
            let yearEnd = object.endTime[0] as! UInt32
            let monthEnd = object.endTime[1] as! UInt32
            let dayEnd = object.endTime[2] as! UInt32
            
            let yearStart = object.startTime[0] as! UInt32
            let monthStart = object.startTime[1] as! UInt32
            let dayStart = object.startTime[2] as! UInt32
            
            var yearConut = yearEnd - yearStart
            var monthCount = monthEnd - monthStart
            var dayCount = (dayEnd - dayStart)
            if yearStart < yearEnd{
                yearConut = yearEnd - yearStart
                monthCount = yearConut + 12
                dayCount = (dayEnd - dayStart) + monthCount * 30
            }else if monthStart < monthEnd{
                monthCount = monthEnd - monthStart
                dayCount = (dayEnd - dayStart) + monthCount * 30
            }
            for yr in 0...yearConut{
                for mth in 0...monthCount{
                    for dy in 0...dayCount{
                        let groupInKey = String(describing: object.startTime[0] as! UInt32 + yr)
                        let monthInKey = String(describing: object.startTime[1] as! UInt32 + (mth % 12))
                        let dayInKey = String(describing: object.startTime[2] as! UInt32 + (dy % 30))
                        if groupEntry[groupInKey] != nil {
                            if groupEntry[groupInKey]![monthInKey] != nil {
                                if groupEntry[groupInKey]![monthInKey]?[dayInKey] != nil {
                                    groupEntry[groupInKey]![monthInKey]![dayInKey]!.append(object)
                                }else {
                                    groupEntry[groupInKey]![monthInKey]![dayInKey] = [object]
                                }
                            }else {
                                groupEntry[groupInKey]?[monthInKey] = [:]
                                if groupEntry[groupInKey]?[monthInKey]?[dayInKey] != nil {
                                    groupEntry[groupInKey]?[monthInKey]?[dayInKey]?.append(object)
                                }else {
                                    groupEntry[groupInKey]?[monthInKey]?[dayInKey]? = [object]
                                    
                                }
                            }
                            
                        }else {
                            groupEntry[groupInKey] = [:]
                            if groupEntry[groupInKey]![monthInKey] != nil {
                                if groupEntry[groupInKey]![monthInKey]?[dayInKey] != nil {
                                    groupEntry[groupInKey]![monthInKey]?[dayInKey]!.append(object)
                                }else {
                                    groupEntry[groupInKey]![monthInKey]![dayInKey]! = [object]
                                }
                            }else {
                                groupEntry[groupInKey]?[monthInKey] = [:]
                                if groupEntry[groupInKey]?[monthInKey]?[dayInKey] != nil {
                                    groupEntry[groupInKey]?[monthInKey]?[dayInKey]?.append(object)
                                }else {
                                    groupEntry[groupInKey]?[monthInKey]?[dayInKey] = [object]
                                    
                                }
                            }
                        }
                    }
                    
                }
            }
        }
        return groupEntry
    }
    func rankTime(year: String, month : String, day: String) -> [Schedules]{
        
        let timeDictionary = splitDay(rankArray: Data().produceData())
        let timeObject = timeDictionary[year]?[month]?[day]
        let result = timeObject?.sorted(by: { obj1, obj2 in
            
            if obj2.startTime[0] as! UInt32 > obj1.startTime[0] as! UInt32 {
                return true
            } else if obj2.startTime[1] as! UInt32 > obj1.startTime[1] as! UInt32 {
                return true
            } else if obj2.startTime[2] as! UInt32 > obj1.startTime[2] as! UInt32 {
                return true
            }else {
                return false
            }
        })
        return result!
    }
}





