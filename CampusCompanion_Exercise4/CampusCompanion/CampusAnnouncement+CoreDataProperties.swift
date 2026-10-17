import Foundation
import CoreData

extension CampusAnnouncement {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CampusAnnouncement> {
        return NSFetchRequest<CampusAnnouncement>(entityName: "CampusAnnouncement")
    }

    @NSManaged public var title: String
    @NSManaged public var date: String
    @NSManaged public var category: String
}
