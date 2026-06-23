# QuickListDesignSystem

Module SPM partagé entre l'app et les extensions (widget, partage). Source de
vérité des tokens de couleur, typographie, espacements, rayons, ainsi que des
composants SwiftUI réutilisables.

Le `CLAUDE.md` interdit toute couleur ou string hardcodée — elles passent
toutes par ce module.

## Contenu

- `Colors/Color+Semantic.swift` : palette sémantique (`Color.qlAccent`,
  `Color.qlBackground`, …).
- `Typography/Font+QL.swift` : styles SF Pro via Dynamic Type (`Font.qlBody`,
  `Font.qlAddItemField`, …).
- `Spacing/Spacing+QL.swift` : échelle 4pt (`Spacing.qlS`, `Spacing.qlL`, …).
- `Spacing/Radius+QL.swift` : rayons d'arrondi (`Radius.qlMedium`, …).
- `Components/AddItemBar.swift` : barre de saisie permanente (US-01),
  bouton [+] externe à droite (décision QO-2).
- `Resources/{fr,en}.lproj/Localizable.strings` : strings localisables
  consommés par le design system (FR par défaut, EN en repli). Format
  classique conservé pour US-01 — migration vers `Localizable.xcstrings`
  prévue dès qu'un pluriel sera nécessaire (US-04, `ql.list.itemCount`).

## Convention

Les tokens publics sont exposés via des extensions statiques sur les types
SwiftUI standard (`Color`, `Font`, …) pour rester idiomatiques. Les valeurs
d'espacement et de rayon sont regroupées dans des enums namespace (`Spacing`,
`Radius`).
