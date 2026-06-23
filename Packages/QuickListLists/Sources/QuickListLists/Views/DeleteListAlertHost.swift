import QuickListCore
import QuickListDesignSystem
import SwiftUI

/// Conteneur qui détient un `ListOptionsViewModel` en `@StateObject` pour
/// l'action de suppression. Présente deux alertes successives :
/// - une alerte destructive de confirmation,
/// - une alerte d'erreur si la persistance échoue, alimentée par
///   `viewModel.lastError`.
/// Tant que le host vit, le VM est observable et `lastError` reste lié.
public struct DeleteListAlertHost: View {
    @StateObject private var viewModel: ListOptionsViewModel
    @State private var confirmPresented = true
    private let listName: String
    private let onDismiss: () -> Void

    public init(
        listName: String,
        viewModelFactory: @escaping () -> ListOptionsViewModel,
        onDismiss: @escaping () -> Void
    ) {
        self._viewModel = StateObject(wrappedValue: viewModelFactory())
        self.listName = listName
        self.onDismiss = onDismiss
    }

    public var body: some View {
        Color.clear
            .frame(width: 0, height: 0)
            .alert(
                QuickListStrings.listDeleteConfirmTitle(listName: listName),
                isPresented: $confirmPresented
            ) {
                Button(QuickListStrings.listOptionsDelete, role: .destructive) {
                    viewModel.delete()
                }
                Button(QuickListStrings.listOptionsCancel, role: .cancel) {
                    onDismiss()
                }
            } message: {
                Text(QuickListStrings.listDeleteConfirmMessage)
            }
            .alert(
                QuickListStrings.listDeleteErrorTitle,
                isPresented: errorPresented
            ) {
                Button(QuickListStrings.listOptionsCancel) {
                    viewModel.dismissError()
                    onDismiss()
                }
            } message: {
                Text(QuickListStrings.listDeleteErrorMessage)
            }
            .onChange(of: viewModel.didDelete) { _, didDelete in
                if didDelete {
                    onDismiss()
                }
            }
    }

    private var errorPresented: Binding<Bool> {
        Binding(
            get: { viewModel.lastError == .deleteFailed },
            set: { isPresented in
                if !isPresented {
                    viewModel.dismissError()
                }
            }
        )
    }
}
