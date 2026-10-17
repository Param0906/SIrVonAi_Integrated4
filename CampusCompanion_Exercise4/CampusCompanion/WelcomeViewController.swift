import UIKit

enum DefaultsKey {
    static let studentName = "studentName"
    static let notificationsEnabled = "notificationsEnabled"
    static let selectedRoleIndex = "selectedRoleIndex"
}

final class WelcomeViewController: UIViewController {
    private let nameTextField = UITextField()
    private let notifySwitch = UISwitch()
    private let roleControl = UISegmentedControl(items: ["Student", "Faculty"])

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Campus Companion"
        view.backgroundColor = .systemBackground
        buildInterface()
        restorePreferences()
    }

    private func buildInterface() {
        let heading = UILabel()
        heading.text = "Welcome to Campus Companion"
        heading.font = .preferredFont(forTextStyle: .title2)
        heading.adjustsFontForContentSizeCategory = true
        heading.numberOfLines = 0
        heading.textAlignment = .center

        nameTextField.borderStyle = .roundedRect
        nameTextField.placeholder = "Enter your name"
        nameTextField.autocapitalizationType = .words
        nameTextField.returnKeyType = .done
        nameTextField.accessibilityLabel = "Name"

        let nameLabel = UILabel()
        nameLabel.text = "Name"

        let notifyLabel = UILabel()
        notifyLabel.text = "Enable notifications"

        roleControl.selectedSegmentIndex = 0
        roleControl.accessibilityLabel = "Role"

        let exploreButton = UIButton(type: .system)
        exploreButton.setTitle("Explore Campus", for: .normal)
        exploreButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        exploreButton.backgroundColor = .systemBlue
        exploreButton.setTitleColor(.white, for: .normal)
        exploreButton.layer.cornerRadius = 10
        exploreButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        exploreButton.addTarget(self, action: #selector(exploreButtonTapped), for: .touchUpInside)

        let resetButton = UIButton(type: .system)
        resetButton.setTitle("Reset Preferences", for: .normal)
        resetButton.addTarget(self, action: #selector(resetPreferencesTapped), for: .touchUpInside)

        let notifyRow = UIStackView(arrangedSubviews: [notifyLabel, UIView(), notifySwitch])
        notifyRow.axis = .horizontal
        notifyRow.alignment = .center
        notifyRow.spacing = 12

        let form = UIStackView(arrangedSubviews: [heading, nameLabel, nameTextField, notifyRow, UILabel(), roleControl, exploreButton, resetButton])
        form.axis = .vertical
        form.spacing = 16
        form.translatesAutoresizingMaskIntoConstraints = false
        form.setCustomSpacing(4, after: nameLabel)
        form.setCustomSpacing(4, after: notifyRow)
        form.setCustomSpacing(0, after: form.arrangedSubviews[4])

        view.addSubview(form)
        NSLayoutConstraint.activate([
            form.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            form.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            form.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func restorePreferences() {
        let defaults = UserDefaults.standard
        nameTextField.text = defaults.string(forKey: DefaultsKey.studentName) ?? ""
        notifySwitch.isOn = defaults.bool(forKey: DefaultsKey.notificationsEnabled)
        let savedIndex = defaults.integer(forKey: DefaultsKey.selectedRoleIndex)
        roleControl.selectedSegmentIndex = (0..<roleControl.numberOfSegments).contains(savedIndex) ? savedIndex : 0
    }

    @objc private func exploreButtonTapped() {
        view.endEditing(true)
        let defaults = UserDefaults.standard
        defaults.set(nameTextField.text ?? "", forKey: DefaultsKey.studentName)
        defaults.set(notifySwitch.isOn, forKey: DefaultsKey.notificationsEnabled)
        defaults.set(roleControl.selectedSegmentIndex, forKey: DefaultsKey.selectedRoleIndex)
        navigationController?.pushViewController(DetailViewController(), animated: true)
    }

    @objc private func resetPreferencesTapped() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: DefaultsKey.studentName)
        defaults.removeObject(forKey: DefaultsKey.notificationsEnabled)
        defaults.removeObject(forKey: DefaultsKey.selectedRoleIndex)
        nameTextField.text = ""
        notifySwitch.isOn = false
        roleControl.selectedSegmentIndex = 0
        view.endEditing(true)

        let alert = UIAlertController(title: "Preferences Reset", message: "Your saved preferences have been cleared.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
