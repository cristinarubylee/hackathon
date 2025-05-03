//
//  Timespan.swift
//  CalendarApp
//
//  Created by Library User on 5/2/25.
//

import Foundation

struct Timespan: Codable {
    let dayOfWeek: String
    let startTime: String
    let endTime: String

    enum CodingKeys: String, CodingKey {
        case dayOfWeek = "day_of_week"
        case startTime = "start_time"
        case endTime = "end_time"
    }
}
