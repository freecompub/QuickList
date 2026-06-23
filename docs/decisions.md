# QuickList — Decisions (ADR)

Journal des décisions techniques non triviales. Format ADR léger :
contexte, décision, conséquences.

---

## ADR-001 — Structure SPM modulaire posée par US-01

**Statut** : adoptée, 2026-06-23.

### Contexte

US-01 ("ajouter un item en une frappe") est la première user story
implémentée et le projet ne contient encore aucun code Swift. Le `CLAUDE.md`
exige une architecture modulaire, MVVM et protocol-oriented, avec une
séparation stricte `core / services / api / ui / tests`. Choisir une
structure conditionne tout le reste du backlog.

### Décision

- **App cible mince** dans `App/QuickList/` : seulement `QuickListApp`
  (`@main`, `ModelContainer`) et un `RootView` d'assemblage.
- **Quatre modules SPM locaux** sous `Packages/` :
  - `QuickListCore` — modèles SwiftData (`TaskList`, `ListItem`,
    `ListType`, `SortMode`) et protocoles de persistance
    (`ListItemRepository`).
  - `QuickListAnalytics` — protocole `AnalyticsService` + implémentation
    SwiftLog par défaut.
  - `QuickListDesignSystem` — tokens couleur/typo/spacing, composants
    partagés (`AddItemBar`), strings localisées.
  - `QuickAdd` — feature US-01 : `AddItemViewModel`, `ListDetailView`.
- **Génération du projet via XcodeGen** (`project.yml`), `.xcodeproj`
  ignoré par git.
- **Test bundle unique** dans `App/QuickListTests/` avec un sous-dossier
  miroir par module (`Core/`, `Analytics/`, `DesignSystem/`, `QuickAdd/`).

### Conséquences

- Toute nouvelle feature suit le même schéma (un module SPM par feature).
- Les ViewModels sont triviaux à tester via mocks de protocoles.
- L'app peut grossir sans qu'un fichier ne devienne fourre-tout.
- Le `.xcodeproj` non versionné évite les conflits de merge sur des fichiers
  générés.

### Alternatives écartées

- **Un seul module mono-target** : rejeté, contredit la règle de séparation
  du `CLAUDE.md` et empêcherait l'isolation par feature.
- **SPM testTargets dédiés par package** : rejeté car les tests SPM iOS-only
  ne s'exécutent pas via `xcodebuild test` sur le scheme de l'app, et la
  duplication d'effort pour les exécuter séparément n'apporte pas de valeur
  pour l'instant. Consolidation dans `App/QuickListTests/` avec sous-dossier
  par module préserve la séparation visuelle.

---

## ADR-002 — Test des SwiftData APIs sur simulateur iOS 26.1, pas iOS 17.0

**Statut** : adoptée, 2026-06-23.

### Contexte

Le `CLAUDE.md` cible iOS 17 / iPadOS 17 / macOS 14. Le simulateur iOS 17.0
disponible localement ne contient pas tous les symboles Swift de SwiftData
introduits ultérieurement (notamment `BackingData.setValue` pour les
relations 1-N et certains opérateurs `#Predicate` avec optional chaining).
Compilé avec le SDK iOS 26, le binaire référence ces symboles et plante au
runtime sur iOS 17.0.

### Décision

- Le deployment target reste **iOS 17.0** (cible large, exigée par
  `CLAUDE.md`).
- Les tests s'exécutent sur le **simulateur iOS 26.1** (iPhone 17 Pro) pour
  que tous les symboles SwiftData soient présents au runtime.
- Le code évite les patterns connus pour casser iOS 17.0 quand possible
  (ex. `#Predicate` avec optional chaining → remplacé par filtrage Swift sur
  les résultats de `@Query`).
- Une vérification réelle sur device iOS 17.0 reste à planifier avant toute
  livraison TestFlight pour confirmer l'absence de symboles manquants à
  l'usage.

### Conséquences

- Les tests passent en local et serviront de base CI.
- Risque résiduel : un appel SwiftData ajouté plus tard peut introduire un
  symbole iOS 17.x sans être détecté par les tests iOS 26.1.
- À documenter dans `OPEN-QUESTIONS.md` (`COMPAT-IOS17`) pour pousser
  une vérification device avant la première release.
