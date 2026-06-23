# TagManager — Analytics

Liste des événements analytics émis par QuickList via le module SPM
`QuickListAnalytics`. Source de vérité : à mettre à jour **dans le même
commit** que l'implémentation qui émet l'événement (exigence `CLAUDE.md`).

## Format d'un tag

| Colonne | Description |
|--|--|
| `Event` | Nom snake_case stable, jamais renommé une fois publié. |
| `US` | Identifiant de l'US qui l'introduit. |
| `Trigger` | Action utilisateur ou condition système qui le déclenche. |
| `Properties` | Paire `clé:type` des propriétés transmises. Pas de PII. |
| `Module` | Module SPM qui l'émet (`QuickListAdd`, `QuickListLists`, `QuickListShopping`…). |

## Règles

- **Aucune donnée nominative** dans les propriétés (pas de nom de liste, pas
  de contenu d'item, pas d'identifiant utilisateur). Toujours des compteurs,
  catégories, types, durées.
- Un tag = un usage clair. Pas de tag fourre-tout.
- L'émetteur passe systématiquement par le protocole `AnalyticsService`
  (testable, injectable).
- En cas d'échec d'envoi : log via `SwiftLog` (level `warning`), pas de crash.

## Tags actifs

| Event | US | Trigger | Properties | Module |
|--|--|--|--|--|
| `item_added` | US-01 | Soumission validée de l'AddItemBar (Return ou tap `[+]`) | `list_type: string` (valeur de `ListType`) | `QuickListAdd` |
| `item_add_failed` | US-01 | Échec de la persistance lors de l'ajout d'un item | `list_type: string`, `reason: string` (`"persistence"`) | `QuickListAdd` |
| `list_created` | US-03 | Création validée d'une liste depuis la sheet (`Créer`) | `list_type: string` | `QuickListLists` |
| `list_create_failed` | US-03 | Échec de la persistance lors de la création d'une liste | `list_type: string`, `reason: string` (`"persistence"`) | `QuickListLists` |
| `list_opened` | US-04 | Push d'une `ListCard` vers la `ListDetailView` (tap utilisateur) | `list_type: string` | `QuickListLists` |
| `list_renamed` | US-05 | Validation de la sheet de renommage (`Valider`) | `list_type: string` | `QuickListLists` |
| `list_rename_failed` | US-05 | Échec de la persistance lors du renommage d'une liste | `list_type: string`, `reason: string` (`"persistence"`) | `QuickListLists` |
| `list_deleted` | US-05 | Confirmation de l'alert de suppression (`Supprimer`) | `list_type: string` | `QuickListLists` |
| `list_delete_failed` | US-05 | Échec de la persistance lors de la suppression d'une liste | `list_type: string`, `reason: string` (`"persistence"`) | `QuickListLists` |
| `list_sort_changed` | US-06 | Sélection d'un mode de tri depuis le Menu de la NavigationBar | `list_type: string`, `sort_mode: string` (valeur de `SortMode`) | `QuickListAdd` |
| `list_sort_change_failed` | US-06 | Échec de la persistance lors du changement de tri | `list_type: string`, `reason: string` (`"persistence"`) | `QuickListAdd` |
| `language_model_availability_detected` | US-19 | Sonde de la disponibilité Apple Intelligence à `QuickListApp.init` | `is_available: bool`, `reason: string` (`frameworkMissing` / `osVersionTooLow` / etc., présent uniquement si indisponible) | `QuickList` (app) |
| `item_classified` | US-07 | Classification d'un item (fire-and-forget après création) | `list_type: string`, `rayon: string` (valeur de `Rayon`), `matched: bool` (false si retour `Autres`) | `QuickListAdd` |
| `item_classify_failed` | US-07 | Échec de la classification ou de la persistance du rayon | `list_type: string`, `reason: string` (`language_model`) | `QuickListAdd` |

## Tags retirés

_(Aucun retrait pour l'instant. Un tag retiré reste documenté ici 6 mois
minimum pour garder l'historique côté analyse.)_

| Event | US d'origine | Retiré dans | Raison |
|--|--|--|--|
