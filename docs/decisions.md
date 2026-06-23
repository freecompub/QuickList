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

---

## ADR-003 — Suppression-puis-restore par snapshot (vs tombstone)

**Statut** : adoptée, 2026-06-23.

### Contexte

US-02 demande une suppression « réversible quelques secondes ». Deux
implémentations classiques :

- **Tombstone** : marquer l'item `isDeleted = true` (champ ajouté au modèle
  `ListItem`), filtrer dans les `@Query`, et le supprimer définitivement à
  l'expiration du toast.
- **Snapshot / restore** : supprimer immédiatement de SwiftData, conserver
  une copie sérialisable (titre, catégorie, isDone, createdAt) en mémoire
  le temps de l'undo, et la rejouer via le repository si l'utilisateur
  annule.

### Décision

Adopter la stratégie **snapshot / restore** :

- `ListItemSnapshot` (struct `Sendable`) capture les champs métier de
  `ListItem` (sans `persistentModelID` qui sera regénéré).
- `ListItemRepository.delete(_:)` supprime tout de suite via
  `ModelContext.delete` + `save`.
- `ListItemRepository.restore(_:in:)` ré-insère un nouveau `ListItem` avec
  les valeurs du snapshot, en **conservant le `createdAt`** original pour
  préserver l'ordre dans la liste.
- `ListItemActionsViewModel` orchestre : timer de 4 s, événement
  `item_deleted` à expiration, `item_delete_undone` à la restauration.

### Conséquences

- L'UI ne porte aucune connaissance du « tombstone » (filtre @Query
  simplifié, code prédictible).
- Le modèle `ListItem` reste minimal — pas de pollution par un flag
  technique.
- L'item restauré a un **nouveau `persistentModelID`** : neutre tant qu'on
  est mono-device, mais devra être documenté pour US-10/US-11 (sync iCloud)
  car la chaîne CloudKit verra : delete → create.

### Alternatives écartées

- **Tombstone** : refusé pour ne pas alourdir le modèle, pour ne pas avoir
  à filtrer chaque `@Query`, et pour ne pas devoir purger périodiquement
  les items définitivement supprimés.
- **CoreData / NSPersistentHistory** : surdimensionné pour ce besoin
  immédiat.

### À surveiller (cf. `OPEN-QUESTIONS.md` § SYNC-UNDO à ouvrir avec US-10)

- Si un autre device supprime aussi l'item entre `delete` local et `restore`
  local, la résolution de conflit CloudKit doit accepter le doublon ou
  rejeter le restore. Voir US-10/US-11.
- L'`UndoToast` est porté en mémoire seulement. Un kill de l'app pendant
  les 4 s entraîne une suppression définitive sans avertissement
  utilisateur — acceptable pour la promesse « quelques secondes ».

### Conséquences

- Les tests passent en local et serviront de base CI.
- Risque résiduel : un appel SwiftData ajouté plus tard peut introduire un
  symbole iOS 17.x sans être détecté par les tests iOS 26.1.
- À documenter dans `OPEN-QUESTIONS.md` (`COMPAT-IOS17`) pour pousser
  une vérification device avant la première release.
