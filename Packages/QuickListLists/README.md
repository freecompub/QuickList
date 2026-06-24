# QuickListLists

Module dédié à la gestion des listes : création (US-03), affichage de
l'ensemble (US-04), renommage et suppression (US-05). Le module héberge ses
ViewModels, ses vues SwiftUI et ses tests d'intégration aux protocoles
`TaskListRepository` de `QuickListCore`.

## Couverture US-05

- `ListOptionsViewModel` : `draftName`, `canRename`, `rename()`, `delete()`,
  `lastError`, `didRename`, `didDelete`. Émet `list_renamed` / `list_deleted`
  / `list_rename_failed` / `list_delete_failed` via `QuickListAnalytics`.
- `RenameListSheet` : sheet medium/large, TextField focus auto, bouton
  « Valider » conditionnel sur `canRename`, `.alert` localisée pour les
  erreurs, dismiss automatique sur `didRename`.
- `HomeView` ajoute un `.contextMenu` (long-press) sur chaque `ListCard`
  avec entrées « Renommer » (présente la sheet) et « Supprimer » (présente
  une `.alert` de confirmation destructive). La suppression cascade les
  items via `@Relationship(deleteRule: .cascade)`.

## Couverture US-04

- `HomeViewModel` : expose `unfinishedItemsCount(in:)`, `totalItemsCount(in:)`,
  `subtitle(for:)` (en passant par `QuickListStrings.itemCount(_:)`),
  `presentation(for:)` (mappe `ListType` → `ListTypePresentation`), et
  `listDidOpen(_:)` (analytics `list_opened`).
- `HomeView<DetailContent>` : `@Query` SwiftData des `TaskList`, grille
  `LazyVGrid` de `ListCard`, empty state localisé, `NavigationLink(value:)`
  + `.navigationDestination(for: TaskList.self)` paramétré par un closure
  pour découpler le push (pas de couplage à `QuickListAdd`).

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
