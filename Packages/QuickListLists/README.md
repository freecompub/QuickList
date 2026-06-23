# QuickListLists

Module dédié à la gestion des listes : création (US-03), affichage de
l'ensemble (US-04), renommage et suppression (US-05). Le module héberge ses
ViewModels, ses vues SwiftUI et ses tests d'intégration aux protocoles
`TaskListRepository` de `QuickListCore`.

## Couverture US-03

- `CreateListViewModel` : porte le nom saisi, le type sélectionné, et
  expose `create()` qui appelle `TaskListRepository.create(name:type:)`.
  Dépend du protocole, donc injectable et entièrement testable.
- `CreateListSheet` : présentation modale SwiftUI conforme au mockup
  `docs/design/mockups/create-list-sheet.md` — TextField pour le nom,
  sélecteur de type à 5 entrées, preview live, validation visible.
- Analytics : événement `list_created` (`list_type` en propriété).

## Architecture MVVM

- **View** (`CreateListSheet`, `ListTypeSelector`) : pure SwiftUI, ne lit
  ni n'écrit le `ModelContext` directement.
- **ViewModel** (`CreateListViewModel`) : `ObservableObject` sur `@MainActor`,
  expose `name`, `selectedType`, `canCreate`, `lastError`.
- **Repository** : `TaskListRepository` injecté, implémenté dans
  `QuickListCore` via `SwiftDataTaskListRepository`.

## Design System

Les icônes et libellés des types de liste viennent du DS
(`ListTypePresentation` dans `QuickListDesignSystem`) afin que toutes les
surfaces qui montrent un `ListType` (sheet de création, ListCard, etc.) en
gardent le même rendu.
