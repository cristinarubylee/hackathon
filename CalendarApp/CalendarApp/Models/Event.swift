//
//  Event.swift
//  CalendarApp
//
//  Created by Library User on 4/26/25.
//

import Foundation

struct Event: Codable {
    let title: String
    let recurrence: String
    let startTimeFrame: String  // Keep as String unless you want to parse Date manually
    let endTimeFrame: String
    let timespan: [Timespan]
    let category: [Int]?  // Optional

    struct Timespan: Codable {
        let dayOfWeek: String
        let startTime: String
        let endTime: String
    }

    enum CodingKeys: String, CodingKey {
        case title
        case recurrence
        case startTimeFrame = "start_time_frame"
        case endTimeFrame = "end_time_frame"
        case timespan
        case category
    }
}
