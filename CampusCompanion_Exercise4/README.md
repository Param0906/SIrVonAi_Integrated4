# Campus Companion iOS — MAD2 Laboratory Exercise 4

This is a standalone UIKit iOS project implementing the key requirements of the lab exercise:

- UserDefaults saves/restores the student's name, notification preference, and role selection.
- Reset Preferences clears the three UserDefaults keys and immediately resets the welcome controls.
- A programmatically defined Core Data model stores CampusAnnouncement records with title, date, and category.
- Announcement data is seeded only when the store is empty.
- Students can add announcements and delete them with swipe-to-delete; changes are saved to Core Data.
- The welcome, detail, and announcements screens are built in Swift code; this project deliberately does not include or reference a storyboard, to avoid the Interface Builder error encountered in Xcode.

## Open and run

1. Extract the ZIP archive.
2. Open `CampusCompanion.xcodeproj` in Xcode.
3. Select the `CampusCompanion` scheme and an iPhone simulator.
4. Choose Product > Build (or press Command-B), then Run (Command-R).

Choose your Apple development team under Signing & Capabilities only if you want to run on a physical device; a simulator generally does not require a team selection.

## Notes

- This is a new standalone project based on the provided laboratory instructions because the original student Xcode project was not included.
- The Core Data model is constructed in `AppDelegate.swift` instead of an `.xcdatamodeld` file. The entity remains named `CampusAnnouncement`, with `title`, `date`, and `category` string attributes.
- The code was syntax-parsed and the project/plist/archive structure checked in this environment. A full iOS SDK build and simulator launch must still be verified on a Mac with Xcode.
