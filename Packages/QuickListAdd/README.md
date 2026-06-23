# QuickListAdd

Module dédié à l'expérience d'ajout ultra-rapide d'items (US-01). Il fournit
la `ListDetailView` qui affiche les items d'une `TaskList` et héberge la
`AddItemBar` permanente en bas d'écran.

## Architecture MVVM

- **View** (`ListDetailView`) : pure SwiftUI, ne mute pas le `ModelContext`
  SwiftData directement. Elle reçoit un `AddItemViewModel` via factory
  (closure) et délègue le filtrage au ViewModel.
- **ViewModel** (`AddItemViewModel`) : porte l'état du champ de saisie
  (`pendingTitle`), l'état d'erreur exposé (`lastError`), et orchestre la
  soumission. Il dépend d'un `ListItemRepository` et d'un `AnalyticsService`
  injectés via protocole, donc entièrement testable. Il expose aussi
  `itemsBelongingToList(in:)` pour filtrer les items SwiftData côté Swift
  (au lieu d'un `#Predicate` problématique sur iOS 17.0-17.4 — cf. ADR-002).
- **Repository** : implémentation SwiftData fournie par `QuickListCore`
  (`SwiftDataListItemRepository`).

## Couverture US-01

- CA : champ d'ajout toujours visible → `AddItemBar` ancré en bas du `VStack`.
- CA : item apparaît immédiatement → `SwiftDataListItemRepository.create`
  insère et sauvegarde dans la même transaction synchrone, `@Query` rafraîchit.
- CA : champ se vide mais garde le focus → `pendingTitle` remis à "" et
  `@FocusState` réaffirmé après chaque ajout.
- CA : aucun pop-up ni formulaire → soumission par `onSubmit` du `TextField`
  ou tap sur le bouton externe `[+]` (qui reste tappable même champ vide
  pour rappeler le focus).

## Suppression et annulation (US-02)

- `ListItemActionsViewModel` orchestre la suppression d'un item via swipe :
  - `delete(_:)` supprime immédiatement de SwiftData (via `ListItemRepository`)
    et démarre un `Task` de 4 s. `pendingUndo` porte le snapshot.
  - `undoLastDeletion()` re-crée l'item depuis le snapshot dans la même
    `TaskList` (createdAt préservé pour conserver le tri).
  - `commitPendingDeletion()` (appelé par le timer ou exposé pour tests)
    confirme définitivement la suppression et émet `item_deleted`.
- L'`UndoToast` du DesignSystem s'affiche en overlay tant que `pendingUndo`
  est non nil. Tap sur « Annuler » déclenche `undoLastDeletion`.

## Analytics

- `item_added` — ajout réussi (`list_type`).
- `item_add_failed` — échec persistance ajout (`list_type`, `reason`).
- `item_deleted` — suppression définitive (`list_type`).
- `item_delete_undone` — annulation utilisateur (`list_type`).
- `item_delete_failed` — échec persistance suppression (`list_type`, `reason`).
- `item_delete_undo_failed` — échec persistance restore (`list_type`, `reason`).
- Aucune propriété PII (pas de titre d'item, pas de nom de liste).
