import QuickListCore
import QuickListDesignSystem
import SwiftData
import SwiftUI

public struct HomeView<DetailContent: View>: View {
    @StateObject private var viewModel: HomeViewModel
    @Query(sort: [SortDescriptor(\TaskList.createdAt, order: .forward)])
    private var lists: [TaskList]
    @State private var renameTarget: TaskList?
    @State private var deleteTarget: TaskList?
    private let detailContent: (TaskList) -> DetailContent
    private let optionsViewModelFactory: (TaskList) -> ListOptionsViewModel

    private let gridColumns = [
        GridItem(.flexible(), spacing: Spacing.qlL),
        GridItem(.flexible(), spacing: Spacing.qlL)
    ]

    public init(
        viewModelFactory: @escaping () -> HomeViewModel,
        optionsViewModelFactory: @escaping (TaskList) -> ListOptionsViewModel,
        @ViewBuilder detailContent: @escaping (TaskList) -> DetailContent
    ) {
        self._viewModel = StateObject(wrappedValue: viewModelFactory())
        self.optionsViewModelFactory = optionsViewModelFactory
        self.detailContent = detailContent
    }

    public var body: some View {
        Group {
            if lists.isEmpty {
                emptyState
            } else {
                gridContent
            }
        }
        .background(Color.qlGroupedBackground.ignoresSafeArea())
        .navigationTitle(QuickListStrings.homeTitle)
        .navigationDestination(for: TaskList.self) { list in
            detailContent(list)
                .task(id: list.persistentModelID) {
                    viewModel.listDidOpen(list)
                }
        }
        .sheet(item: $renameTarget) { list in
            RenameListSheetHost {
                optionsViewModelFactory(list)
            }
        }
        .overlay {
            if let target = deleteTarget {
                DeleteListAlertHost(
                    listName: target.name,
                    viewModelFactory: { optionsViewModelFactory(target) },
                    onDismiss: { deleteTarget = nil }
                )
            }
        }
    }

    private var gridContent: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: Spacing.qlL) {
                ForEach(lists) { list in
                    NavigationLink(value: list) {
                        ListCard(
                            name: list.name,
                            presentation: viewModel.presentation(for: list),
                            unfinishedCount: viewModel.unfinishedItemsCount(in: list),
                            subtitle: viewModel.subtitle(for: list)
                        )
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button {
                            renameTarget = list
                        } label: {
                            Label(
                                QuickListStrings.listOptionsRename,
                                systemImage: Symbol.qlRenameList
                            )
                        }
                        Button(role: .destructive) {
                            deleteTarget = list
                        } label: {
                            Label(
                                QuickListStrings.listOptionsDelete,
                                systemImage: Symbol.qlDeleteItem
                            )
                        }
                    }
                }
            }
            .padding(Spacing.qlL)
        }
    }

    private var emptyState: some View {
        VStack(spacing: Spacing.qlM) {
            Spacer()
            Image(systemName: Symbol.qlEmptyChecklist)
                .font(.system(size: IconSize.qlEmptyStateGlyph))
                .foregroundStyle(Color.qlSecondaryLabel)
            Text(QuickListStrings.homeEmptyTitle)
                .font(.qlTitle2)
                .foregroundStyle(Color.qlPrimaryLabel)
            Text(QuickListStrings.homeEmptySubtitle)
                .font(.qlBody)
                .foregroundStyle(Color.qlSecondaryLabel)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.qlXXL)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
