import QuickListAdd
import QuickListAI
import QuickListAnalytics
import QuickListCore
import QuickListDesignSystem
import QuickListLists
import SwiftData
import SwiftUI

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isCreateSheetPresented = false
    private let languageModelService: LanguageModelService
    private let languageModelAvailability: LanguageModelAvailability

    init(
        languageModelService: LanguageModelService,
        languageModelAvailability: LanguageModelAvailability
    ) {
        self.languageModelService = languageModelService
        self.languageModelAvailability = languageModelAvailability
    }

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
                    let repository = SwiftDataListItemRepository(context: modelContext)
                    let analytics: AnalyticsService = LoggingAnalyticsService()
                    ListDetailView(
                        viewModelFactory: {
                            AddItemViewModel(
                                list: list,
                                repository: repository,
                                analytics: analytics,
                                classificationCoordinator: RayonClassificationCoordinator(
                                    service: languageModelService,
                                    repository: repository,
                                    analytics: analytics
                                )
                            )
                        },
                        sortViewModelFactory: {
                            SortListViewModel(
                                list: list,
                                repository: SwiftDataTaskListRepository(context: modelContext),
                                analytics: analytics
                            )
                        },
                        checkmarkViewModelFactory: {
                            ItemCheckmarkViewModel(
                                list: list,
                                repository: repository,
                                analytics: analytics
                            )
                        }
                    )
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
