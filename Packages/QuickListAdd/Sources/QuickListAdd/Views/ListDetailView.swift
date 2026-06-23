import QuickListAI
import QuickListCore
import QuickListDesignSystem
import SwiftData
import SwiftUI

public struct ListDetailView: View {
    @StateObject private var viewModel: AddItemViewModel
    @StateObject private var sortViewModel: SortListViewModel
    @StateObject private var checkmarkViewModel: ItemCheckmarkViewModel
    @StateObject private var correctionViewModel: CategoryCorrectionViewModel
    @FocusState private var isAddItemFieldFocused: Bool
    @Query(sort: [SortDescriptor(\ListItem.createdAt, order: .forward)])
    private var allItems: [ListItem]

    public init(
        viewModelFactory: @escaping () -> AddItemViewModel,
        sortViewModelFactory: @escaping () -> SortListViewModel,
        checkmarkViewModelFactory: @escaping () -> ItemCheckmarkViewModel,
        correctionViewModelFactory: @escaping () -> CategoryCorrectionViewModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModelFactory())
        self._sortViewModel = StateObject(wrappedValue: sortViewModelFactory())
        self._checkmarkViewModel = StateObject(wrappedValue: checkmarkViewModelFactory())
        self._correctionViewModel = StateObject(wrappedValue: correctionViewModelFactory())
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
        .alert(
            QuickListStrings.itemToggleErrorTitle,
            isPresented: checkmarkErrorPresented
        ) {
            Button(QuickListStrings.listOptionsCancel) {
                checkmarkViewModel.dismissError()
            }
        } message: {
            Text(QuickListStrings.itemToggleErrorMessage)
        }
        .alert(
            QuickListStrings.itemCategoryErrorTitle,
            isPresented: correctionErrorPresented
        ) {
            Button(QuickListStrings.listOptionsCancel) {
                correctionViewModel.dismissError()
            }
        } message: {
            Text(QuickListStrings.itemCategoryErrorMessage)
        }
        .onAppear {
            isAddItemFieldFocused = true
        }
    }

    private var checkmarkErrorPresented: Binding<Bool> {
        Binding(
            get: { checkmarkViewModel.lastError != nil },
            set: { isPresented in
                if !isPresented {
                    checkmarkViewModel.dismissError()
                }
            }
        )
    }

    private var correctionErrorPresented: Binding<Bool> {
        Binding(
            get: { correctionViewModel.lastError != nil },
            set: { isPresented in
                if !isPresented {
                    correctionViewModel.dismissError()
                }
            }
        )
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

    /// US-07 + US-08 : pour les listes Courses, l'affichage est regroupé par
    /// rayon (`item.category`). Les items en attente de classification ou
    /// classés `Autres` tombent dans une section dédiée en fin de liste.
    /// US-08 ajoute la coche tappable (grande cible 64pt+) et le grisé +
    /// déplacement bas des items cochés.
    private func groceriesGroupedList(items: [ListItem]) -> some View {
        let groups = groupedByRayon(items: items).map { group in
            RayonGroup(
                title: group.title,
                items: group.items.sorted(by: shoppingOrder)
            )
        }
        return List {
            ForEach(groups, id: \.title) { group in
                Section(header: rayonSectionHeader(group.title)) {
                    ForEach(group.items) { item in
                        shoppingRow(item)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private func shoppingOrder(_ lhs: ListItem, _ rhs: ListItem) -> Bool {
        if lhs.isDone != rhs.isDone {
            return !lhs.isDone
        }
        return lhs.createdAt < rhs.createdAt
    }

    private func shoppingRow(_ item: ListItem) -> some View {
        Button {
            checkmarkViewModel.toggle(item)
        } label: {
            HStack(spacing: Spacing.qlM) {
                Image(systemName: item.isDone ? Symbol.qlItemCheckedOn : Symbol.qlItemCheckedOff)
                    .symbolRenderingMode(item.isDone ? .multicolor : .hierarchical)
                    .font(.system(size: IconSize.qlCheckboxShopping))
                    .foregroundStyle(item.isDone ? Color.qlSuccess : Color.qlSecondaryLabel)
                Text(item.title)
                    .font(.qlHeadline)
                    .foregroundStyle(item.isDone ? Color.qlItemDone : Color.qlPrimaryLabel)
                    .strikethrough(item.isDone)
                    .opacity(item.isDone ? 0.6 : 1.0)
                Spacer(minLength: Spacing.qlS)
            }
            .padding(.vertical, Spacing.qlM)
            .frame(minHeight: IconSize.qlShoppingRowMinHeight)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(item.title)
        .accessibilityHint(
            item.isDone
                ? QuickListStrings.itemToggleAccessibilityDone
                : QuickListStrings.itemToggleAccessibilityToDo
        )
        .accessibilityAddTraits(item.isDone ? .isSelected : [])
        .contextMenu {
            Menu(QuickListStrings.itemMoveToRayon) {
                ForEach(Rayon.allCases, id: \.self) { rayon in
                    Button {
                        correctionViewModel.setRayon(rayon, for: item)
                    } label: {
                        Label(
                            QuickListStrings.rayonLabel(for: rayon.rawValue),
                            systemImage: item.category == rayon.rawValue ? "checkmark" : ""
                        )
                    }
                }
            }
        }
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

    private func groupedByRayon(items: [ListItem]) -> [RayonGroup] {
        // Cle technique stable : le rawValue du modele (FR), utilisee aussi
        // bien pour les items non classes (`item.category == nil`) que pour
        // ceux explicitement classes "Autres" par le service.
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
