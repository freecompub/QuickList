import QuickListCore
import QuickListDesignSystem
import SwiftUI

public struct CreateListSheet: View {
    @StateObject private var viewModel: CreateListViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isNameFieldFocused: Bool
    private let onListCreated: (TaskList) -> Void

    public init(
        viewModelFactory: @escaping () -> CreateListViewModel,
        onListCreated: @escaping (TaskList) -> Void
    ) {
        self._viewModel = StateObject(wrappedValue: viewModelFactory())
        self.onListCreated = onListCreated
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.qlXXL) {
                    nameField
                    typeSection
                }
                .padding(.horizontal, Spacing.qlL)
                .padding(.top, Spacing.qlXL)
            }
            .background(Color.qlGroupedBackground.ignoresSafeArea())
            .navigationTitle(QuickListStrings.createListTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(QuickListStrings.createListCancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(QuickListStrings.createListCreate) {
                        viewModel.create()
                    }
                    .fontWeight(.semibold)
                    .disabled(!viewModel.canCreate)
                }
            }
            .onChange(of: viewModel.createdList) { _, created in
                guard let created else { return }
                onListCreated(created)
                dismiss()
            }
            .alert(
                QuickListStrings.createListErrorTitle,
                isPresented: errorPresented,
                presenting: viewModel.lastError
            ) { _ in
                Button(QuickListStrings.createListErrorDismiss) {
                    viewModel.dismissError()
                }
            } message: { _ in
                Text(QuickListStrings.createListErrorMessage)
            }
            .onAppear {
                isNameFieldFocused = true
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private var nameField: some View {
        TextField(
            QuickListStrings.createListNamePlaceholder,
            text: $viewModel.name
        )
        .font(.qlTitle2)
        .foregroundStyle(Color.qlPrimaryLabel)
        .padding(Spacing.qlL)
        .background(
            RoundedRectangle(cornerRadius: Radius.qlMedium, style: .continuous)
                .fill(Color.qlSecondaryBackground)
        )
        .focused($isNameFieldFocused)
        .submitLabel(.done)
        .onSubmit {
            if viewModel.canCreate {
                viewModel.create()
            }
        }
        .accessibilityLabel(QuickListStrings.createListNamePlaceholder)
    }

    private var typeSection: some View {
        VStack(alignment: .leading, spacing: Spacing.qlS) {
            Text(QuickListStrings.createListTypeHeader.uppercased())
                .font(.qlCaption1)
                .foregroundStyle(Color.qlSecondaryLabel)
                .padding(.leading, Spacing.qlS)
            ListTypeSelector(selection: $viewModel.selectedType)
        }
    }

    private var errorPresented: Binding<Bool> {
        Binding(
            get: { viewModel.lastError != nil },
            set: { presented in
                if !presented {
                    viewModel.dismissError()
                }
            }
        )
    }
}
