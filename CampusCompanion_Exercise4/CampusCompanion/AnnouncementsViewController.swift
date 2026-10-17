import UIKit
import CoreData

final class AnnouncementsViewController: UITableViewController {
    private var announcements: [CampusAnnouncement] = []

    private var context: NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Campus Announcements"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AnnouncementCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 84
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAnnouncementTapped))
        seedInitialAnnouncementsIfNeeded()
        loadAnnouncements()
    }

    private func seedInitialAnnouncementsIfNeeded() {
        let request: NSFetchRequest<CampusAnnouncement> = CampusAnnouncement.fetchRequest()
        do {
            guard try context.count(for: request) == 0 else { return }
            let samples: [(String, String, String)] = [
                ("Enrollment Period Extended", "2026-01-12", "Registrar"),
                ("Library Hours Updated", "2026-02-03", "Campus Services"),
                ("Career Fair 2026", "2026-03-18", "Student Affairs")
            ]
            for (title, date, category) in samples {
                let announcement = CampusAnnouncement(context: context)
                announcement.title = title
                announcement.date = date
                announcement.category = category
            }
            try context.save()
        } catch {
            presentError("Could not load the initial announcements.\n\(error.localizedDescription)")
        }
    }

    private func loadAnnouncements() {
        let request: NSFetchRequest<CampusAnnouncement> = CampusAnnouncement.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do {
            announcements = try context.fetch(request)
            tableView.reloadData()
        } catch {
            announcements = []
            tableView.reloadData()
            presentError("Could not fetch announcements.\n\(error.localizedDescription)")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        announcements.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementCell", for: indexPath)
        let announcement = announcements[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = announcement.title
        content.secondaryText = "\(announcement.category) • \(announcement.date)"
        content.textProperties.font = .preferredFont(forTextStyle: .headline)
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .subheadline)
        cell.contentConfiguration = content
        cell.accessoryType = .none
        return cell
    }

    @objc private func addAnnouncementTapped() {
        let alert = UIAlertController(title: "New Announcement", message: "Enter a title and category.", preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Title"
            field.autocapitalizationType = .sentences
        }
        alert.addTextField { field in
            field.placeholder = "Category"
            field.autocapitalizationType = .words
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
            guard let self,
                  let titleText = alert?.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines), !titleText.isEmpty,
                  let categoryText = alert?.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines), !categoryText.isEmpty else {
                self?.presentError("Please enter both a title and a category.")
                return
            }

            let announcement = CampusAnnouncement(context: self.context)
            announcement.title = titleText
            announcement.date = Self.dateFormatter.string(from: Date())
            announcement.category = categoryText

            do {
                try self.context.save()
                self.loadAnnouncements()
            } catch {
                self.context.delete(announcement)
                self.presentError("The announcement could not be saved.\n\(error.localizedDescription)")
            }
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(saveAction)
        present(alert, animated: true)
    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else { return }
        let announcement = announcements[indexPath.row]
        context.delete(announcement)
        do {
            try context.save()
            announcements.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            context.rollback()
            loadAnnouncements()
            presentError("The announcement could not be deleted.\n\(error.localizedDescription)")
        }
    }

    private func presentError(_ message: String) {
        guard isViewLoaded, view.window != nil else { return }
        let alert = UIAlertController(title: "Campus Companion", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}
