import QuickListCore
import QuickListDesignSystem
import SwiftData
import SwiftUI

public struct ListDetailView: View {
    @StateObject private var viewModel: AddItemViewModel
    @StateObject private var sortViewModel: SortListViewModel
    @FocusState private var isAddItemFieldFocused: Bool
    @Query(sort: [SortDescriptor(\ListItem.createdAt, order: .forward)])
    private var allItems: [ListItem]

    public init(
        viewModelFactory: @escaping () -> AddItemViewModel,
        sortViewModelFactory: @escaping () -> SortListViewModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModelFactory())
        self._sortViewModel = StateObject(wrappedValue: sortViewModelFactory())
    }

    public var body: some View {
        VStack(spacing: 0) {
            content
            AddItemBar(
                text: $viewModel.pendingTitle,
                isFocused: $isAddItemFieldFocused,
                onSubmit: handleSubmit
            )
        }
        .background(Color.qlBackground.ignoresSafeArea())
        .navigationTitle(viewModel.list.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                sortMenu
            }
        }
        .alert(
            QuickListStrings.sortErrorTitle,
            isPresented: sortErrorPresented
        ) {
            Button(QuickListStrings.listOptionsCancel) {
                sortViewModel.dismissError()
            }
        } message: {
            Text(QuickListStrings.sortErrorMessage)
        }
        .onAppear {
            isAddItemFieldFocused = true
        }
    }

    private var sortMenu: some View {
        Menu {
            Picker(QuickListStrings.sortMenuTitle, selection: sortSelection) {
                Text(QuickListStrings.sortDateAdded).tag(SortMode.dateAdded)
                Text(QuickListStrings.sortAlphabetical).tag(SortMode.alphabetical)
                Text(QuickListStrings.sortStatus).tag(SortMode.status)
            }
        } label: {
            Image(systemName: Symbol.qlSortMenu)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color.qlAccent)
        }
        .accessibilityLabel(QuickListStrings.sortMenuTitle)
    }

    private var sortSelection: Binding<SortMode> {
        Binding(
            get: { sortViewModel.currentSortMode },
            set: { sortViewModel.setSortMode($0) }
        )
    }

    private var sortErrorPresented: Binding<Bool> {
        Binding(
            get: { sortViewModel.lastError != nil },
            set: { isPresented in
                if !isPresented {
                    sortViewModel.dismissError()
                }
            }
        )
    }

    @ViewBuilder
    private var content: some View {
        let scoped = viewModel.itemsBelongingToList(in: allItems)
        let items = sortViewModel.sortedItems(scoped)
        if items.isEmpty {
            emptyState
        } else if viewModel.list.type == .groceries {
            groceriesGroupedList(items: items)
        } else {
            plainList(items: items)
        }
    }

    private func plainList(items: [ListItem]) -> some View {
        List {
            ForEach(items) { item in
                itemRow(item)
            }
        }
        .listStyle(.plain)
    }

    /// US-07 : pour les listes de type Courses, l'affichage est regroupé par
    /// rayon (`item.category`). Les items en attente de classification ou
    /// classés `Autres` tombent dans une section dédiée en fin de liste.
    /// Le mode Courses dédié plein écran (US-08) reprendra ce regroupement
    /// avec un layout grandes cibles tactiles.
    private func groceriesGroupedList(items: [ListItem]) -> some View {
        let groups = groupedByRayon(items: items)
        return List {
            ForEach(groups, id: \.title) { group in
                Section(header: rayonSectionHeader(group.title)) {
                    ForEach(group.items) { item in
                        itemRow(item)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private func rayonSectionHeader(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.qlCaption1Bold)
            .foregroundStyle(Color.qlSecondaryLabel)
            .padding(.vertical, Spacing.qlXXS)
            .accessibilityLabel(title)
    }

    private func itemRow(_ item: ListItem) -> some View {
        Text(item.title)
            .font(.qlBody)
            .foregroundStyle(Color.qlPrimaryLabel)
            .padding(.vertical, Spacing.qlXS)
    }

    private struct RayonGroup {
        let title: String
        let items: [ListItem]
    }

    private func groupedByRayon(items: [ListItem]) -> [RayonGroup] {
        var bucketsByTitle: [String: [ListItem]] = [:]
        var order: [String] = []
        for item in items {
            let key = item.category ?? QuickListStrings.rayonAutres
            if bucketsByTitle[key] == nil {
                bucketsByTitle[key] = []
                order.append(key)
            }
            bucketsByTitle[key]?.append(item)
        }
        if let autres = bucketsByTitle.removeValue(forKey: QuickListStrings.rayonAutres) {
            order.removeAll { $0 == QuickListStrings.rayonAutres }
            order.append(QuickListStrings.rayonAutres)
            bucketsByTitle[QuickListStrings.rayonAutres] = autres
        }
        return order.compactMap { title in
            bucketsByTitle[title].map { RayonGroup(title: title, items: $0) }
        }
    }

    private var emptyState: some View {
        VStack(spacing: Spacing.qlM) {
            Spacer()
            Image(systemName: Symbol.qlEmptyChecklist)
                .font(.system(size: IconSize.qlEmptyStateGlyph))
                .foregroundStyle(Color.qlSecondaryLabel)
            Text(QuickListStrings.listEmptyTitle)
                .font(.qlTitle2)
                .foregroundStyle(Color.qlPrimaryLabel)
            Text(QuickListStrings.listEmptySubtitle)
                .font(.qlBody)
                .foregroundStyle(Color.qlSecondaryLabel)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.qlXXL)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func handleSubmit() {
        viewModel.submit()
        isAddItemFieldFocused = true
    }
}
