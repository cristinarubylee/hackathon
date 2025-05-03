//
//  NetworkManager.swift
//  CalendarApp
//
//  Created by Library User on 5/2/25.
//

import Foundation
import Alamofire

class NetworkManager {
    
    /// Shared singleton instance
    static let shared = NetworkManager()
    private init() { }
    
    /// Base URL
    private let baseURL = "http://127.0.0.1:5000"

    /// Fetch all events on a given date (GET with query param)
    func fetchEvents(for date: String, completion: @escaping ([Event]) -> Void) {
        let url = "\(baseURL)/api/events/date/"
        let parameters: [String: String] = ["date": date]

        AF.request(
            url,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default
        )
        .validate()
        .responseDecodable(of: EventResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(data.events)
            case .failure(let error):
                print("Error fetching events: \(error.localizedDescription)")
                completion([])
            }
        }
    }

    /// Fetch a single event by ID (GET with path param)
    func fetchEvent(by id: Int, completion: @escaping (Event?) -> Void) {
        let url = "\(baseURL)/api/events/\(id)/"

        AF.request(url)
            .validate()
            .responseDecodable(of: Event.self) { response in
                switch response.result {
                case .success(let event):
                    completion(event)
                case .failure(let error):
                    print("Error fetching event by ID: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }
}

struct EventResponse: Codable {
    let events: [Event]
}
