# TagManager — Analytics

Liste des événements analytics émis par QuickList via le module SPM
`Analytics`. Source de vérité : à mettre à jour **dans le même commit** que
l'implémentation qui émet l'événement (exigence `CLAUDE.md`).

## Format d'un tag

| Colonne | Description |
|--|--|
| `Event` | Nom snake_case stable, jamais renommé une fois publié. |
| `US` | Identifiant de l'US qui l'introduit. |
| `Trigger` | Action utilisateur ou condition système qui le déclenche. |
| `Properties` | Paire `clé:type` des propriétés transmises. Pas de PII. |
| `Module` | Module SPM qui l'émet (`QuickAdd`, `Lists`, `Shopping`…). |

## Règles

- **Aucune donnée nominative** dans les propriétés (pas de nom de liste, pas
  de contenu d'item, pas d'identifiant utilisateur). Toujours des compteurs,
  catégories, types, durées.
- Un tag = un usage clair. Pas de tag fourre-tout.
- L'émetteur passe systématiquement par le protocole `AnalyticsService`
  (testable, injectable).
- En cas d'échec d'envoi : log via `SwiftLog` (level `warning`), pas de crash.

## Tags actifs

_(Aucun tag pour l'instant — la liste se remplit au fur et à mesure des US
implémentées.)_

| Event | US | Trigger | Properties | Module |
|--|--|--|--|--|

## Tags retirés

_(Aucun retrait pour l'instant. Un tag retiré reste documenté ici 6 mois
minimum pour garder l'historique côté analyse.)_

| Event | US d'origine | Retiré dans | Raison |
|--|--|--|--|
