import QuickListCore
import QuickListDesignSystem
import SwiftData
import SwiftUI

public struct ListDetailView: View {
    @StateObject private var viewModel: AddItemViewModel
    @FocusState private var isAddItemFieldFocused: Bool
    @Query(sort: [SortDescriptor(\ListItem.createdAt, order: .forward)])
    private var allItems: [ListItem]

    public init(viewModelFactory: @escaping () -> AddItemViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModelFactory())
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
        .onAppear {
            isAddItemFieldFocused = true
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
