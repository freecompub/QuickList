import QuickListAdd
import QuickListAnalytics
import QuickListCore
import QuickListDesignSystem
import QuickListLists
import SwiftData
import SwiftUI

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isCreateSheetPresented = false

    var body: some View {
        NavigationStack {
            HomeView(
                viewModelFactory: {
                    HomeViewModel(analytics: LoggingAnalyticsService())
                },
                optionsViewModelFactory: { list in
                    ListOptionsViewModel(
                        list: list,
                        repository: SwiftDataTaskListRepository(context: modelContext),
                        analytics: LoggingAnalyticsService()
                    )
                },
                detailContent: { list in
                    ListDetailView {
                        AddItemViewModel(
                            list: list,
                            repository: SwiftDataListItemRepository(context: modelContext),
                            analytics: LoggingAnalyticsService()
                        )
                    }
                }
            )
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
                    onListCreated: { _ in
                        // US-04 : la nouvelle liste est visible immediatement
                        // dans HomeView via @Query. Le push vers ListDetail
                        // reste un tap explicite de l'utilisateur (HIG).
                    }
                )
            }
        }
    }
}
