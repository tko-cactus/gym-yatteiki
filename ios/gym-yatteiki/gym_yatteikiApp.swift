import SwiftUI
import SwiftData

@main
struct gym_yatteikiApp: App {
    var conteiner: ModelContainer
    
    init() {
        // Data Persistence Settings
        do {
            let storeUrl = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent("default.store")
            let config = ModelConfiguration(url: storeUrl)
            let schema = Schema([
                LoadByMenu.self,
                Menu.self,
            ])
            conteiner = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(conteiner)
        }
    }
}
