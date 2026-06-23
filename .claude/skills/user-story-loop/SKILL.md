---
name: user-story-loop
description: Pilote l'implémentation autonome et EN BOUCLE PERPÉTUELLE des user stories de QuickList (docs/UserStories/QuickList_user_stories.md, CLAUDE.md, docs/ROADMAP.md). Pour chaque US, elle crée une branche, développe en Swift 6 (SwiftData + CloudKit + MVVM), écrit les tests XCTest, vérifie SwiftLint + build + tests, commit, ouvre une PR, la fait relire par l'agent code-reviewer, corrige les retours, re-vérifie, demande l'autorisation explicite de merge (exigence stricte du CLAUDE.md) — PUIS ENCHAÎNE IMMÉDIATEMENT sur l'US suivante éligible SANS attendre le GO. La boucle ne s'arrête jamais tant qu'il reste une US faisable : les PR awaiting-merge s'empilent (stacked PRs) jusqu'à ce que l'utilisateur donne le GO. Quand un GO arrive, merge en arrière-plan et continue. À utiliser DÈS QUE l'utilisateur demande de développer, implémenter, « boucler » ou « terminer » les US / le backlog QuickList, ou de continuer le développement jusqu'à ce que tout soit fini via un flux branche → PR → revue → autorisation → merge.
---

# User Story Loop — QuickList

Ce skill fait avancer QuickList en **bouclant sur les user stories** du cahier des
charges jusqu'à ce qu'il n'en reste plus d'éligible. Le principe : une boucle
disciplinée — une US à la fois sur la branche, complètement terminée et vérifiée
avant de passer à la suivante — qui ne s'interrompt **jamais**. Même la demande
d'autorisation de merge (exigence non négociable du `CLAUDE.md`) ne suspend pas
la boucle : on affiche la demande, on marque la PR `awaiting-merge`, et on
enchaîne immédiatement sur l'US suivante éligible. Les PR en attente d'autorisation
s'**empilent** (stacked PRs) — chaque nouvelle US qui dépend d'une US
`awaiting-merge` se branche depuis la branche de cette dernière, pas depuis
`main`. Quand l'utilisateur donne un GO, on traite le merge sans casser le flux
courant puis on continue.

**Règle d'or** : la boucle ne s'arrête JAMAIS d'elle-même. Elle ne rend la main
que si (a) il ne reste vraiment plus aucune US faisable (tout `done`, `blocked`,
ou `awaiting-merge` sans descendance possible) ou (b) l'utilisateur demande
explicitement de stopper.

## Pourquoi une boucle disciplinée plutôt qu'un sprint en vrac

Implémenter « tout d'un coup » produit du code à moitié testé, des régressions, et
des US qu'on croit finies mais qui ne respectent pas leurs critères d'acceptation.
La boucle force l'inverse : chaque US franchit la Definition of Done (DoD) avant
qu'on touche à la suivante. Le résultat est livrable à tout moment.

## 0. Localiser le cahier des charges

Avant de commencer, repérer les fichiers de spec (à la racine du dépôt
`/Users/salili/Projets/QuickList`) :

- `CLAUDE.md` — contraintes du projet, **architecture MVVM**, interdictions, et la
  procédure par US (§"Workflow de développement d'une User Story"). Sert aussi de
  Definition of Done.
- `docs/UserStories/QuickList_user_stories.md` — **fichier unique** contenant
  toutes les US (`US-01` à `US-21`), regroupées par section (Ajout, Listes, Tri,
  Mode Courses, Sync, Widgets, Foundation Models, Bonus). Le modèle SwiftData et
  les contrats Foundation Models y figurent aussi.
- `docs/ROADMAP.md` — ordre des phases MVP / IA / Bonus. À créer si absent en
  recopiant l'ordre des sections du fichier US et en groupant par priorité (MVP,
  puis IA, puis Bonus).
- `docs/design/` — design system validé v0.2 (tokens, mockups, workflow,
  app icon P1). À respecter dans toute implémentation UI.
- `docs/TagManager.md` — liste des tags analytics. À maintenir à chaque US qui
  introduit un événement utilisateur.

Si l'un de ces fichiers manque, le créer (ROADMAP, TagManager) ou demander à
l'utilisateur où trouver l'info avant de boucler. **Ne pas inventer d'US.**

**Pré-requis Git/PR/Xcode.** Le cycle s'appuie sur :
- Un dépôt Git avec la branche de base `main` et la CLI `gh` (GitHub)
  authentifiée pour créer les PR. Le merge se fait via `gh pr merge` uniquement
  après autorisation humaine (§3.11). Vérifier au démarrage : `git status` (arbre
  propre), `gh auth status`. Si `gh` n'est pas disponible, le signaler — pas de
  merge local pour ce projet (la PR est obligatoire d'après le `CLAUDE.md`).
- `xcodegen`, `xcodebuild`, `swiftlint` installés. Si l'un manque, l'installer
  via `brew` avant de continuer ou marquer un blocage (`blocked:needs-human`).
- Toujours repartir d'une base à jour : `git switch main && git pull` avant de
  créer une branche.

## 1. Tenir un registre de progression

Maintenir un fichier `PROGRESS.md` à la racine. Le créer s'il n'existe pas en
scannant les identifiants `**US-NN**` du fichier
`docs/UserStories/QuickList_user_stories.md`. Une ligne par US :

```
| ID    | Phase | Statut             | Tentatives | PR | Note |
|-------|-------|--------------------|-----------|----|------|
| US-01 | MVP   | done               | 1         | #3 | |
| US-02 | MVP   | awaiting-merge     | 1         | #4 | en attente GO |
| US-07 | MVP   | blocked:needs-human| 0         |    | exige iOS 26 simu, voir OPEN-QUESTIONS |
| US-08 | MVP   | in-progress        | 1         |    | |
| US-15 | IA    | todo               | 0         |    | |
```

Statuts :
- `todo` — pas encore commencée
- `in-progress` — en cours de dev sur sa branche
- `awaiting-merge` — PR ouverte, CI verte, review OK, **attend le GO utilisateur**
- `done` — mergée
- `blocked:test` — échec après le budget d'essais (§5)
- `blocked:dep` — dépend d'une US non `done`
- `blocked:needs-human` — ambiguïté, asset manquant, ou capacité système requise
  (ex. Foundation Models exige iOS 26, partage CloudKit exige config compte)

Mettre à jour ce registre à CHAQUE changement d'état. C'est la mémoire de la
boucle.

## 2. Sélectionner la prochaine US éligible

Choisir la première US qui satisfait TOUTES ces conditions :

1. Statut `todo`.
2. Sa phase est la plus prioritaire ouverte (ordre `ROADMAP.md` : **MVP →
   Foundation Models (IA) → Bonus**).
3. Toutes ses dépendances sont en statut `done` **OU `awaiting-merge`**.
   Une dépendance `awaiting-merge` est traitée comme satisfaite : on
   se branche depuis la branche de cette US (stacked PRs) au lieu de `main`.
   Dépendances connues :
   - US-02 dépend de US-01
   - US-04/05 dépendent de US-03
   - US-08/09 dépendent de US-03 (type Courses) et US-07
   - US-13 dépend de US-12 (widget)
   - US-15→US-18 dépendent de l'infrastructure Foundation Models posée par US-07
   - US-21 (partage) dépend de la sync US-10/11

Si aucune US `todo` n'a ses dépendances satisfaites mais que des dépendances
sont `blocked`, marquer les US dépendantes `blocked:dep` et continuer.

**Ne JAMAIS s'arrêter parce qu'il reste des PR `awaiting-merge`.** Si toutes les
US restantes dépendent d'une chaîne `awaiting-merge`, continuer à les
implémenter en empilant les branches (stacked PRs). On ne s'arrête que quand il
ne reste vraiment aucune US faisable (cf. §7).

## 3. Le cycle d'une US (à répéter en boucle)

Pour l'US sélectionnée, dérouler ce cycle complet, dans l'ordre. Chaque US suit
le même circuit : branche → modèle/DS → développement MVVM → tests → SwiftLint +
build vert → commit + PR → revue par l'agent reviewer → corrections → re-build
vert → **notification de demande de merge** → **enchaînement immédiat sur l'US
suivante** (la PR reste `awaiting-merge` jusqu'à GO humain, traité §14 de
manière asynchrone).

1. **Choisir l'US** (section 2). Passer son statut à `in-progress` dans
   `PROGRESS.md`, incrémenter `Tentatives`.

2. **Créer une branche.** Choix de la base :
   - Si toutes les dépendances sont `done` : base = `main` à jour
     (`git switch main && git pull`).
   - Si une dépendance est `awaiting-merge` : base = la branche de cette US
     (PR la plus récente dans la chaîne). Récupérer la branche distante
     (`git fetch origin && git switch <branche-dep>` puis `git pull`).
   Puis `git switch -c feat/US-NN-<slug>` (ex. `feat/US-01-ajout-rapide`).
   Une US = une branche. **Ne JAMAIS pousser sur `main`.**
   Noter la base dans `PROGRESS.md` (colonne Note : `base: <branche>`) pour
   pouvoir rebase plus tard quand les PR amont seront mergées.

3. **Modèle de données et Design System d'abord.**
   - Si l'US ajoute/modifie un champ SwiftData : mettre à jour le modèle
     (`@Model`) en respectant les contraintes CloudKit listées dans le fichier
     US (§"Modèle de données") — pas de `@Attribute(.unique)`, valeur par
     défaut sur chaque propriété, relations optionnelles.
   - Si l'US touche à l'UI : utiliser strictement les tokens et composants du
     module SPM `QuickListDesignSystem` (`docs/design/design-system.md`). Aucune
     couleur ni string hardcodée. Si un token ou un composant manque, l'ajouter
     au module DS en premier.
   - Si l'US introduit un nouveau module : créer un package SPM dédié, mettre à
     jour `project.yml` (XcodeGen), regénérer le projet (`xcodegen generate`),
     écrire son `README.md`.

4. **Développer par couches MVVM.** Suivre l'architecture imposée par le
   `CLAUDE.md` (`core`, `services`, `api`, `ui`, `tests`). Aucun accès direct au
   `ModelContext` SwiftData ni à CloudKit dans une View — passer par un
   ViewModel / Service. Protocol-oriented : les dépendances externes (modèle
   IA, persistance, sync) sont injectées via protocole pour les tests. Aucun
   fichier > 300 lignes sans justification. Une classe / struct / enum par
   fichier.

5. **Logs et analytics.**
   - Toute branche d'erreur passe par `SwiftLog`. Pas de `print`.
   - Tout choix significatif de l'utilisateur (création de liste, ajout item,
     coche, mode Courses, dictée, scan, partage…) émet un événement via le
     module `Analytics` (SPM). Ajouter le tag à `docs/TagManager.md` dans le
     même commit.

6. **Écrire les tests.** Traduire chaque critère d'acceptation (CA) de l'US en
   test exécutable :
   - **Unitaire** (logique métier, ViewModels) : XCTest ou Swift Testing.
   - **Intégration SwiftData** : container in-memory, vérifier les
     persistances et cascades.
   - **Snapshot / UI** : si l'US touche un écran critique (mode Courses,
     AddItemBar), un test de snapshot par taille (compact / regular).
   - **Foundation Models** : mocker via protocole (US-19 garantit un fallback,
     donc le mock teste les deux chemins).

7. **S'assurer que ça lint, build et que les tests passent.** Lancer dans
   l'ordre :
   ```
   swiftlint --strict
   xcodebuild -scheme QuickList -destination 'platform=iOS Simulator,name=iPhone 15' build
   xcodebuild -scheme QuickList -destination 'platform=iOS Simulator,name=iPhone 15' test
   ```
   Plus, si l'US touche au target Mac ou aux widgets, le scheme correspondant.
   **Tout doit être vert, zéro warning SwiftLint, zéro warning compilateur.**
   Corriger jusqu'au vert (budget §5).

8. **Mettre à jour la doc.** Avant de pousser :
   - Le README du module touché.
   - `docs/architecture.md` si un choix structurel a été pris.
   - `docs/decisions.md` (ADR) si une décision technique non triviale a été
     prise.
   - La DocC du module touché.
   - `docs/ROADMAP.md` : marquer l'US comme « en revue ».
   - Le fichier US lui-même : cocher les CA réalisés.

9. **Commit et création de la PR.** Commit atomique référençant l'ID :
   `feat(courses): US-08 mode Courses plein écran`.
   `git push -u origin <branche>`, puis :
   ```
   gh pr create --base <branche-de-base> \
     --title "US-NN — <intitulé>" \
     --body "<corps>"
   ```
   `<branche-de-base>` est `main` si toutes les dépendances sont `done`, sinon
   la branche de la dépendance `awaiting-merge` la plus récente (cf. §3.2).
   Pour une PR empilée, l'indiquer en tête du corps : « Stacked on top of #N
   (US-MM) — à merger après ».
   Le corps de la PR : rappel ID + intitulé, liste des CA et où ils sont
   couverts (fichiers + tests), confirmation SwiftLint + build + tests verts,
   note design system + analytics, lien vers le ou les mockups concernés
   (`docs/design/html/mockups/...`).

10. **Revue par l'agent code-reviewer.** Lancer un sous-agent en lui passant
    `.claude/agents/code-reviewer.md` et le diff de la PR
    (`gh pr diff <PR-number>` ou `git diff main...<branche>`). Le reviewer
    rend un rapport de findings **bloquant** / **non bloquant**, en confrontant
    le diff à l'US, à la DoD du `CLAUDE.md`, au design system, aux contraintes
    CloudKit, et aux interdictions explicites (couleurs/strings, taille
    fichier, push main, secrets).

11. **Corriger.** Traiter tous les findings **bloquants** + les non-bloquants
    raisonnables. Si un finding révèle un problème de conception, corriger
    plutôt que contourner. Re-lancer §7 (lint+build+tests). Si les corrections
    sont substantielles, **relancer le reviewer** (§10). Boucler revue →
    correction tant qu'il reste du bloquant, dans la limite du budget (§5).

12. **Vérifier la CI distante.**
    `gh pr checks <PR-number>` — toutes les vérifications GitHub doivent être
    vertes. **Interdiction de demander le merge si la CI a la moindre erreur**
    (CLAUDE.md). Si rouge : corriger, push, re-vérifier.

13. **Demande d'autorisation de merge — SANS bloquer la boucle.**
    Le `CLAUDE.md` interdit absolument le merge sans GO explicite. Mais la
    boucle **ne s'arrête pas pour autant**. On affiche la demande, on marque
    la PR `awaiting-merge`, et on enchaîne immédiatement sur l'US suivante.
    - Passer le statut `PROGRESS.md` à `awaiting-merge`, noter le numéro de PR
      et la branche.
    - Présenter à l'utilisateur (une notification, pas une attente) :
      ```
      🟢 US-NN — <intitulé> prête à merger
      PR : <url>
      CI : ✅ vert
      Review : ✅ aucun finding bloquant
      Design System : ✅ tokens utilisés, mockup respecté
      Analytics : ✅ tag(s) ajouté(s) à TagManager.md
      → En attente d'autorisation explicite (« oui merge », « tu peux merge »).
        La boucle continue sur l'US suivante en attendant.
      ```
    - **Ne PAS merger.** **Ne PAS attendre la réponse non plus.**
    - « ci ok », « tests verts », « review ok », un emoji 👍 NE SONT PAS des
      autorisations. Seul un GO explicite (« oui merge », « merge la », « tu
      peux merger », nommant ou non l'US/PR concernée) déclenche un traitement
      de merge (§14).
    - L'autorisation ne se reporte JAMAIS d'une PR à l'autre, même si plusieurs
      PR sont `awaiting-merge`. « oui merge » sans précision → demander laquelle
      ou supposer la plus ancienne `awaiting-merge` et le préciser.
    - **Retourner immédiatement à §2** pour sélectionner l'US suivante éligible
      (les dépendances `awaiting-merge` sont considérées satisfaites, cf. §2).

14. **Traitement d'un GO de merge — peut arriver à tout moment.**
    Le GO arrive de manière asynchrone, généralement entre deux itérations de
    la boucle ou au milieu d'une US. Quand il est détecté :
    - Identifier la PR visée (numéro explicite, ID US, ou plus ancienne
      `awaiting-merge` si non précisé — confirmer dans ce dernier cas).
    - Si la PR cible est à la racine d'une pile (base = `main`) :
      ```
      gh pr merge <PR-number> --squash --delete-branch
      ```
      Puis `git fetch origin && git switch main && git pull`.
    - Si d'autres PR de la pile étaient basées sur celle qui vient d'être
      mergée : rebaser chacune sur `main` à jour
      (`git switch <branche> && git rebase origin/main && git push --force-with-lease`)
      pour que `gh pr` recible automatiquement leur base sur `main`. Relancer
      `gh pr checks` pour chaque PR rebasée ; en cas d'échec, le finding
      bloque le merge de cette PR (statut reste `awaiting-merge` avec note).
    - Mettre à jour `PROGRESS.md` : statut `done` pour la PR mergée ;
      `awaiting-merge` reste pour les autres jusqu'à leur propre GO.
    - **Reprendre la boucle là où elle en était** (US en cours sur sa branche
      de travail). Si la boucle attendait (cas §7), redémarrer §2.

Ne PAS s'arrêter pour demander « est-ce que je continue ? » entre étapes. La
boucle enchaîne en permanence. Il n'y a **aucun point d'attente humain
synchrone** par US — la seule interaction humaine (le GO) est traitée de
manière asynchrone (§14) sans interrompre l'avancement.

**Ne jamais merger une PR** dont les tests sont rouges, dont la CI distante a
la moindre erreur, qui a des findings bloquants non résolus, ou qui enfreint
un garde-fou. Dans ces cas l'US reste `in-progress` ou bascule en `blocked:*`.

## 4. Garde-fous (ne jamais les franchir pour « avancer »)

Ces règles priment sur le fait de terminer une US. Ce sont les interdictions
explicites du `CLAUDE.md` :

- **Pas de push sur `main`.** Toute modif passe par branche → PR → CI verte →
  GO → merge. Même la doc.
- **Pas de merge sans GO explicite.** Voir §3.13. C'est l'unique exigence
  d'interaction humaine de la boucle.
- **Pas de couleurs ni strings hardcodées.** Tout passe par les tokens du
  module `QuickListDesignSystem` et par des fichiers de localisation. Sinon le
  reviewer doit bloquer.
- **Pas de secrets en commit.** Clés API, identifiants iCloud privés, certificats
  : jamais. Si nécessaire, `.gitignore` + var d'env + `OPEN-QUESTIONS.md`.
- **Pas de migration destructive sans confirmation.** Toute migration SwiftData
  qui pourrait perdre des données utilisateur : demander, ne pas faire.
- **Pas de suppression de feature sans accord explicite** de l'utilisateur.
- **Pas plusieurs classes/structs par fichier.** Une déclaration de premier
  niveau par fichier (sauf cas justifié et noté).
- **Pas de fichier > 300 lignes** sans justification écrite dans le commit ou
  la PR.
- **Pas de triche sur les tests.** Ne jamais affaiblir, `skip`, `XCTSkip`
  inconditionnel, ou supprimer un test pour faire passer le vert. Si un test
  ne peut pas passer : blocage.
- **Pas de hors-périmètre.** Ne pas implémenter une feature absente des US.
  Une idée nouvelle s'écrit dans `OPEN-QUESTIONS.md`, pas dans le code.
- **Pas de modification d'architecture.** L'architecture (MVVM modulaire, SPM,
  séparation `core/services/api/ui/tests`) est gravée. Pour la faire bouger :
  ADR explicite + accord utilisateur.
- **Design System obligatoire.** Toute UI dérive du module DS. Aucun composant
  redéfini localement.

## 5. Budget d'essais par US (ne pas boucler à l'infini)

Une US ne doit pas piéger la boucle. Limiter à **3 tentatives** de mise au vert,
ce budget couvrant aussi bien la mise au vert SwiftLint/build/tests que le
cycle revue → correction :

- Si après 3 tentatives la chaîne lint+build+tests ne passe pas, ou si le
  reviewer continue à remonter des findings bloquants : ne PAS demander de
  merge. Marquer `blocked:test`, consigner dans `PROGRESS.md` (colonne Note) et
  dans `OPEN-QUESTIONS.md` ce qui coince, ce qui a été essayé, et les findings
  restés non résolus. Puis passer à l'US suivante éligible. La branche/PR est
  laissée ouverte pour reprise.
- Ne pas réécrire le projet en boucle autour d'un point dur.

## 6. Gérer les blocages

Quand une US est bloquée, toujours :
(a) lui donner le bon statut `blocked:*` dans `PROGRESS.md`,
(b) écrire dans `OPEN-QUESTIONS.md` une entrée claire (ID, nature du blocage,
    options envisagées, décision attendue de l'humain),
(c) continuer sur une autre US éligible.

Cas spécifiques QuickList :
- **iOS 26 / Foundation Models indisponible** sur la machine de build →
  `blocked:needs-human` pour US-15→US-18 jusqu'à confirmation de l'environnement.
- **CloudKit container non configuré** (partage US-21) → `blocked:needs-human`.
- **Asset manquant** (icône terminée, mockup d'un nouvel écran imprévu) →
  `blocked:needs-human`.

La boucle ne s'arrête pas au premier blocage — elle contourne et persiste tant
qu'il reste des US faisables.

## 7. S'arrêter et rendre la main

**La boucle ne s'arrête JAMAIS d'elle-même tant qu'il reste une US faisable.**
Les PR `awaiting-merge` n'arrêtent PAS la boucle — elle continue en empilant
les branches (cf. §2 et §3.2). Arrêter UNIQUEMENT quand l'une de ces conditions
est vraie :

- **Tout est `done`** → bilan (section 8).
- **Il ne reste que des US `blocked:*` et/ou `awaiting-merge`, ET aucune US
  `todo` n'est plus implémentable** (chaque `todo` restante a au moins une
  dépendance `blocked`) → bilan listant chaque blocage et chaque PR en attente
  d'autorisation. Tant qu'on peut empiler une nouvelle PR au-dessus d'une
  `awaiting-merge`, on continue.
- **L'utilisateur a fixé une portée** (« fais juste la phase MVP », « juste les
  US-01 à US-05 ») et cette portée est entièrement `done`, `awaiting-merge`,
  ou bloquée.
- **L'utilisateur demande explicitement d'arrêter** (« stop », « pause la
  boucle », « ça suffit pour aujourd'hui »).

À l'arrêt, ne pas inventer de travail supplémentaire pour « continuer ». Mais
ne pas non plus s'arrêter de soi-même : la pile de PR `awaiting-merge` n'est
PAS un motif d'arrêt.

## 8. Bilan de fin de boucle

Présenter un résumé concis :

- US terminées (compte + liste d'IDs + numéros de PR).
- US `awaiting-merge` (PR + URL).
- US bloquées : pour chacune, la raison et l'action attendue de l'humain
  (avec pointeur vers `OPEN-QUESTIONS.md`).
- Prochaines US redevenues éligibles si l'humain débloque tel ou tel point.

## Exemple de déroulé

```
Sélection : US-01 (todo, phase MVP, aucune dépendance)
→ git switch main && git pull ; git switch -c feat/US-01-ajout-rapide
→ Modèle : RAS (TaskList/ListItem déjà spec dans le fichier US)
→ Design System : utilise composant AddItemBar du module QuickListDesignSystem
→ Implémentation : AddItemView (View) + AddItemViewModel + ListItemRepository
   (Service, protocol-oriented)
→ Tests : XCTest sur ViewModel (ajout, focus conservé, champ vidé) + snapshot
   compact iPhone
→ Analytics : tag "item_added" ajouté à docs/TagManager.md
→ swiftlint --strict ✅, xcodebuild build ✅, xcodebuild test ✅
→ Doc : README du module mis à jour, ROADMAP.md → US-01 en revue
→ commit "feat(quick-add): US-01 ajout d'item en une frappe" ; push
→ gh pr create (corps : US, CA, tests, DS, analytics, lien mockup)
→ agent code-reviewer sur le diff
   findings : [bloquant] focus non re-attribué après soumission, [non bloquant]
   nommage variable `txt` → `pendingTitle`
→ correction des 2 ; re-lint + build + test ✅
→ commit "fix(quick-add): US-01 re-focus champ après ajout" ; push
→ re-review : aucun finding bloquant
→ gh pr checks #12 ✅ vert
→ 🟢 US-01 prête à merger (PR #12). Notification émise, PAS d'attente.
   PROGRESS.md : US-01 awaiting-merge (#12, base: main)
→ Sélection immédiate : US-02 (todo, phase MVP, dépend US-01 → awaiting-merge
   = satisfait, branchée sur feat/US-01-ajout-rapide en stack)
→ feat/US-02-...
... cycle complet US-02 ...
→ 🟢 US-02 prête à merger (PR #13, stacked sur #12)
   PROGRESS.md : US-02 awaiting-merge (#13, base: feat/US-01-ajout-rapide)
→ Sélection : US-03 → enchaîne
...

[à un moment, utilisateur : « oui merge #12 »]

→ gh pr merge #12 --squash --delete-branch
→ git switch main && git pull
→ Rebase de #13 (US-02) sur origin/main + push --force-with-lease
→ gh pr checks #13 ✅
→ PROGRESS.md : US-01 done, US-02 awaiting-merge (base: main maintenant)
→ Reprise immédiate de l'US en cours (par ex. US-03) sans interrompre le cycle
...
Sélection : US-15 → exige iOS 26 simulateur + Apple Intelligence indispo en CI
→ blocked:needs-human
→ OPEN-QUESTIONS.md : "US-15 — Foundation Models exige iOS 26 simu. CI actuelle
   sous iOS 17. Options : (a) attendre runner iOS 26, (b) mocker totalement le
   modèle en CI. Décision attendue." → la boucle passe à US-19 (fallback,
   testable sans IA).
```

## Adaptation hors QuickList

Le protocole (registre → sélection par dépendances/phase → cycle branche → dev →
tests → build → PR → revue → correction → **autorisation explicite** → merge,
avec garde-fous, budget d'essais et gestion des blocages) reste générique. Sur
un autre projet, remplacer les commandes Swift/Xcode/SwiftLint par celles du
stack et adapter les garde-fous, en gardant intacte la discipline « une US
finie, relue, autorisée et mergée avant la suivante ».

## Fichiers du skill

- `.claude/agents/code-reviewer.md` — instructions de l'agent reviewer, chargées
  au moment de l'étape de revue (§3.10) pour produire le rapport de findings.
