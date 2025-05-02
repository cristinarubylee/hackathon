import UIKit

class BottomSheetViewController: UIViewController {
    var eventsCollectionView: UICollectionView!
    var events: [Event] = [
        Event(title: "Dummy1", recurrence: "Dummy", startTimeFrame: "Dummy", endTimeFrame: "Dummy", timespan: [], category: []),
        Event(title: "Dummy2", recurrence: "Dummy", startTimeFrame: "Dummy", endTimeFrame: "Dummy", timespan: [], category: []),
        Event(title: "Dummy3", recurrence: "Dummy", startTimeFrame: "Dummy", endTimeFrame: "Dummy", timespan: [], category: [])
    ]  // Simulate event titles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupButtons()
        setupEventsCollectionView()
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

        eventsCollectionView?.removeFromSuperview() // Remove previous collectionView if any

        if title == "Events" {
            setupEventsCollectionView()
            eventsCollectionView.reloadData()
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
