import QuickAdd
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
                ListDetailView(
                    list: activeList,
                    viewModel: AddItemViewModel(
                        list: activeList,
                        repository: SwiftDataListItemRepository(context: modelContext),
                        analytics: LoggingAnalyticsService()
                    )
                )
            } else {
                ProgressView()
                    .onAppear(perform: bootstrapDefaultList)
            }
        }
    }

    private func bootstrapDefaultList() {
        guard lists.isEmpty else { return }
        let list = TaskList(name: "Démo", type: .tasks)
        modelContext.insert(list)
        try? modelContext.save()
    }
}
