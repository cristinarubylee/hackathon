//import UIKit
//
//class BottomSheetViewController: UIViewController {
//    var eventsCollectionView: UICollectionView!
//    var events: [Event] = [
//        Event(id: 1, title: "Dummy1", recurrence: "Dummy", startTimeFrame: "Dummy", endTimeFrame: "Dummy", timespan: [], category: []),
//        Event(id: 2, title: "Dummy2", recurrence: "Dummy", startTimeFrame: "Dummy", endTimeFrame: "Dummy", timespan: [], category: []),
//        Event(id: 3, title: "Dummy3", recurrence: "Dummy", startTimeFrame: "Dummy", endTimeFrame: "Dummy", timespan: [], category: [])
//    ]  // Simulate event titles
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//
//        setupButtons()
//        setupEventsCollectionView()
//    }
//
//    func setupButtons() {
//        let buttonTitles = ["Tasks", "Events", "Categories"]
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.spacing = 10
//        stackView.distribution = .fillEqually
//
//        for title in buttonTitles {
//            let button = UIButton(type: .system)
//            button.setTitle(title, for: .normal)
//            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//            stackView.addArrangedSubview(button)
//        }
//
//        view.addSubview(stackView)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
//            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//        ])
//    }
//
//    func setupEventsCollectionView() {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = 12
//        layout.itemSize = CGSize(width: view.bounds.width - 40, height: 80)
//
//        eventsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        eventsCollectionView.backgroundColor = .clear
//        eventsCollectionView.delegate = self
//        eventsCollectionView.dataSource = self
//        eventsCollectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: EventCollectionViewCell.reuse)
//
//        view.addSubview(eventsCollectionView)
//        eventsCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            eventsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
//            eventsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            eventsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            eventsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
//        ])
//    }
//
//    @objc func buttonTapped(_ sender: UIButton) {
//        guard let title = sender.titleLabel?.text else { return }
//
//        eventsCollectionView?.removeFromSuperview() // Remove previous collectionView if any
//
//        if title == "Events" {
//            setupEventsCollectionView()        // Step 1: set up the view
//            fetchEvents()                      // Step 2: fetch data and reload
//        }
//    }
//
//    @objc private func fetchEvents() {
//        let today = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let dateString = formatter.string(from: today)
//
//        NetworkManager.shared.fetchEvents(for: dateString) { [weak self] events in
//            guard let self else { return }
//
//            DispatchQueue.main.async {
//                self.events = events
//                self.eventsCollectionView.reloadData()
//            }
//        }
//    }
//}
//
//extension BottomSheetViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return events.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCollectionViewCell.reuse, for: indexPath) as! EventCollectionViewCell
//        cell.configure(event: events[indexPath.item])
//        return cell
//    }
//}

import UIKit

class BottomSheetViewController: UIViewController {
    var eventsCollectionView: UICollectionView!
    var events: [Event] = []  // Start with an empty list

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupButtons()
        // Don't set up eventsCollectionView here
    }

    func setupButtons() {
        let buttonTitles = ["Tasks", "Events", "Categories"]
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually

        for title in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    func setupEventsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: view.bounds.width - 40, height: 80)

        eventsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        eventsCollectionView.backgroundColor = .clear
        eventsCollectionView.delegate = self
        eventsCollectionView.dataSource = self
        eventsCollectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: EventCollectionViewCell.reuse)

        view.addSubview(eventsCollectionView)
        eventsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eventsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            eventsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            eventsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            eventsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }

    @objc func buttonTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }

        eventsCollectionView?.removeFromSuperview()

        if title == "Events" {
            setupEventsCollectionView()
            fetchSingleEvent()  // ✅ Replaces fetchEvents()
        }
    }

    @objc private func fetchSingleEvent() {
        let dummyId = 1

        NetworkManager.shared.fetchEvent(by: dummyId) { [weak self] event in
            guard let self else { return }

            DispatchQueue.main.async {
                if let event = event {
                    self.events = [event]  // ✅ Convert single event into array
                    self.eventsCollectionView.reloadData()
                } else {
                    self.events = []
                    self.eventsCollectionView.reloadData()
                }
            }
        }
    }
}

extension BottomSheetViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCollectionViewCell.reuse, for: indexPath) as! EventCollectionViewCell
        cell.configure(event: events[indexPath.item])
        return cell
    }
}
