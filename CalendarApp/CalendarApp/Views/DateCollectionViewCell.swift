//
//  DateCell.swift
//  CalendarApp
//
//  Created by Library User on 4/26/25.
//

import Foundation
import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties (view)
    private let dateLabel = UILabel()
    
    // MARK: - Properties (data)
    static let reuse: String = "DateCellReuse"
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        setupDateLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(calDay: CalendarDay) {
        dateLabel.text = "\(calDay.date)"
    }
    
    func configureEmpty() {
        dateLabel.text = ""
    }
    
    // MARK: - Set Up Views
    private func setupDateLabel() {
        dateLabel.text = "1"
        dateLabel.font = UIFont.boldSystemFont(ofSize: 20)
        dateLabel.textColor = UIColor.white
        
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
}
