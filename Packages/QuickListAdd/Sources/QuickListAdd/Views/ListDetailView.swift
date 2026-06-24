import QuickListAI
import QuickListCore
import QuickListDesignSystem
import SwiftData
import SwiftUI

public struct ListDetailView: View {
    @StateObject private var viewModel: AddItemViewModel
    @StateObject private var actionsViewModel: ListItemActionsViewModel
    @FocusState private var isAddItemFieldFocused: Bool
    @Query(sort: [SortDescriptor(\ListItem.createdAt, order: .forward)])
    private var allItems: [ListItem]

    public init(
        viewModelFactory: @escaping () -> AddItemViewModel,
        actionsViewModelFactory: @escaping () -> ListItemActionsViewModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModelFactory())
        self._actionsViewModel = StateObject(wrappedValue: actionsViewModelFactory())
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
        .overlay(alignment: .bottom) {
            if let pending = actionsViewModel.pendingUndo {
                UndoToast(
                    message: QuickListStrings.undoToastDeleted(title: pending.snapshot.title),
                    onUndo: actionsViewModel.undoLastDeletion
                )
                .padding(.bottom, Spacing.qlSafeAreaBottom)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: actionsViewModel.pendingUndo)
        .alert(
            QuickListStrings.errorTitle,
            isPresented: actionsErrorPresented,
            presenting: actionsViewModel.lastError
        ) { _ in
            Button(QuickListStrings.errorDismiss, action: actionsViewModel.dismissError)
        } message: { error in
            Text(errorMessage(for: error))
        }
        .onAppear {
            isAddItemFieldFocused = true
        }
    }

    private var actionsErrorPresented: Binding<Bool> {
        Binding(
            get: { actionsViewModel.lastError != nil },
            set: { isPresented in
                if !isPresented {
                    actionsViewModel.dismissError()
                }
            }
        )
    }

    private func errorMessage(for error: ListItemActionsError) -> String {
        switch error {
        case .deleteFailed: return QuickListStrings.errorDeleteMessage
        case .restoreFailed: return QuickListStrings.errorRestoreMessage
        }
    }

    @ViewBuilder
    private var content: some View {
        let items = viewModel.itemsBelongingToList(in: allItems)
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
            .padding(.vertical, Spacing.qlXS)
            .accessibilityLabel(title)
    }

    private func itemRow(_ item: ListItem) -> some View {
        Text(item.title)
            .font(.qlBody)
            .foregroundStyle(Color.qlPrimaryLabel)
            .padding(.vertical, Spacing.qlXS)
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    actionsViewModel.delete(item)
                } label: {
                    Label(QuickListStrings.listItemDelete, systemImage: "trash.fill")
                }
            }
    }

    private struct RayonGroup {
        let title: String
        let items: [ListItem]
    }

    private func groupedByRayon(items: [ListItem]) -> [RayonGroup] {
        let autresKey = Rayon.autres.rawValue
        var bucketsByKey: [String: [ListItem]] = [:]
        var order: [String] = []
        for item in items {
            let key = item.category ?? autresKey
            if bucketsByKey[key] == nil {
                bucketsByKey[key] = []
                order.append(key)
            }
            bucketsByKey[key]?.append(item)
        }
        if let autres = bucketsByKey.removeValue(forKey: autresKey) {
            order.removeAll { $0 == autresKey }
            order.append(autresKey)
            bucketsByKey[autresKey] = autres
        }
        return order.compactMap { key in
            guard let bucketItems = bucketsByKey[key] else { return nil }
            let title = (key == autresKey) ? QuickListStrings.rayonAutres : key
            return RayonGroup(title: title, items: bucketItems)
        }
    }

    private var emptyState: some View {
        VStack(spacing: Spacing.qlM) {
            Spacer()
            Image(systemName: "checklist")
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
