import QuickListAdd
import QuickListAnalytics
import QuickListCore
import SwiftData
import SwiftUI

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\TaskList.createdAt, order: .forward)])
    private var lists: [TaskList]

    var body: some View {
        NavigationStack {
            if let activeList = lists.first {
                ListDetailView {
                    AddItemViewModel(
                        list: activeList,
                        repository: SwiftDataListItemRepository(context: modelContext),
                        analytics: LoggingAnalyticsService()
                    )
                }
            } else {
                ProgressView()
                    .task {
                        DefaultListBootstrapper(
                            repository: SwiftDataTaskListRepository(context: modelContext)
                        )
                        .ensureDefault(name: "Démo", type: .tasks)
                    }
            }
        }
    }
}
