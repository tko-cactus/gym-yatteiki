import Foundation
import SwiftData

class LoadByMenuModelContainer {
    var container: ModelContainer = {
        let schema = Schema([
            LoadByMenu.self,
            Menu.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()
    
    func initialize() -> ModelContainer {
        let schema = Schema([
            LoadByMenu.self,
            Menu.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
}
