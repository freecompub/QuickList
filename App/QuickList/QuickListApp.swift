import QuickListCore
import SwiftData
import SwiftUI

@main
struct QuickListApp: App {
    private let container: ModelContainer

    init() {
        do {
            let schema = Schema([TaskList.self, ListItem.self])
            let configuration = ModelConfiguration(schema: schema)
            container = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(container)
    }
}
