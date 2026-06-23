# QuickListAI

Module SPM qui isole tout le code intelligent on-device (Apple Intelligence,
Foundation Models, classification d'items, etc.) derrière des protocoles
mockables.

Posé en US-19 conformément à la décision **ENV-IA** (`OPEN-QUESTIONS.md`) :
US-19 livre l'infrastructure (protocole + fallback JSON local + check
d'availability) qui sera ensuite consommée par US-07 (tri par rayon) et
US-15 → US-18 (capture, vocal, scan, auto-routage).

## Contenu

- `LanguageModelService` (protocole) : classification d'un titre d'item
  vers un rayon (`ItemClassification`). Toute consommation passe par ce
  protocole pour rester testable.
- `ItemClassification` (struct `Sendable`) : sortie du modèle
  (rayon parmi les 9 rayons standards QuickList, `confidence`).
- `LanguageModelAvailability` : `.available` / `.unavailable(reason)`,
  source unique de la disponibilité d'Apple Intelligence pour le
  fonctionnel UI (masquage des fonctions IA).
- `LanguageModelServiceFactory` : choisit l'implémentation appropriée au
  runtime — `FoundationModelsLanguageService` si Foundation Models est
  disponible et iOS 26+, sinon `LocalRayonMappingService`.
- `LocalRayonMappingService` : fallback déterministe basé sur un JSON
  bundlé (`rayon_mapping.json`). Aucune dépendance externe — fonctionne
  sur tous les devices iOS 17.5+.
- `FoundationModelsLanguageService` : implémentation à venir (US-07 / US-15+)
  utilisant `SystemLanguageModel`. Pour US-19 : squelette qui rapporte
  l'availability et passe le relais au fallback si indisponible.

## Architecture

```
Application
    │
    ▼
LanguageModelServiceFactory.make() ──► LanguageModelService (protocole)
                                              │
                       ┌──────────────────────┴────────────────────┐
                       ▼                                            ▼
        FoundationModelsLanguageService              LocalRayonMappingService
        (iOS 26+, Apple Intelligence)                (toujours dispo, JSON)
```

Le caller ne sait jamais quelle implémentation est utilisée : il consomme
le protocole. Les tests injectent un mock.

## Conventions

- Aucun import direct de `FoundationModels` dans le code consommateur.
- L'availability est vérifiée UNE fois au lancement par le factory, et
  les Views observent un `LanguageModelAvailability` exposé par le ViewModel
  pour masquer / afficher leurs entrées IA (mic, scan, etc.).
- Toutes les classifications sont `async throws` pour ne jamais bloquer
  le main thread.
