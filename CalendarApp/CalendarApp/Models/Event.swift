//
//  Event.swift
//  CalendarApp
//
//  Created by Library User on 4/26/25.
//

import Foundation

struct Event: Codable {
    let id: Int
    let title: String
    let recurrence: String
    let startTimeFrame: String
    let endTimeFrame: String
    let timespan: [Timespan]
    let category: [Category]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case recurrence
        case startTimeFrame = "start_time_frame"
        case endTimeFrame = "end_time_frame"
        case timespan
        case category
    }
}



