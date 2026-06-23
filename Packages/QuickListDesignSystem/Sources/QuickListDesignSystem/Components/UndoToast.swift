import SwiftUI

public struct UndoToast: View {
    private let message: String
    private let actionTitle: String
    private let onUndo: () -> Void

    public init(
        message: String,
        actionTitle: String = QuickListStrings.undoToastUndo,
        onUndo: @escaping () -> Void
    ) {
        self.message = message
        self.actionTitle = actionTitle
        self.onUndo = onUndo
    }

    public var body: some View {
        HStack(spacing: Spacing.qlM) {
            Text(message)
                .font(.qlCallout)
                .foregroundStyle(Color.qlPrimaryLabel)
                .lineLimit(1)
                .truncationMode(.tail)
            Spacer(minLength: Spacing.qlS)
            Button(action: onUndo) {
                Text(actionTitle)
                    .font(.qlCalloutBold)
                    .foregroundStyle(Color.qlAccent)
                    .padding(.horizontal, Spacing.qlS)
                    .padding(.vertical, Spacing.qlXS)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(QuickListStrings.undoToastUndoAccessibility)
        }
        .padding(.horizontal, Spacing.qlL)
        .padding(.vertical, Spacing.qlM)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: Radius.qlMedium, style: .continuous))
        .qlShadow(Shadow.qlToast)
        .padding(.horizontal, Spacing.qlL)
    }
}
