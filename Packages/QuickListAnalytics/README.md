# QuickListAnalytics

Module générique d'analytics pour QuickList. Le `CLAUDE.md` exige que toutes
les actions utilisateur significatives soient tracées via ce module — et que
les tags soient maintenus dans `docs/TagManager.md`.

## Contenu

- `AnalyticsEvent` : valeur immuable qui identifie un événement et porte ses
  propriétés non-PII.
- `AnalyticsService` : protocole injectable et mockable utilisé partout dans
  l'app et les modules métier.
- `LoggingAnalyticsService` : implémentation par défaut basée sur `SwiftLog`.
  Aucun envoi réseau pour l'instant — l'événement est journalisé localement,
  suffisant pour la vérification et la migration vers un fournisseur réel
  plus tard.

## Règle

Aucune propriété PII (nom de liste, contenu d'item, identifiant utilisateur)
ne doit transiter dans un `AnalyticsEvent`.
