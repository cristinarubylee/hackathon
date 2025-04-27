//
//  CalendarVC.swift
//  CalendarApp
//
//  Created by Library User on 4/26/25.
//

import Foundation
import UIKit

class CalendarVC: UIViewController {
    
    // MARK: - Properties (view)
    private var collectionView: UICollectionView!
    private var textLabel = UILabel()
    private var stackView = UIStackView()
    
    // MARK: - Properties (data)
    // Dummy Data
    private var days: [CalendarDay] = (1...31).map { CalendarDay(date: $0, events: []) }
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: DateCollectionViewCell.reuse)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Month"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor.white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        setupDaysOfWeek()
        setupCollectionView()
    }
    
    // MARK: - Set Up Views
    
    private let daysOfWeekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    private func setupCollectionView() {
        collectionView.backgroundColor = UIColor.black
                        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: daysOfWeekStackView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupDaysOfWeek() {
        let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        
        for day in days {
            let label = UILabel()
            label.text = day
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 14)
            
            daysOfWeekStackView.addArrangedSubview(label)
        }
        
        daysOfWeekStackView.backgroundColor = UIColor.black
        view.addSubview(daysOfWeekStackView)
        daysOfWeekStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            daysOfWeekStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            daysOfWeekStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            daysOfWeekStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            daysOfWeekStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

// MARK: - UICollectionViewDelegate

extension CalendarVC: UICollectionViewDelegate { }

// MARK: - UICollectionViewDataSource

extension CalendarVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.reuse, for: indexPath) as? DateCollectionViewCell else { return UICollectionViewCell() }
            
            let index = indexPath.section * 7 + indexPath.row
            
            if index < days.count {
                cell.configure(calDay: days[index])
            } else {
                cell.configureEmpty()
            }
            
            return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension CalendarVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 2
        let itemsPerRow: CGFloat = 7

        let totalPadding = padding * (itemsPerRow - 1)
        let individualCellWidth = (collectionView.frame.width - totalPadding) / itemsPerRow

        return CGSize(width: individualCellWidth, height: 100)
    }

}
