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
        } else {
            List {
                ForEach(items) { item in
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
            }
            .listStyle(.plain)
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
