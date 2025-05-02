import UIKit

class BottomSheetViewController: UIViewController {
    var collectionView: UICollectionView!
    var events: [Event] = [
        Event(title: "Dummy1", recurrence: "Dummy", startTimeFrame: "Dummy", endTimeFrame: "Dummy", timespan: [], category: []),
//        Event(title: "Dummy2", recurrence: "Dummy", startTimeFrame: "Dummy", endTimeFrame: "Dummy", timespan: [], category: []),
//        Event(title: "Dummy3", recurrence: "Dummy", startTimeFrame: "Dummy", endTimeFrame: "Dummy", timespan: [], category: [])
    ]  // Simulate event titles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupButtons()
        setupCollectionView()
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

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: view.bounds.width - 40, height: 80)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: EventCollectionViewCell.reuse)

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }

    @objc func buttonTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }

        collectionView?.removeFromSuperview() // Remove previous collectionView if any

        if title == "Events" {
//            events = (1...10).map { "Event \($0)" }  // Replace with actual Event models later
            setupCollectionView()
            collectionView.reloadData()
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
