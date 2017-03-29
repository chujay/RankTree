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

    func splitDay(rankArray: [Schedules]) -> SplitDayType {

        var groupEntry = [String: [String: [String: [Schedules]]]]()

        for object in rankArray {
            let yearEnd = object.endTime[0]
            let monthEnd = object.endTime[1]
            let dayEnd = object.endTime[2]
            let yearStart = object.startTime[0]
            let monthStart = object.startTime[1]
            let dayStart = object.startTime[2]

            var yearCount = yearEnd - yearStart
            var monthCount = monthEnd - monthStart
            var dayCount = dayEnd - dayStart
            for yr in 0...yearCount {
                for mth in 0...monthCount {
                    for dy in 0...dayCount {

                        var groupInKey: String {
                            guard
                                let time = object.startTime[0] as? Int
                                else { return " "}
                            return String(time + yr)
                        }
                        var monthInKey: String {
                            guard
                                let time = object.startTime[1] as? Int
                                else { return " "}
                            return String(time + (mth % 12))
                        }
                        var dayInKey: String {
                            guard
                                let time = object.startTime[2] as? Int
                                else { return " "}
                            return String(time + (dy % 30))
                        }
                        if groupEntry[groupInKey] != nil {
                            if groupEntry[groupInKey]![monthInKey] != nil {
                                if groupEntry[groupInKey]![monthInKey]?[dayInKey] != nil {
                                    groupEntry[groupInKey]![monthInKey]![dayInKey]!.append(object)
                                } else {
                                    groupEntry[groupInKey]![monthInKey]![dayInKey] = [object]
                                }
                            } else {
                                groupEntry[groupInKey]?[monthInKey] = [:]
                                if groupEntry[groupInKey]?[monthInKey]?[dayInKey] != nil {
                                    groupEntry[groupInKey]?[monthInKey]?[dayInKey]?.append(object)
                                } else {
                                    groupEntry[groupInKey]?[monthInKey]?[dayInKey]? = [object]

                                }
                            }

                        } else {
                            groupEntry[groupInKey] = [:]
                            if groupEntry[groupInKey]![monthInKey] != nil {
                                if groupEntry[groupInKey]![monthInKey]?[dayInKey] != nil {
                                    groupEntry[groupInKey]![monthInKey]?[dayInKey]!.append(object)
                                } else {
                                    groupEntry[groupInKey]![monthInKey]![dayInKey]! = [object]
                                }
                            } else {
                                groupEntry[groupInKey]?[monthInKey] = [:]
                                if groupEntry[groupInKey]?[monthInKey]?[dayInKey] != nil {
                                    groupEntry[groupInKey]?[monthInKey]?[dayInKey]?.append(object)
                                } else {
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
    func rankTime(year: String, month: String, day: String) -> [Schedules] {

        let timeDictionary = splitDay(rankArray: Data.scheduleArray)

        let timeObject = timeDictionary[year]?[month]?[day]

        let result = timeObject?.sorted(by: { obj1, obj2 in

            if obj2.startTime[0] > obj1.startTime[0] {
                return true
            } else if obj2.startTime[1] > obj1.startTime[1] {
                return true
            } else if obj2.startTime[2] > obj1.startTime[2] {
                return true
            } else {
                return false
            }
        })
        return result!
    }
}
