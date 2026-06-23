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
                            Image(systemName: Symbol.qlCreateList)
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
                        // La navigation post-creation est pilotee par lists.last
                        // (cf. content). US-04 routera vers ListDetailView via
                        // une vraie HomeView consommant cette nouvelle liste.
                        onListCreated: { _ in }
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
