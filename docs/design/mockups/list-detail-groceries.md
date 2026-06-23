# Mockup — Détail de liste type Courses (tri par rayon)

> US couvertes : US-07, US-08, US-09, US-15, US-01, US-02
> A VALIDER PAR L'UTILISATEUR AVANT IMPLEMENTATION

---

## iPhone Portrait — Courses avec rayons

```
┌─────────────────────────────────────────────┐
│ ████████████████████████████████████████████│
├─────────────────────────────────────────────┤
│  ◀ Retour         Courses              [···][☁]│  ← NavigationBar
│                   Font.qlTitle1             │    Pas de bouton Mode Courses ici :
│                                             │    accès via l'onglet Courses (TabBar)
│                                             │    [ellipsis.circle] : options
├─────────────────────────────────────────────┤
│                                             │  ← Contenu List scrollable
│  ┌──────────────────────────────────────┐  │  ← CategoryHeader : Fruits & Légumes
│  │ leaf.fill  FRUITS & LÉGUMES  · 3     │  │    bg Color.qlRayonFruitsLegumes
│  └──────────────────────────────────────┘  │    Icon 18pt · Font.qlCaption1.uppercased
│                                             │    .bold · Color.qlCategoryHeader
│  ┌──────────────────────────────────────┐  │    "3" : Font.qlCaption2 qlTertiaryLabel
│  │ ○  Tomates                           │  │
│  └──────────────────────────────────────┘  │
│  ┌──────────────────────────────────────┐  │
│  │ ○  Pommes                            │  │
│  └──────────────────────────────────────┘  │
│  ┌──────────────────────────────────────┐  │
│  │ ○  Salade                        ✦  │  │  ← AIBadge visible : classification en cours
│  └──────────────────────────────────────┘  │    sparkles 12pt, qlAIAccent, pulse
│                                             │
│  ┌──────────────────────────────────────┐  │  ← CategoryHeader : Crèmerie
│  │ drop.fill   CRÈMERIE         · 2     │  │    bg Color.qlRayonCremerie
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │ ○  Lait                              │  │
│  └──────────────────────────────────────┘  │
│  ┌──────────────────────────────────────┐  │
│  │ ○  Yaourts                           │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │  ← CategoryHeader : Épicerie
│  │ archivebox.fill  ÉPICERIE    · 1     │  │    bg Color.qlRayonEpicerie
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │ ○  Pâtes                             │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │  ← CategoryHeader : Autres
│  │ square.grid.2x2.fill  AUTRES · 1    │  │    bg Color.qlRayonAutres
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │ ○  Truc spécial                      │  │  ← Item non reconnu
│  └──────────────────────────────────────┘  │
│                                             │
├─────────────────────────────────────────────┤
│  ┌──────────────────────────┐  [+]          │  ← AddItemBar (QO-2 : [+] externe)
│  │  Ajouter un item…   [🎤] │  external     │    plus.circle.fill 32pt qlAccent
│  └──────────────────────────┘  qlAccent     │
│  Material.qlBarBackground                   │
├─────────────────────────────────────────────┤
│  [checklist]              [cart.fill]       │  ← TabBar (QO-4)
│   Listes ●                 Courses          │    Tap Courses → ShoppingModeView
│ ████████████████████████████████████████████│
└─────────────────────────────────────────────┘
```

---

## Etat : Item en attente de classification IA (US-15)

Un item ajouté avant classification s'affiche immédiatement dans "Autres" avec l'AIBadge :

```
│  ┌──────────────────────────────────────┐  │  ← Section "Autres" temporaire
│  │ square.grid.2x2.fill  AUTRES · 1    │  │
│  └──────────────────────────────────────┘  │
│  ┌──────────────────────────────────────┐  │
│  │ ○  Épinards                      ✦  │  │  ← En attente de classification
│  └──────────────────────────────────────┘  │    AIBadge pulse
```

Après classification :
- L'item "Épinards" glisse depuis "Autres" vers "Fruits & Légumes" (animation Motion.qlItemInsert)
- L'AIBadge disparaît (Motion.qlFade 0.2s)
- Si la section n'existait pas encore : elle apparaît avec l'item (Motion.qlItemInsert)

---

## Etat : Sans Apple Intelligence (US-19)

```
│  ◀ Retour         Courses              [···][☁] │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌──────────────────────────────────────────┐  │  ← Pas de CategoryHeaders
│  │ ○  Tomates                               │  │    Tri par ordre d'ajout (fallback)
│  └──────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────┐  │
│  │ ○  Lait                                  │  │
│  └──────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────┐  │
│  │ ○  Pâtes                                 │  │
│  └──────────────────────────────────────────┘  │
│                                                 │
│  ℹ️  Tri par rayon nécessite Apple Intelligence.│  ← Bandeau informatif discret
│     Font.qlFootnote · Color.qlSecondaryLabel   │    (bas de liste, avant AddItemBar)
│     background qlSecondaryBackground           │    Non-bloquant
│                                                 │
├─────────────────────────────────────────────────┤
│  ┌──────────────────────────┐                   │
│  │  Ajouter un item…        │  [+]              │  ← Pas de bouton [mic] (IA absent)
│  └──────────────────────────┘                   │
│  Material.qlBarBackground                       │
│ ████████████████████████████████████████████████│
└─────────────────────────────────────────────────┘
```

---

## Etat : Correction de rayon (US-09 — Long Press)

```
│  ┌──────────────────────────────────────┐  │
│  │ ○  Tofu                          ✦  │  │  ← Long press sur cet item
│  └──────────────────────────────────────┘  │
│                                             │
│  ContextMenu (HIG : Context Menus) :        │
│  ┌──────────────────────────────────────┐  │
│  │  Déplacer vers...                    │  │
│  │  ─────────────────────────────────── │  │
│  │  leaf.fill      Fruits & Légumes     │  │
│  │  fork.knife     Boucherie            │  │
│  │  drop.fill    ✓ Crèmerie             │  │  ← Rayon actuel coché
│  │  archivebox.fill Épicerie            │  │
│  │  snowflake      Surgelés             │  │
│  │  birthday.cake.fill Boulangerie      │  │
│  │  cup.and.saucer.fill Boissons        │  │
│  │  shower.fill    Hygiène              │  │
│  │  square.grid.2x2.fill Autres         │  │
│  └──────────────────────────────────────┘  │
```

Sélection d'un rayon → item déplacé + `CategoryPreference` sauvegardée.

---

## Interactions

| Action | Geste | Feedback |
|--------|-------|----------|
| Mode Courses | Tap onglet Courses (TabBar) | Transition TabView native |
| Cocher item | Tap circle | UIImpactFeedbackGenerator(.medium) |
| Corriger rayon | Long press item | UIImpactFeedbackGenerator(.medium) + ContextMenu |
| Supprimer item | Swipe gauche | UINotificationFeedbackGenerator(.warning) |
| Item classifié | Automatique (BG) | Aucun haptique, animation silencieuse |

---

## Adaptations iPad / macOS

iPad : même layout avec CategoryHeaders, plus de place pour les sections. La sidebar montre les rayons comme raccourcis de navigation (jump to section).

macOS : les CategoryHeaders sont des sections de liste avec style `.sidebar`. Drag & drop d'items entre sections pour corriger le rayon.
