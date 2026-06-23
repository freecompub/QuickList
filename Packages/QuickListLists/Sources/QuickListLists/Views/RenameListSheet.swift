import QuickListCore
import QuickListDesignSystem
import SwiftUI

public struct RenameListSheet: View {
    @ObservedObject private var viewModel: ListOptionsViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isNameFieldFocused: Bool

    public init(viewModel: ListOptionsViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: Spacing.qlL) {
                TextField(QuickListStrings.listRenamePlaceholder, text: $viewModel.draftName)
                    .font(.qlTitle2)
                    .foregroundStyle(Color.qlPrimaryLabel)
                    .padding(Spacing.qlL)
                    .background(
                        RoundedRectangle(cornerRadius: Radius.qlMedium, style: .continuous)
                            .fill(Color.qlSecondaryBackground)
                    )
                    .focused($isNameFieldFocused)
                    .submitLabel(.done)
                    .onSubmit(commit)
                    .accessibilityLabel(QuickListStrings.listRenamePlaceholder)
                Spacer()
            }
            .padding(Spacing.qlL)
            .background(Color.qlGroupedBackground.ignoresSafeArea())
            .navigationTitle(QuickListStrings.listRenameTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(QuickListStrings.listOptionsCancel) {
                        viewModel.resetDraftName()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(QuickListStrings.listOptionsConfirm, action: commit)
                        .fontWeight(.semibold)
                        .disabled(!viewModel.canRename)
                }
            }
            .onAppear { isNameFieldFocused = true }
            .onChange(of: viewModel.didRename) { _, didRename in
                if didRename {
                    viewModel.acknowledgeRename()
                    dismiss()
                }
            }
            .alert(
                QuickListStrings.listRenameErrorTitle,
                isPresented: errorPresented
            ) {
                Button(QuickListStrings.listOptionsCancel) {
                    viewModel.dismissError()
                }
            } message: {
                Text(QuickListStrings.listRenameErrorMessage)
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private func commit() {
        guard viewModel.canRename else { return }
        viewModel.rename()
    }

    private var errorPresented: Binding<Bool> {
        Binding(
            get: { viewModel.lastError == .renameFailed || viewModel.lastError == .emptyName },
            set: { isPresented in
                if !isPresented {
                    viewModel.dismissError()
                }
            }
        )
    }
}
