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
        setupEndTimeLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(event: Event) {
        titleLabel.text = event.title
        recurrenceLabel.text = event.recurrence
        startTimeLabel.text = event.startTimeFrame
        endTimeLabel.text = event.endTimeFrame
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
            recurrenceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            recurrenceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2)
        ])
    }
    
    private func setupEndTimeLabel() {
        endTimeLabel.font = UIFont.boldSystemFont(ofSize: 18)
        endTimeLabel.textColor = UIColor.black
        
        contentView.addSubview(endTimeLabel)
        endTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            endTimeLabel.leadingAnchor.constraint(equalTo: startTimeLabel.trailingAnchor, constant: 5),
            endTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2)
        ])
    }
    
    private func setupStartTimeLabel() {
        startTimeLabel.font = UIFont.boldSystemFont(ofSize: 18)
        startTimeLabel.textColor = UIColor.black
        
        contentView.addSubview(startTimeLabel)
        startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startTimeLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 100),
            startTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2)
        ])
    }
}
