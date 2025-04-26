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
    
    // MARK: - Properties (data)
    private var events: [Event] = []
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        // Register original cell
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
        // Do any additional setup after loading the view.

        title = "Calendar"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor.white
        
//        setupTextLabel()
//        setupCollectionView()
    }
    
    // MARK: - Set Up Views
    
    private func setupCollectionView() {
        collectionView.backgroundColor = UIColor.gray

        let padding: CGFloat = 24   // Use this constant when configuring constraints

        // TODO: Set Up CollectionView
                
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        refreshControl.addTarget(self, action: #selector(fetchPosts), for: .valueChanged)
//        collectionView.refreshControl = refreshControl
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupTextLabel() {
        textLabel.text = "Here"
        textLabel.font = UIFont.boldSystemFont(ofSize: 20)
        textLabel.textColor = UIColor.black
        
        view.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

}

// MARK: - UICollectionViewDelegate

extension CalendarVC: UICollectionViewDelegate { }

// MARK: - UICollectionViewDataSource

extension CalendarVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: Return the cells for each section
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.reuse, for: indexPath) as? DateCollectionViewCell else {return UICollectionViewCell()}
        
        return cell

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: Return the number of rows for each section
        return 5
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // TODO: Return the number of sections in this table view
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // TODO: Return the inset for the spacing between the two sections

//        return UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0) // Replace this line
        return UIEdgeInsets()
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension CalendarVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = collectionView.frame.width / 7 - 8
        return CGSize(width: size, height: 150)
    }

}
