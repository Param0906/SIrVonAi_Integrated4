import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    lazy var persistentContainer: NSPersistentContainer = {
        // Build the Core Data model in Swift. This avoids Xcode needing to parse
        // a .xcdatamodeld file while opening/indexing this project.
        let announcementEntity = NSEntityDescription()
        announcementEntity.name = "CampusAnnouncement"
        announcementEntity.managedObjectClassName = NSStringFromClass(CampusAnnouncement.self)

        func stringAttribute(_ name: String) -> NSAttributeDescription {
            let attribute = NSAttributeDescription()
            attribute.name = name
            attribute.attributeType = .stringAttributeType
            attribute.isOptional = false
            attribute.defaultValue = ""
            return attribute
        }

        announcementEntity.properties = [
            stringAttribute("title"),
            stringAttribute("date"),
            stringAttribute("category")
        ]

        let model = NSManagedObjectModel()
        model.entities = [announcementEntity]

        let container = NSPersistentContainer(name: "CampusCompanion", managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: WelcomeViewController())
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            assertionFailure("Unresolved Core Data save error \(nsError), \(nsError.userInfo)")
        }
    }
}
