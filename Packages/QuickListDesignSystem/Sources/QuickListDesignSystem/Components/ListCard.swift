import SwiftUI

public struct ListCard: View {
    private let name: String
    private let presentation: ListTypePresentation
    private let unfinishedCount: Int
    private let subtitle: String

    public init(
        name: String,
        presentation: ListTypePresentation,
        unfinishedCount: Int,
        subtitle: String
    ) {
        self.name = name
        self.presentation = presentation
        self.unfinishedCount = unfinishedCount
        self.subtitle = subtitle
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                Image(systemName: presentation.systemImageName)
                    .symbolRenderingMode(presentation.renderingMode)
                    .font(.system(size: IconSize.qlListTypeActive))
                    .foregroundStyle(presentation.tint)
                    .frame(
                        width: IconSize.qlMinimumTapTarget,
                        height: IconSize.qlMinimumTapTarget,
                        alignment: .leading
                    )
                Spacer(minLength: Spacing.qlS)
                if unfinishedCount > 0 {
                    countBadge
                }
            }
            Spacer(minLength: Spacing.qlS)
            Text(name)
                .font(.qlHeadline)
                .foregroundStyle(Color.qlPrimaryLabel)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            Text(subtitle)
                .font(.qlFootnote)
                .foregroundStyle(Color.qlSecondaryLabel)
                .lineLimit(1)
                .padding(.top, Spacing.qlXXS)
        }
        .padding(Spacing.qlL)
        .frame(maxWidth: .infinity, minHeight: 110, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: Radius.qlMedium, style: .continuous)
                .fill(Color.qlSurface)
        )
        .qlShadow(Shadow.qlCard)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(QuickListStrings.listCardAccessibility(
            typeLabel: presentation.label,
            name: name,
            unfinishedCount: unfinishedCount
        ))
    }

    private var countBadge: some View {
        Text("\(unfinishedCount)")
            .font(.qlBadgeCount)
            .foregroundStyle(Color.white)
            .padding(.horizontal, Spacing.qlS)
            .padding(.vertical, Spacing.qlXXS)
            .background(
                Capsule()
                    .fill(Color.qlAccent)
            )
            .accessibilityHidden(true)
    }
}
