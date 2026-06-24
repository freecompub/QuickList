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
                let repository = SwiftDataListItemRepository(context: modelContext)
                let analytics: AnalyticsService = LoggingAnalyticsService()
                ListDetailView(
                    viewModelFactory: {
                        AddItemViewModel(
                            list: activeList,
                            repository: repository,
                            analytics: analytics
                        )
                    },
                    actionsViewModelFactory: {
                        ListItemActionsViewModel(
                            list: activeList,
                            repository: repository,
                            analytics: analytics
                        )
                    }
                )
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
