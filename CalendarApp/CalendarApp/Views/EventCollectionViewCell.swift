//
//  EventCollectionViewCell.swift
//  CalendarApp
//
//  Created by Library User on 5/2/25.
//

import Foundation
import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties (view)
    private let titleLabel = UILabel()
    private let recurrenceLabel = UILabel()
    private let startTimeLabel = UILabel()
    private let endTimeLabel = UILabel()
    
    // MARK: - Properties (data)
    static let reuse: String = "EventCellReuse"
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        setupTitleLabel()
        setupRecurrenceLabel()
        setupStartTimeLabel()
//        setupEndTimeLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(event: Event) {
        titleLabel.text = event.title
        recurrenceLabel.text = event.recurrence
        startTimeLabel.text = "\(formatDate(input: event.startTimeFrame)) - \(formatDate(input: event.endTimeFrame))"
//        endTimeLabel.text =
    }
    
    func configureEmpty() {
        titleLabel.text = ""
    }
    
    // MARK: - Set Up Views
    private func setupTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor.black
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    private func setupRecurrenceLabel() {
        recurrenceLabel.font = UIFont.systemFont(ofSize: 16)
        recurrenceLabel.textColor = UIColor.gray
        
        contentView.addSubview(recurrenceLabel)
        recurrenceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            recurrenceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 250),
            recurrenceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            recurrenceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4)
        ])
    }
    
    private func setupEndTimeLabel() {
        endTimeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        endTimeLabel.textColor = UIColor.gray
        
        contentView.addSubview(endTimeLabel)
        endTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            endTimeLabel.leadingAnchor.constraint(equalTo: startTimeLabel.trailingAnchor, constant: 10),
            endTimeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
        ])
    }
    
    private func setupStartTimeLabel() {
        startTimeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        startTimeLabel.textColor = UIColor.gray
        
        contentView.addSubview(startTimeLabel)
        startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startTimeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            startTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
    }
    
    @objc private func formatDate(input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        if let date = inputFormatter.date(from: input) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM d yyyy"
            return outputFormatter.string(from: date)
        }

        return input  // fallback in case parsing fails
    }
}
