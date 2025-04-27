//
//  Date.swift
//  CalendarApp
//
//  Created by Library User on 4/26/25.
//

import Foundation

struct CalendarDay : Codable {
    let date: Int
    let events: [Event]
}
