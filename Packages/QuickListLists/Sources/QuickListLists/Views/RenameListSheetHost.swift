import QuickListCore
import SwiftUI

/// Conteneur qui détient le `ListOptionsViewModel` en `@StateObject` afin que
/// l'état (`didRename`, `lastError`, `draftName`) survive aux rebuilds du
/// parent — sinon le `.onChange(of: viewModel.didRename)` ne se déclenche
/// jamais après la persistance et la sheet ne se ferme pas.
public struct RenameListSheetHost: View {
    @StateObject private var viewModel: ListOptionsViewModel

    public init(viewModelFactory: @escaping () -> ListOptionsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModelFactory())
    }

    public var body: some View {
        RenameListSheet(viewModel: viewModel)
    }
}
