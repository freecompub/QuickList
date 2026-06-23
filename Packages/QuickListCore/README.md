# QuickListCore

Module noyau de QuickList. Contient les modèles `@Model` SwiftData partagés
par toute l'application et les protocoles de persistance qui les manipulent.

## Contenu

- `TaskList`, `ListItem` : modèles SwiftData compatibles CloudKit
  (pas de `@Attribute(.unique)`, valeurs par défaut, relations optionnelles).
- `ListType`, `SortMode` : énumérations métier.
- `ListItemRepository` (protocole) + `SwiftDataListItemRepository`
  (implémentation) : accès aux items, injecté dans les ViewModels.
- `TaskListRepository` (protocole) + `SwiftDataTaskListRepository`
  (implémentation) : accès aux listes — `fetchAll`, `create`, `rename`,
  `delete`. La suppression cascade les `ListItem` via la `@Relationship`
  côté modèle. `TaskListRepositoryError.emptyName` est levé si le
  renommage trim sur une chaîne vide.

## Règle d'architecture

Aucun accès SwiftData direct depuis une `View`. Toute mutation des modèles
passe par une implémentation de `ListItemRepository`.
