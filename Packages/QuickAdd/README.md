# QuickAdd

Module dédié à l'expérience d'ajout ultra-rapide d'items (US-01). Il fournit
la `ListDetailView` qui affiche les items d'une `TaskList` et héberge la
`AddItemBar` permanente en bas d'écran.

## Architecture MVVM

- **View** (`ListDetailView`) : pure SwiftUI, ne lit/écrit pas le `ModelContext`
  SwiftData directement. Elle consomme un `AddItemViewModel` et le `@Query`
  SwiftData pour la lecture des items affichés.
- **ViewModel** (`AddItemViewModel`) : porte l'état du champ de saisie
  (`pendingTitle`) et orchestre la soumission. Il dépend d'un
  `ListItemRepository` et d'un `AnalyticsService` injectés via protocole,
  donc entièrement testable.
- **Repository** : implémentation SwiftData fournie par `QuickListCore`
  (`SwiftDataListItemRepository`).

## Couverture US-01

- CA : champ d'ajout toujours visible → `AddItemBar` ancré en bas.
- CA : item apparaît immédiatement → `SwiftDataListItemRepository.create`
  insère et sauvegarde dans la même transaction synchrone, `@Query` rafraîchit.
- CA : champ se vide mais garde le focus → `pendingTitle` remis à "" et
  `@FocusState` réaffirmé après chaque ajout.
- CA : aucun pop-up ni formulaire → soumission par `onSubmit` du `TextField`
  ou tap sur le bouton externe `[+]`.

## Analytics

L'événement `item_added` est émis à chaque ajout réussi. Aucune propriété PII.
