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
  (implémentation) : accès aux listes, utilisé notamment par le bootstrap
  d'app pour vérifier l'existence d'une liste de démarrage.

## Règle d'architecture

Aucun accès SwiftData direct depuis une `View`. Toute mutation des modèles
passe par une implémentation de `ListItemRepository`.
