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

## Analytics

- `item_added` à chaque ajout réussi (`list_type` en propriété).
- `item_add_failed` quand la persistance échoue (`reason: "persistence"`).
- Aucune propriété PII (pas de titre d'item, pas de nom de liste).
