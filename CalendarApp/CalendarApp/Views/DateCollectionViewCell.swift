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
        
        backgroundColor = UIColor.white
        layer.cornerRadius = 16
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Function for the cell that, upon receiving the data, maps the data to the cell's views
//    func configure(post: Post) {
//        likesLabel.text = "\(post.likes.count) likes"
//        recencyLabel.text = post.time.convertToAgo()
//        postBodyLabel.text = post.messageclCo//"
//    }
    
    // MARK: - Set Up Views
    private func setupDateLabel() {
        dateLabel.text = "1"
        dateLabel.font = UIFont.boldSystemFont(ofSize: 10)
        dateLabel.textColor = UIColor.black
        
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22)
        ])
    }
}
