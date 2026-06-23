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
  - `QuickListAdd` — feature US-01 : `AddItemViewModel`, `ListDetailView`.
- **Génération du projet via XcodeGen** (`project.yml`), `.xcodeproj`
  ignoré par git.
- **Test bundle unique** dans `App/QuickListTests/` avec un sous-dossier
  miroir par module (`Core/`, `Analytics/`, `DesignSystem/`, `QuickListAdd/`).

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

- Le deployment target est porté à **iOS 17.5** dans `project.yml` et dans
  tous les `Package.swift` des modules SPM. iOS 17.5 est la première version
  stable contenant tous les symboles SwiftData (`BackingData.setValue`,
  variantes de `#Predicate`) référencés par le binaire compilé avec le
  SDK iOS 26.
- L'engagement `CLAUDE.md` (« Compatibilité : iOS 17 / iPadOS 17 ») est
  préservé au sens majeur (iOS 17.x), avec un plancher mineur explicite.
- Les tests s'exécutent sur le **simulateur iOS 26.1** (iPhone 17 Pro).
- Le code évite quand même les patterns connus pour casser iOS 17.0–17.3
  (ex. `#Predicate` avec optional chaining → remplacé par un filtrage Swift
  explicite, encapsulé dans `AddItemViewModel.itemsBelongingToList(in:)`,
  commenté).
- Une vérification réelle sur device iOS 17.5+ reste à planifier avant
  TestFlight, mais le risque de crash runtime est levé pour la cible
  officiellement supportée.

### Conséquences

- Les tests passent en local et serviront de base CI.
- Risque résiduel : un appel SwiftData ajouté plus tard peut introduire un
  symbole iOS 17.x sans être détecté par les tests iOS 26.1.
- À documenter dans `OPEN-QUESTIONS.md` (`COMPAT-IOS17`) pour pousser
  une vérification device avant la première release.

---

## ADR-004 — Module `QuickListAI` + `LanguageModelService` (US-19)

**Statut** : adoptée, 2026-06-24.

### Contexte

La phase 2 (US-15 → US-18, plus US-07 catégorisation par rayon) repose
sur Foundation Models / Apple Intelligence — disponible uniquement à
partir d'iOS 26 sur device éligible. La décision **ENV-IA**
(`OPEN-QUESTIONS.md`) impose deux contraintes :

1. Tout accès au modèle on-device passe par un **protocole injectable**
   `LanguageModelService` pour rester testable et mockable en CI.
2. Une **stratégie de repli** sans Apple Intelligence (mapping JSON
   local) est livrée AVANT toute feature IA, ce qui fait l'objet de US-19.

### Décision

Créer un module SPM dédié `QuickListAI` qui isole tout le code
intelligent on-device. Posé en US-19, il expose :

- `LanguageModelService` (protocole `Sendable`) avec une méthode
  `classify(itemTitle:) async throws -> ItemClassification`.
- `ItemClassification` + `Rayon` (enum case-iterable couvrant les 9
  rayons standards QuickList alignés sur le `@Guide(.anyOf(...))` du
  modèle Foundation Models documenté dans la spec US).
- `LanguageModelAvailability` (cas `.available` / `.unavailable(reason)`)
  pour que l'UI puisse masquer les fonctions IA.
- `LanguageModelServiceFactory` (`@MainActor`) : détecte l'availability
  au lancement via `#if canImport(FoundationModels)` + `#available(iOS 26.0, *)`,
  puis instancie soit `FoundationModelsLanguageService`, soit
  `LocalRayonMappingService` (fallback).
- `LocalRayonMappingService` : implémentation déterministe basée sur un
  JSON bundlé (`rayon_mapping.json`), normalise les titres
  (lowercase + diacritics-strip), retourne `.autres` si aucun mot-clé
  ne correspond.
- `FoundationModelsLanguageService` : squelette qui délègue au fallback
  pour US-19 (la logique `@Generable` + `LanguageModelSession.respond(...)`
  sera branchée en US-07 / US-15 / US-16).

### Conséquences

- Les call sites (`AddItemViewModel`, futur `RayonClassificationService`)
  consomment uniquement le protocole — aucun import de `FoundationModels`
  hors du module `QuickListAI`.
- La sonde fine via `SystemLanguageModel.availability` (vérification
  Apple Intelligence activé, device éligible) reste à brancher en US-07
  quand on appellera réellement le modèle ; pour US-19 on s'arrête à la
  détection du framework + version OS.
- Le mapping JSON couvre les rayons standards français (alimentation
  courante) ; il sera enrichi en US-07 et US-09 (corrections utilisateur).
- L'UI peut désormais observer `LanguageModelAvailability` pour masquer
  proprement les entrées IA (mic, scan) sur les devices non compatibles.

### Alternatives écartées

- **Coller le code Foundation Models directement dans `AddItemViewModel`**
  : refusé, cassait la testabilité (impossible de mocker FM en CI iOS 17)
  et la séparation par feature.
- **Wrapper `FoundationModels` dans `QuickListCore`** : refusé pour ne
  pas polluer le noyau SwiftData/CloudKit avec une dépendance optionnelle
  fortement plateforme.

---

## ADR-005 — Classification de rayon fire-and-forget (US-07)

**Statut** : adoptée, 2026-06-24.

### Contexte

US-07 demande que le rayon d'un item de liste Courses soit déterminé via
`LanguageModelService` (Foundation Models ou fallback), et que cela ne
retarde JAMAIS la persistance et l'affichage de l'item (cf. CA US-01
« item apparaît immédiatement »). Trois questions s'imposent :

1. Le call modèle (potentiellement de l'ordre de la centaine de ms en
   Foundation Models) doit-il être attendu par le `submit()` du
   ViewModel ?
2. Où instancier la chaîne `LanguageModelService` (et donc l'appel
   d'availability `SystemLanguageModel.availability`) ?
3. Comment garantir que la classification termine même si l'utilisateur
   ferme la `ListDetailView` juste après l'ajout ?

### Décision

- **Pattern fire-and-forget** : `AddItemViewModel.submit()` persiste
  l'item synchroniquement via le repository, puis lance une `Task`
  détachée (`.scheduleClassification`) qui appelle
  `RayonClassificationCoordinator.classify(item, in: list)`. La closure
  capture le coordinator en **fort** (pas `[weak]`) pour que la Task
  termine son travail même si le ViewModel est démonté entre temps.
- **Service créé au niveau `QuickListApp`** (et passé en paramètre à
  `RootView`). Cela garantit une **unique** sonde d'availability au
  lancement et un service partagé entre toutes les surfaces (HomeView,
  toutes les ListDetailView ouvertes ou recréées). Évite la double-sonde
  qui aurait lieu si chaque `RootView.init` re-faisait le travail.
- **Coordinator no-op silencieux sur `list.type != .groceries`** : seules
  les listes de courses appellent le modèle. Économie de batterie et de
  cycles modèle, et ne pollue pas les analytics des autres types.
- **Branchement Foundation Models réel reporté à US-15** : cf.
  `OPEN-QUESTIONS.md` § AI-AVAIL-FINE. US-07 livre l'infrastructure et
  les hooks UI ; US-15 fournira l'appel `LanguageModelSession.respond(...)`
  effectif.
- **UI : regroupement par rayon dans `ListDetailView`** quand
  `list.type == .groceries`. Section par `item.category`, fallback en
  fin de liste pour les items non encore classés ou classés `Autres`.
  Le mode Courses dédié plein écran (US-08) reprendra ce regroupement
  avec un layout adapté aux grandes cibles tactiles en magasin.

### Conséquences

- L'ajout d'item reste **instantané** (CA US-01 préservé).
- La classification s'affiche en différé via `@Query` SwiftData (la
  view se rafraîchit dès que `item.category` est mis à jour).
- Risque : si l'utilisateur supprime un item *avant* que la
  classification termine, le `Task` tentera d'écrire sur un objet
  SwiftData supprimé. À traiter en US-02 (swipe-delete) avec une
  cancellation token, et à minima notée comme dette ici.
- L'analytics `item_classified` est émis APRÈS la persistance — ordre
  important pour ne pas tracer une classification qui n'a pas été
  persistée. À ne pas inverser.

### Alternatives écartées

- **`submit()` async qui attend la classification** : refusé, contredit
  US-01 (ajout instantané) et bloque le focus du champ pour le suivant.
- **Service créé au niveau `RootView.init`** : refusé pour B2 de la
  revue PR #8 (re-init à chaque rebuild SwiftUI). Une factory
  potentiellement réinvoquée n'est pas safe.
- **Mode Courses dédié dès US-07** : refusé pour ne pas charger US-07
  d'un changement de layout structurant. US-08 livre la vue plein écran
  optimisée magasin.
