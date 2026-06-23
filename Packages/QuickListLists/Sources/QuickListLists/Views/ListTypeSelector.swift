import QuickListCore
import QuickListDesignSystem
import SwiftUI

public struct ListTypeSelector: View {
    @Binding private var selection: ListType

    public init(selection: Binding<ListType>) {
        self._selection = selection
    }

    public var body: some View {
        HStack(spacing: Spacing.qlS) {
            ForEach(ListType.allCases, id: \.self) { type in
                Button {
                    selection = type
                } label: {
                    cell(for: type, selected: selection == type)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(presentation(for: type).label)
                .accessibilityAddTraits(selection == type ? .isSelected : [])
            }
        }
        .padding(Spacing.qlM)
        .background(
            RoundedRectangle(cornerRadius: Radius.qlLarge, style: .continuous)
                .fill(Color.qlSurface)
        )
    }

    private func cell(for type: ListType, selected: Bool) -> some View {
        let presentation = presentation(for: type)
        return VStack(spacing: Spacing.qlXS) {
            ZStack {
                if selected {
                    Circle()
                        .fill(Color.qlAccent.opacity(0.15))
                        .frame(
                            width: IconSize.qlMinimumTapTarget,
                            height: IconSize.qlMinimumTapTarget
                        )
                }
                Image(systemName: presentation.systemImageName)
                    .symbolRenderingMode(presentation.renderingMode)
                    .font(.system(size: selected ? 28 : 20))
                    .foregroundStyle(selected ? presentation.tint : Color.qlTertiaryLabel)
            }
            .frame(
                width: IconSize.qlMinimumTapTarget,
                height: IconSize.qlMinimumTapTarget
            )
            Text(presentation.label)
                .font(selected ? .qlCaption1Bold : .qlCaption2)
                .foregroundStyle(selected ? Color.qlPrimaryLabel : Color.qlTertiaryLabel)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .animation(.easeOut(duration: 0.15), value: selected)
    }

    private func presentation(for type: ListType) -> ListTypePresentation {
        ListTypePresentation.presentation(for: kind(for: type))
    }

    private func kind(for type: ListType) -> ListTypeKind {
        switch type {
        case .groceries: return .groceries
        case .tasks: return .tasks
        case .ideas: return .ideas
        case .projects: return .projects
        case .favorites: return .favorites
        }
    }
}
