# Mockup — Widgets iOS

> US couvertes : US-12, US-13, US-14
> A VALIDER PAR L'UTILISATEUR AVANT IMPLEMENTATION

---

## Widget 1 — "Liste rapide" (US-12 / US-13)

Affiche une liste choisie et permet de cocher depuis le widget (App Intents).

### Tailles disponibles : Small, Medium, Large

---

### Widget Small (2x2)

```
╔═══════════════════════════════════╗
║  cart.fill     Courses            ║  ← Icon type + Nom liste
║  (16pt)        Font.subheadline   ║    qlAccent icon
║                .semibold          ║
╠═══════════════════════════════════╣
║                                   ║
║  ○  Lait                          ║  ← Item 1 (pas fait)
║     Font.caption                  ║    circle 12pt qlSecondaryLabel
║                                   ║
║  ✓  ̶T̶o̶m̶a̶t̶e̶s̶                        ║  ← Item 2 (fait)
║     Font.caption qlSecondaryLabel ║    checkmark.circle 12pt qlSuccess
║     strikethrough                 ║
║                                   ║
║  ○  Yaourts                       ║
║     Font.caption                  ║
║                                   ║
║       +3 items                    ║  ← "et N autres"
║  Font.caption2 · qlTertiaryLabel  ║
╚═══════════════════════════════════╝
bg : Color.qlGroupedBackground
corner : Radius.qlLarge (system)
```

---

### Widget Medium (4x2)

```
╔═══════════════════════════════════════════════════════════════╗
║  cart.fill  Courses                            [5 items]     ║  ← Titre + count
║  (16pt)     Font.subheadline.semibold          Font.caption  ║
╠═══════════════════════════════════════════════════════════════╣
║                                                              ║
║  ○  Lait                      ○  Pâtes                       ║  ← 2 colonnes
║     Font.body                    Font.body                   ║
║                                                              ║
║  ✓  ̶T̶o̶m̶a̶t̶e̶s̶                     ○  Yaourts                   ║
║     strikethrough, qlSecLbl                                  ║
║                                                              ║
║  ○  Pommes de terre                                          ║
║                                                              ║
║                                    +2 autres →               ║
╚═══════════════════════════════════════════════════════════════╝
```

---

### Widget Large (4x4)

```
╔═══════════════════════════════════════════════════════════════╗
║  cart.fill  Courses                            [5/8 faits]   ║
╠═══════════════════════════════════════════════════════════════╣
║                                                              ║
║  FRUITS & LÉGUMES                                            ║  ← CategoryHeader (si courses)
║  leaf.fill  Font.caption.uppercased qlSecondaryLabel         ║
║                                                              ║
║  ○  Tomates                                                  ║
║  ○  Pommes                                                   ║
║  ✓  ̶S̶a̶l̶a̶d̶e̶                                                    ║
║                                                              ║
║  CRÈMERIE                                                    ║
║  drop.fill                                                   ║
║                                                              ║
║  ○  Lait                                                     ║
║  ✓  ̶Y̶a̶o̶u̶r̶t̶s̶                                                   ║
║                                                              ║
║  ○  Pâtes (Épicerie)                                         ║
║                                                              ║
║                          [Ouvrir →]                          ║  ← Link vers l'app
╚═══════════════════════════════════════════════════════════════╝
```

---

### Interactivité (US-13 — App Intents)

Chaque item est une `Button` avec `AppIntent` :

- Tap sur le cercle/checkmark : toggle isDone
- Animation : checkmark animé dans le widget (WidgetKit refresh)
- L'état se synchronise avec l'app et iCloud
- Le widget se rafraîchit automatiquement après l'action

**Configuration** (WidgetConfigurationIntent) :
- Liste affichée : sélecteur parmi toutes les listes
- Afficher items faits : oui / non
- Trier par rayon (si type Courses) : oui / non

---

### Etats particuliers

**Empty state :**
```
╔═══════════════════════════════════╗
║  checklist     Tâches             ║
╠═══════════════════════════════════╣
║                                   ║
║        checklist (24pt)           ║
║     Color.qlTertiaryLabel         ║
║                                   ║
║     Liste vide                    ║
║  Font.subheadline · qlSecLbl      ║
║                                   ║
╚═══════════════════════════════════╝
```

**Erreur / liste supprimée :**
```
╔═══════════════════════════════════╗
║  [!] Configuration requise        ║  ← exclamationmark.triangle
║                                   ║    Font.subheadline qlDanger
║  Touchez pour choisir une liste.  ║
║  Font.caption qlSecondaryLabel    ║
╚═══════════════════════════════════╝
```

---

## Widget 2 — "Derniers items" (US-14)

Affiche les items récemment ajoutés, toutes listes confondues.

### Widget Medium (4x2) — Recommandé

```
╔═══════════════════════════════════════════════════════════════╗
║  clock.fill  Récents                          Mise à jour ↻   ║  ← Titre
║  (14pt)      Font.subheadline.semibold   Font.caption2 qlSecLbl
╠═══════════════════════════════════════════════════════════════╣
║                                                              ║
║  ○  Lait               [Courses]                             ║  ← Item + badge liste
║     Font.subheadline   Font.caption bg qlAccent white        ║    Badge = nom de liste
║                        Radius.qlSmall                        ║
║                                                              ║
║  ○  Appeler médecin    [Tâches]                              ║
║     Font.subheadline   Font.caption bg qlSuccess white       ║
║                                                              ║
║  ○  Idée de projet     [Idées]                               ║
║     Font.subheadline   Font.caption bg qlWarning white       ║
║                                                              ║
║  ○  Présentation Q3    [Projets]                             ║
║                                                              ║
╚═══════════════════════════════════════════════════════════════╝
```

Chaque couleur de badge correspond au type de liste :
- Courses → qlAccent (bleu)
- Tâches → qlSuccess (vert)
- Idées → qlWarning (orange/jaune)
- Projets → qlSecondaryLabel (gris)
- Favoris → couleur étoile (or)

### Widget Small (2x2)

```
╔═══════════════════════════════════╗
║  clock.fill  Récents              ║
╠═══════════════════════════════════╣
║                                   ║
║  ○  Lait            [Courses]     ║
║     Font.caption                  ║
║                                   ║
║  ○  Appeler médecin [Tâches]      ║
║     Font.caption                  ║
║                                   ║
║  ○  Idée projet     [Idées]       ║
║     Font.caption                  ║
║                                   ║
╚═══════════════════════════════════╝
```

---

### Configuration Widget Derniers Items

- N items à afficher : 3, 4, 5 (selon taille)
- Filtrer par type : Toutes, Courses seulement, Tâches seulement, etc.
- Afficher la liste d'origine : oui / non

---

### Comportement

- Rafraîchissement : au moins toutes les 15 minutes (WidgetKit timeline)
- Rafraîchissement immédiat après ajout d'un item (via AppIntent ou URLScheme)
- Deep link : tap sur un item → ouvre l'app sur la liste correspondante
- Tap sur le titre → ouvre HomeView

---

## Tokens utilisés dans les widgets

Les widgets partagent les mêmes tokens de couleur que l'app, définis dans `QuickListDesignSystem`. Le module SPM est importé à la fois par l'app target et l'extension widget.

Règle importante (WidgetKit) : les animations complexes ne sont pas supportées dans les widgets. Pas de springs, pas de shimmer. Uniquement les transitions WidgetKit standard (fade, push).

---

## Adaptations iPad / macOS

iPad : les widgets s'affichent dans Today View et sur l'écran d'accueil. Les variantes XL (8x4) peuvent être utilisées si disponibles.

macOS : les widgets sont disponibles dans Notification Center et sur le bureau (macOS 14+). Les mêmes designs s'appliquent, avec adaptations de padding pour la densité macOS.

---

## VoiceOver (Widgets)

- Widget "Liste rapide" : accessibilityLabel "[Nom liste], [N] items non faits"
- Chaque item : accessibilityLabel "[Titre], [fait/pas fait]", trait : button
- Action cocher : accessibilityHint "Toucher deux fois pour [cocher/décocher]"
- Widget "Derniers items" : accessibilityLabel "Derniers items ajoutés"
- Chaque item : accessibilityLabel "[Titre], dans [Nom liste]"
