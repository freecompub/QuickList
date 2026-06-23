import SwiftUI

public struct AddItemBar: View {
    @Binding private var text: String
    private let isFocused: FocusState<Bool>.Binding
    private let onSubmit: () -> Void

    public init(
        text: Binding<String>,
        isFocused: FocusState<Bool>.Binding,
        onSubmit: @escaping () -> Void
    ) {
        self._text = text
        self.isFocused = isFocused
        self.onSubmit = onSubmit
    }

    public var body: some View {
        HStack(spacing: Spacing.qlM) {
            TextField(QuickListStrings.addItemPlaceholder, text: $text)
                .font(.qlAddItemField)
                .foregroundStyle(Color.qlPrimaryLabel)
                .padding(.horizontal, Spacing.qlM)
                .padding(.vertical, Spacing.qlM)
                .background(
                    RoundedRectangle(cornerRadius: Radius.qlMedium, style: .continuous)
                        .fill(Color.qlSecondaryBackground)
                )
                .focused(isFocused)
                .submitLabel(.send)
                .onSubmit(submit)
                .accessibilityLabel(QuickListStrings.addItemPlaceholder)

            Button(action: submit) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(text.isEmpty ? Color.qlTertiaryLabel : Color.qlAccent)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .accessibilityLabel(QuickListStrings.addItemSubmit)
        }
        .padding(.horizontal, Spacing.qlL)
        .padding(.vertical, Spacing.qlM)
        .background(.ultraThinMaterial)
    }

    private func submit() {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        onSubmit()
    }
}
