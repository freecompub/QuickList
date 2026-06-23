# QuickList — Design System & Mockups

> **A VALIDER PAR L'UTILISATEUR AVANT TOUTE IMPLEMENTATION**
>
> Ce dossier contient l'intégralité des spécifications de design de QuickList.
> Aucun code Swift ne doit être écrit avant validation explicite de ces documents
> par le propriétaire du produit.

---

## Décisions validées le 2026-06-23

| # | Sujet | Décision |
|---|-------|----------|
| QO-1 | Couleur d'accent | Bleu système Apple — `Color.qlAccent = .accentColor` — adaptation automatique dark mode |
| QO-2 | Bouton [+] AddItemBar | Externe (à droite du TextField, hors du champ) — `plus.circle.fill` 32pt, cible 44x44pt |
| QO-3 | Items faits en mode Courses | Glissement en bas de section — animation spring — toujours visibles, jamais masqués |
| QO-4 | Accès mode Courses | TabBar dédiée sur iPhone (onglet 1 "Courses") — sidebar iPad/macOS — voir `cross-platform.md` |
| QO-5 | Animation "Courses terminées" | Minimaliste — checkmark scale + fade, pas de confetti — respecte Reduce Motion nativement |
| QO-6 | Renommage de liste | Inline uniquement — TextField en place dans ListOptionsSheet, pas d'alert |
| QO-7 | Icône d'application | 5 propositions dans `app-icon-proposals.md` — en attente de choix utilisateur |

---

## Livrables

### 1. Design System
**[design-system.md](./design-system.md)**

Tokens de couleur, typographie, iconographie (SF Symbols), espacements, rayons, ombres, composants réutilisables (ListRow, AddItemBar, CategoryHeader, ListCard, AIBadge, SyncIndicator, UndoToast, SuggestionChip, TabBar, VoiceImportSheet, ReceiptScanSheet), règles d'accessibilité et motion design.

Pensé comme un module SPM `QuickListDesignSystem` importable par l'app et l'extension widget.

---

### 2. Stratégie cross-platform
**[cross-platform.md](./cross-platform.md)**

Spécification complète des adaptations de navigation par plateforme : TabBar iPhone, sidebar iPad/macOS, Menu Bar macOS, size classes, raccourcis clavier. Document de référence pour l'implémentation.

---

### 3. User Flow & Navigation
**[workflow.md](./workflow.md)**

Architecture de navigation (iPhone TabBar + NavigationStack, iPad NavigationSplitView, macOS window + sidebar + Menu Bar), diagramme complet des écrans et transitions, flows critiques détaillés :
- Ajout d'item en rafale
- Passage en mode Courses avec tri par rayon
- Import vocal
- Scan de ticket
- Partage d'une liste

---

### 4. Icône d'application
**[app-icon-proposals.md](./app-icon-proposals.md)**

5 directions visuelles proposées avec description détaillée, représentation ASCII, forces/faiblesses, variante macOS. En attente de choix utilisateur.

---

### 5. Mockups par écran

| Fichier | Ecran | US couvertes |
|---------|-------|-------------|
| [home-all-lists.md](./mockups/home-all-lists.md) | Accueil — Toutes les listes | US-03, US-04, US-05, US-10, US-11, US-18 |
| [list-detail.md](./mockups/list-detail.md) | Détail liste (Tâches/Idées/Projets/Favoris) | US-01, US-02, US-06, US-10, US-11, US-15, US-20 |
| [list-detail-groceries.md](./mockups/list-detail-groceries.md) | Détail liste type Courses (tri par rayon) | US-07, US-08, US-09, US-15, US-01, US-02 |
| [shopping-mode.md](./mockups/shopping-mode.md) | Mode Courses dédié plein écran | US-08, US-09, US-07 |
| [add-item-bar.md](./mockups/add-item-bar.md) | Barre d'ajout + suggestions (zoom) | US-01, US-20, US-16 |
| [create-list-sheet.md](./mockups/create-list-sheet.md) | Sheet de création de liste | US-03 |
| [list-options.md](./mockups/list-options.md) | Options (renommer / supprimer / tri / partage) | US-05, US-06, US-21 |
| [voice-import.md](./mockups/voice-import.md) | Import vocal (Foundation Models) | US-16, US-18, US-19 |
| [receipt-scan.md](./mockups/receipt-scan.md) | Scan de ticket de caisse | US-17, US-19 |
| [inbox-auto-routing.md](./mockups/inbox-auto-routing.md) | Inbox et auto-routage | US-18, US-19 |
| [widgets.md](./mockups/widgets.md) | Widgets iOS (Liste rapide + Derniers items) | US-12, US-13, US-14 |
| [settings.md](./mockups/settings.md) | Réglages (sync, IA, thème, à propos) | US-10, US-19 |
| [empty-states.md](./mockups/empty-states.md) | Tous les empty states | US-04, US-01, US-19, US-10 |
| [share-list.md](./mockups/share-list.md) | Partage CloudKit | US-21, US-10, US-11 |

---

## Questions ouvertes restantes

Les décisions QO-1 à QO-6 ont été validées le 2026-06-23. Deux questions restent ouvertes.

### QO-7 — Icône d'application (en attente de choix)

5 propositions sont détaillées dans **[app-icon-proposals.md](./app-icon-proposals.md)** :

| # | Nom | Résumé |
|---|-----|--------|
| P1 | L'éclair de liste | Trois lignes de liste traversées par un éclair blanc, fond bleu |
| P2 | Le checkmark typographique | Checkmark épuré évoquant un "Q", fond blanc |
| P3 | La liste condensée | Trois lignes avec puces, fond bleu — lisibilité maximale |
| P4 | Le Q minimaliste | Lettre Q avec queue-checkmark, fond bleu (recommandé) |
| P5 | L'éclair dans la case | Checkbox avec éclair intérieur, fond bleu |

**Action requise : choisir une proposition dans `app-icon-proposals.md`.**

---

### QO-8 — Troisième onglet TabBar (Réglages ou autre ?)

La TabBar actuelle a deux onglets (Listes / Courses). Les Réglages sont accessibles via `gearshape.fill` dans la NavigationBar de HomeView. Deux options :

**Option A (actuelle)** : pas de troisième onglet. Réglages via NavigationBar. TabBar minimale.

**Option B** : ajouter un troisième onglet "Réglages" (`gearshape.fill`). Plus d'accessibilité pour les réglages, mais TabBar légèrement plus chargée.

**Option C** : ajouter un troisième onglet "Inbox" (`tray.fill`), visible uniquement quand l'Inbox contient des items (badge). Les Réglages restent dans la NavigationBar.

**Action requise : valider Option A, B ou C avant implémentation.**

---

## Contraintes respectées dans ce design

- Aucune couleur hardcodée — tout via tokens `Color.qlXxx`
- Aucun string hardcodé — tout via clés `ql.xxx`
- SF Symbols exclusivement (pas d'icônes custom)
- Dynamic Type sur tous les composants
- Cibles tactiles >= 44pt (>= 64pt en mode Courses)
- Dark mode couvert sur tous les écrans
- Reduce Motion respecté sur toutes les animations
- VoiceOver annoté sur tous les composants interactifs
- Repli gracieux US-19 couvert sur chaque écran concerné
- Cross-platform (iPhone / iPad / macOS) noté sur chaque mockup
