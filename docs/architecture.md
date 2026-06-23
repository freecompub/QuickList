# QuickList — Architecture

Document de référence des choix structurants. Tenu à jour à chaque US qui
modifie la cartographie des modules ou les frontières de responsabilité.

## Vue d'ensemble

QuickList est une application iOS native pure SwiftUI / SwiftData, organisée
autour d'une **app cible mince** et de **modules SPM locaux** qui portent
chacun une responsabilité claire. L'architecture est MVVM, protocol-oriented,
modulaire et testable.

```
QuickList.xcodeproj (généré par XcodeGen)
├── App/QuickList                 ← app iOS, cible mince
│   ├── QuickListApp.swift        ← @main, configure ModelContainer
│   ├── RootView.swift            ← assemblage haut niveau
│   └── Resources/                ← Assets.xcassets, app icon, accent
├── Packages/                     ← modules SPM locaux
│   ├── QuickListCore             ← modèles SwiftData + protocoles persistance
│   ├── QuickListAnalytics        ← AnalyticsService (SwiftLog)
│   ├── QuickListDesignSystem     ← tokens + composants UI partagés
│   └── QuickAdd                  ← feature US-01 (ajout ultra-rapide)
└── App/QuickListTests            ← test bundle unique, sous-dossier par module
```

## Règles de découpage

- **Une feature = un module SPM.** Le module porte son View, son ViewModel,
  ses Services internes et son README.
- **Pas d'accès direct à SwiftData ou CloudKit dans une `View`.** Toute
  mutation passe par un protocole défini dans `QuickListCore`
  (`ListItemRepository`).
- **Pas de View partagée directement entre modules** — les composants
  réutilisables vivent dans `QuickListDesignSystem`.
- **Une déclaration de premier niveau par fichier** (`class`, `struct`,
  `enum`, `protocol`). Pas de regroupement « par convenance ».
- **300 lignes max par fichier**, sauf justification écrite (commit ou ADR).

## MVVM

- `View` : pure SwiftUI, déclarative, ne contient pas de logique métier.
- `ViewModel` : porte l'état UI (`@Published`), orchestre les appels
  Repository/Service, et expose des intentions (`submit`, `toggle`, …).
- `Repository / Service` : protocoles dans `QuickListCore` ou le module
  concerné. Implémentations SwiftData / CloudKit / Foundation Models
  injectées. Mockables dans les tests.

## Modèles SwiftData (CloudKit-ready)

Définis dans `QuickListCore`. Contraintes obligatoires (cf.
`docs/UserStories/QuickList_user_stories.md` § "Modèle de données") :

- Pas de `@Attribute(.unique)` (interdit avec CloudKit).
- Toute propriété a une valeur par défaut.
- Les relations sont optionnelles.
- Relations 1-N avec `@Relationship(deleteRule: .cascade, inverse: ...)`.

## Analytics

Tout choix utilisateur significatif émet un `AnalyticsEvent` via
`AnalyticsService` (protocole défini dans `QuickListAnalytics`). L'implémentation
par défaut, `LoggingAnalyticsService`, journalise via SwiftLog ; aucun envoi
réseau pour l'instant. Aucune propriété PII n'est transmise. Le catalogue des
événements vit dans `docs/TagManager.md`.

## Design System

Le module `QuickListDesignSystem` est la **source de vérité** des couleurs,
typographies, espacements et composants partagés (`AddItemBar`, `ListRow`…).
Toute couleur ou string ne provenant pas de ce module est interdite dans
le reste du code.

## Tests

Un seul test bundle d'app (`App/QuickListTests/`), organisé par sous-dossier
miroir des modules. Cette consolidation contourne le fait que les tests de
modules SPM iOS-only ne s'exécutent pas via `xcodebuild test` sur le scheme
de l'app. Les tests utilisent uniquement les API publiques des modules — pas
de `@testable import` cross-module — pour valider que la frontière publique
est suffisante.

## Génération du projet

`project.yml` (XcodeGen) décrit la cible app et ses dépendances locales sur
les packages. Le `.xcodeproj` est régénéré à la demande
(`xcodegen generate`) et n'est pas versionné.
