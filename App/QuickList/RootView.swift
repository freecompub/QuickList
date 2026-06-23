import QuickListAdd
import QuickListAnalytics
import QuickListCore
import QuickListDesignSystem
import QuickListLists
import SwiftData
import SwiftUI

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\TaskList.createdAt, order: .forward)])
    private var lists: [TaskList]
    @State private var isCreateSheetPresented = false

    var body: some View {
        NavigationStack {
            content
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            isCreateSheetPresented = true
                        } label: {
                            Image(systemName: "plus.square.fill.on.square.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(Color.qlAccent)
                        }
                        .accessibilityLabel(QuickListStrings.rootNewListAccessibility)
                    }
                }
                .sheet(isPresented: $isCreateSheetPresented) {
                    CreateListSheet(
                        viewModelFactory: {
                            CreateListViewModel(
                                repository: SwiftDataTaskListRepository(context: modelContext),
                                analytics: LoggingAnalyticsService()
                            )
                        },
                        onListCreated: { _ in
                            // US-04 : la nouvelle liste est visible immediatement
                            // dans HomeView via @Query. Le push vers ListDetail
                            // reste un tap explicite de l'utilisateur (HIG).
                        }
                    )
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if let activeList = lists.last {
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
