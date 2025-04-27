import UIKit

class BottomSheetViewController: UIViewController {
    let scrollView = UIScrollView()
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupButtons()
        setupScrollView()
        setupLabel()
    }

    func setupButtons() {
        let buttonTitles = ["Button 1", "Button 2", "Button 3"]
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

    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }

    func setupLabel() {
        label.text = "Select a button!"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping // Ensure the text wraps properly
        scrollView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: scrollView.topAnchor),
            label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        // Set preferredMaxLayoutWidth to the width of the scrollView for proper wrapping
        label.preferredMaxLayoutWidth = view.bounds.width - 40 // 20 padding on each side
    }

    @objc func buttonTapped(_ sender: UIButton) {
        if let title = sender.titleLabel?.text {
            // Add more content to simulate scroll
            label.text = "You clicked: \(title)\n" + String(repeating: "Extra content for scrolling. ", count: 500)
            
            // Adjust the content size of the scrollView to match the label's height
            let labelHeight = label.intrinsicContentSize.height
            scrollView.contentSize = CGSize(width: view.bounds.width - 40, height: labelHeight)
        }
    }
}
