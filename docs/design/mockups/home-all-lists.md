# Mockup — Home : Toutes les listes

> US couvertes : US-03, US-04, US-05, US-10, US-11, US-18
> A VALIDER PAR L'UTILISATEUR AVANT IMPLEMENTATION

---

## iPhone Portrait (défaut)

```
┌─────────────────────────────────────────────┐
│ ████████████████████████████████████████████│  ← Status bar (système)
├─────────────────────────────────────────────┤
│                                             │
│  Mes listes                      [person+] │  ← NavigationTitle .largeTitle
│  Font.qlLargeTitle · Color.qlPrimaryLabel   │    Bouton : person.2.badge.plus
│                                             │    (accès partage global, discret)
├─────────────────────────────────────────────┤
│                                             │
│  ┌─────────── INBOX ────────────────────┐  │  ← Visible uniquement si items
│  │  tray.fill  Inbox           [3] ●    │  │    non-routés présents (US-18)
│  │  Font.qlHeadline · qlPrimaryLabel    │  │    Badge orange qlWarning
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌───────────────────┐ ┌─────────────────┐ │
│  │                   │ │                 │ │  ← Grille 2 colonnes
│  │  cart.fill        │ │  checklist      │ │    Spacing.qlL entre cards
│  │       [5] ●       │ │       [12] ●    │ │
│  │                   │ │                 │ │    Badge : Font.qlBadgeCount
│  │  Courses          │ │  Tâches         │ │    bg qlAccent, fg white
│  │  5 items · ☁      │ │  12 items       │ │
│  │                   │ │                 │ │    Sync icon : icloud.fill
│  └───────────────────┘ └─────────────────┘ │    Color.qlSyncSuccess 12pt
│                                             │
│  ┌───────────────────┐ ┌─────────────────┐ │
│  │                   │ │                 │ │
│  │  lightbulb.fill   │ │  folder.fill    │ │    Icônes : 28pt
│  │                   │ │                 │ │    Color selon type
│  │                   │ │                 │ │
│  │  Idées            │ │  Projets        │ │    Font.qlHeadline (nom liste)
│  │  2 items          │ │  0 item         │ │    Font.qlFootnote (sous-titre)
│  │                   │ │                 │ │    Color.qlSecondaryLabel (sous-titre)
│  └───────────────────┘ └─────────────────┘ │
│                                             │
│  ┌───────────────────┐                     │
│  │                   │                     │
│  │  star.fill        │                     │
│  │      [1] ●        │                     │
│  │                   │                     │
│  │  Favoris          │                     │
│  │  1 item           │                     │
│  │                   │                     │
│  └───────────────────┘                     │
│                                             │
│                                             │
│                              ┌──────────┐  │
│                              │   [+]    │  │  ← FAB : plus.circle.fill
│                              │ Nouvelle │  │    44x44pt minimum
│                              │  liste   │  │    Color.qlAccent
│                              └──────────┘  │    Position : bottom trailing
│                                             │    Au-dessus de la TabBar
├─────────────────────────────────────────────┤
│  [checklist]              [cart.fill]       │  ← TabBar (décision QO-4)
│   Listes                   Courses          │    Onglet 0 actif (sélectionné)
│   qlAccent                 qlTertiaryLabel  │    qlAccent = onglet actif
│ ████████████████████████████████████████████│  ← Home indicator
└─────────────────────────────────────────────┘
```

**Tokens de couleur par card**
- Courses : `Color.qlRayonFruitsLegumes` (légère teinte verte — à affiner)
- Cart icon : `.multicolor`
- Tâches : fond `Color.qlSurface`
- Idées : fond `Color.qlSurface`, lightbulb `.multicolor` jaune
- Projets : fond `Color.qlSurface`
- Favoris : fond `Color.qlSurface`, star `.multicolor` jaune-orange

---

## Etat : Vide (aucune liste)

```
┌─────────────────────────────────────────────┐
│ ████████████████████████████████████████████│
├─────────────────────────────────────────────┤
│                                             │
│  Mes listes                                 │
│                                             │
├─────────────────────────────────────────────┤
│                                             │
│                                             │
│                                             │
│          checklist                          │
│         (56pt, qlSecondaryLabel)            │
│                                             │
│         Aucune liste                        │  ← ql.home.empty.title
│         Font.qlTitle2                       │    Color.qlPrimaryLabel
│                                             │
│    Créez votre première liste en            │  ← ql.home.empty.subtitle
│    appuyant sur +.                          │    Font.qlBody
│    Font.qlBody · Color.qlSecondaryLabel     │    Color.qlSecondaryLabel
│    (centré, max 280pt large)                │    (centré, padding qlXXL)
│                                             │
│                                             │
│                                             │
│                              ┌──────────┐  │
│                              │   [+]    │  │
│                              │ Nouvelle │  │
│                              │  liste   │  │
│                              └──────────┘  │
├─────────────────────────────────────────────┤
│  [checklist]              [cart.fill]       │  ← TabBar
│   Listes                   Courses          │    Onglet 0 actif
│ ████████████████████████████████████████████│
└─────────────────────────────────────────────┘
```

---

## Etat : Inbox visible (US-18)

La card Inbox apparaît en tête de liste, en pleine largeur, avec une teinte d'accent `Color.qlWarning` légèrement visible en fond.

```
┌─────────────────────────────────────────────┐
│  ┌──────────────────────────────────────┐   │
│  │ tray.fill  Inbox            [3] ●    │   │  ← Card pleine largeur
│  │ "3 items à router"                   │   │    bg légère qlWarning 10% opacity
│  │ Font.qlBody · qlSecondaryLabel       │   │    badge qlWarning
│  └──────────────────────────────────────┘   │
│                                             │
│  [grille normale des listes...]             │
```

---

## Interactions

| Action | Geste | Feedback | Transition |
|--------|-------|----------|------------|
| Ouvrir une liste | Tap ListCard | scale 0.96 → release | NavigationStack push (slide) |
| Créer une liste | Tap FAB [+] | UIImpactFeedbackGenerator(.medium) | Sheet montante |
| Options liste | Long press ListCard | UIImpactFeedbackGenerator(.medium) + ContextMenu | ContextMenu |
| Renommer | ContextMenu "Renommer" → ListOptionsSheet | UIImpactFeedbackGenerator(.light) | Inline edit dans ListOptionsSheet |
| Supprimer | ContextMenu "Supprimer" | UINotificationFeedbackGenerator(.warning) | Confirmation alert |
| Ouvrir Inbox | Tap card Inbox | scale 0.96 | NavigationStack push |

---

## Adaptations iPad

- Pas de TabBar sur iPad — la navigation utilise NavigationSplitView
- La sidebar affiche en tête : entrée "Courses" (`cart.fill`) avec `Divider`, puis la liste des listes
- Grille de listes passe à 3 colonnes en paysage (ou 4 sur iPad 13") dans le detail pane
- Le FAB est remplacé par un bouton "Nouvelle liste" dans la toolbar de la sidebar
- Geste pinch pour alterner 2/3 colonnes en portrait

## Adaptations macOS

- Pas de TabBar — entrée "Courses" (`cart.fill`) en tête de la sidebar, séparée par un `Divider`
- Layout : sidebar + detail pane (items)
- Pas de FAB : bouton "+" dans la toolbar de la sidebar, raccourci `Cmd+N`
- Mode Courses : raccourci `Cmd+Shift+C`
- ContextMenu disponible via clic droit
- Drag & drop de listes pour les réordonner dans la sidebar
