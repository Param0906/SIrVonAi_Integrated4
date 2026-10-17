import UIKit

final class DetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome"
        view.backgroundColor = .systemBackground
        buildInterface()
    }

    private func buildInterface() {
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey: DefaultsKey.studentName) ?? ""
        let displayName = name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Campus Visitor" : name
        let notificationsEnabled = defaults.bool(forKey: DefaultsKey.notificationsEnabled)
        let role = defaults.integer(forKey: DefaultsKey.selectedRoleIndex) == 1 ? "Faculty" : "Student"

        let welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome, \(displayName)!"
        welcomeLabel.font = .preferredFont(forTextStyle: .title2)
        welcomeLabel.numberOfLines = 0
        welcomeLabel.textAlignment = .center

        let detailsLabel = UILabel()
        detailsLabel.text = "Role: \(role)\nNotifications: \(notificationsEnabled ? "On" : "Off")"
        detailsLabel.font = .preferredFont(forTextStyle: .body)
        detailsLabel.numberOfLines = 0
        detailsLabel.textAlignment = .center

        let announcementsButton = UIButton(type: .system)
        announcementsButton.setTitle("View Campus Announcements", for: .normal)
        announcementsButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        announcementsButton.backgroundColor = .systemBlue
        announcementsButton.setTitleColor(.white, for: .normal)
        announcementsButton.layer.cornerRadius = 10
        announcementsButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        announcementsButton.addTarget(self, action: #selector(openAnnouncements), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [welcomeLabel, detailsLabel, announcementsButton])
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            stack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    @objc private func openAnnouncements() {
        navigationController?.pushViewController(AnnouncementsViewController(), animated: true)
    }
}
