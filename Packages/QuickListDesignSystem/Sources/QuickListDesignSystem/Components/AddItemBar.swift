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
                .onSubmit(onSubmit)
                .accessibilityLabel(QuickListStrings.addItemPlaceholder)

            Button(action: handleButtonTap) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: IconSize.qlAddButtonSymbol, weight: .semibold))
                    .foregroundStyle(isEmpty ? Color.qlTertiaryLabel : Color.qlAccent)
                    .frame(width: IconSize.qlMinimumTapTarget, height: IconSize.qlMinimumTapTarget)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(QuickListStrings.addItemSubmit)
        }
        .padding(.horizontal, Spacing.qlL)
        .padding(.vertical, Spacing.qlM)
        .background(.ultraThinMaterial)
        .qlShadow(Shadow.qlAddBar)
    }

    private var isEmpty: Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func handleButtonTap() {
        if isEmpty {
            isFocused.wrappedValue = true
        } else {
            onSubmit()
        }
    }
}
