# Mockup — Détail de liste (Tâches / Idées / Projets / Favoris)

> US couvertes : US-01, US-02, US-06, US-10, US-11, US-15, US-20
> A VALIDER PAR L'UTILISATEUR AVANT IMPLEMENTATION

---

## iPhone Portrait — Etat normal (items présents)

```
┌─────────────────────────────────────────────┐
│ ████████████████████████████████████████████│  ← Status bar
├─────────────────────────────────────────────┤
│  ◀ Retour          Tâches          [···] [☁]│  ← NavigationBar
│                    Font.qlTitle1            │    Trailing : ellipsis.circle (options)
│                    .semibold                │              icloud.fill (sync) SyncIndicator
│                    Color.qlPrimaryLabel     │    Leading : chevron.left (back)
├─────────────────────────────────────────────┤
│                                             │  ← Contenu scrollable (List SwiftUI)
│  ┌──────────────────────────────────────┐  │
│  │ ○  Acheter du lait                   │  │  ← ListRow (state: default)
│  │    Font.qlBody · Color.qlPrimaryLabel│  │    checkbox : circle 24pt
│  └──────────────────────────────────────┘  │    hauteur min 44pt
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │ ○  Appeler le dentiste          ✦    │  │  ← ListRow (state: loading IA)
│  │    Font.qlBody                       │  │    AIBadge : sparkles 12pt
│  └──────────────────────────────────────┘  │    Color.qlAIAccent, pulse animé
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │ ○  Préparer la présentation          │  │
│  │    Font.qlBody                       │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │ ✓  Envoyer l'email à Paul            │  │  ← ListRow (state: done)
│  │    ̶F̶o̶n̶t̶.̶q̶l̶B̶o̶d̶y̶ strikethrough        │  │    checkbox : checkmark.circle.fill
│  │    Color.qlItemDone (grisé, opa 0.6) │  │    Color.qlSuccess
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │ ✓  Commander les fournitures          │  │
│  │    ̶F̶o̶n̶t̶.̶q̶l̶B̶o̶d̶y̶ strikethrough        │  │
│  │    Color.qlItemDone                  │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  ·  ·  ·  (autres items)                   │
│                                             │
│                                             │
│                                             │
├─────────────────────────────────────────────┤  ← Séparateur (Color.qlSeparator)
│                                             │
│  [chip][chip][chip] ← SuggestionChips       │  ← Scroll horizontal
│                                             │
│  ┌──────────────────────────┐  [+]          │  ← AddItemBar (QO-2 validée)
│  │  Ajouter un item…   [🎤] │  external     │    [+] hors du TextField, à droite
│  └──────────────────────────┘  plus.circle  │    plus.circle.fill 32pt qlAccent
│                                .fill        │    cible 44x44pt
│  Material.qlBarBackground                   │
│  Shadow.qlAddBar                            │
├─────────────────────────────────────────────┤
│  [checklist]              [cart.fill]       │  ← TabBar (décision QO-4)
│   Listes ●                 Courses          │    Onglet Listes actif
│ ████████████████████████████████████████████│
└─────────────────────────────────────────────┘
```

---

## Etat : Swipe to Delete (US-02)

```
│  ┌──────────────────────────────┐ [🗑 Supprimer] │
│  │ ○  Acheter du lait           │ ←────────────── │  ← Swipe leading → trailing
│  └──────────────────────────────┘                 │    Action bg : Color.qlDanger
│                                                    │    Label : Font.qlBody.bold
│                                                    │    Icon : trash.fill 20pt white
```

Après confirmation de suppression : UndoToast apparaît au-dessus de l'AddItemBar.

---

## UndoToast (US-02)

```
├─────────────────────────────────────────────┤
│  ┌──────────────────────────────────────┐   │
│  │  "Acheter du lait" supprimé  [Annuler]│  │  ← Material.qlToastBG
│  │  Font.qlCallout · qlPrimaryLabel     │   │    Shadow.qlToast
│  └──────────────────────────────────────┘   │    Radius.qlMedium
│                                             │    Margin : Spacing.qlL
├─────────────────────────────────────────────┤
│  [AddItemBar]                               │
```

Durée d'affichage : 4 secondes, puis fade out (Motion.qlFade).

---

## Etat : Tri sélectionné (US-06)

Pas d'UI séparée pour le tri — le changement de tri est accessible depuis le ContextMenu de l'icône ellipsis.circle dans la NavigationBar. Le tri actif est indiqué par un checkmark dans le menu.

```
Options de tri (dans sheet ListOptions ou ContextMenu) :
  ✓ Ordre d'ajout           (dateAdded)
    Alphabétique            (alphabetical)
    Statut (fait / pas fait)(status)
```

---

## Etat : Vide (liste sans items)

```
┌─────────────────────────────────────────────┐
│ ████████████████████████████████████████████│
├─────────────────────────────────────────────┤
│  ◀ Retour          Tâches          [···] [☁]│
├─────────────────────────────────────────────┤
│                                             │
│                                             │
│                                             │
│              checklist                      │
│           (48pt, qlSecondaryLabel)          │
│                                             │
│            Liste vide                       │  ← ql.list.empty.title
│          Font.qlTitle2                      │
│          Color.qlPrimaryLabel               │
│                                             │
│  Commencez à taper pour ajouter votre       │  ← ql.list.empty.subtitle
│  premier item.                              │    Font.qlBody
│  Color.qlSecondaryLabel (centré)            │    Color.qlSecondaryLabel
│                                             │
│                                             │
│                                             │
├─────────────────────────────────────────────┤
│  ┌──────────────────────────┐  [+]          │  ← AddItemBar focus auto
│  │  Ajouter un item…   [🎤] │  external     │    cursor clignotant visible
│  └──────────────────────────┘  qlAccent     │
│  Material.qlBarBackground                   │
├─────────────────────────────────────────────┤
│  [checklist]              [cart.fill]       │  ← TabBar
│   Listes ●                 Courses          │
│ ████████████████████████████████████████████│
└─────────────────────────────────────────────┘
```

---

## Etat : Sync en cours (US-10/11)

```
│  ◀ Retour    Tâches    [···] [↻]  │  ← SyncIndicator : arrow.triangle.2.circlepath
│                                   │    rotation animation 1.5s
│                                   │    Color.qlSyncPending (orange)
```

Après sync OK :
```
│  ◀ Retour    Tâches    [···] [☁✓] │  ← icloud.fill, Color.qlSyncSuccess
│                                   │    fade in → visible 2s → fade out
```

---

## Interactions

| Action | Geste | Feedback |
|--------|-------|----------|
| Cocher un item | Tap checkbox | UIImpactFeedbackGenerator(.medium) + animation checkmark |
| Décocher un item | Tap checkbox | UIImpactFeedbackGenerator(.light) |
| Supprimer | Swipe gauche → "Supprimer" | UINotificationFeedbackGenerator(.warning) |
| Annuler suppression | Tap [Annuler] sur toast | UIImpactFeedbackGenerator(.medium) |
| Ajouter un item | Type + Return | UIImpactFeedbackGenerator(.light) |
| Accéder aux options | Tap ellipsis.circle | UIImpactFeedbackGenerator(.light) |
| Refresh iCloud | Pull-to-refresh | Indicateur système |

---

## Adaptations iPad

- Layout NavigationSplitView : la liste des items occupe le panneau detail (pleine hauteur)
- AddItemBar toujours en bas du panneau detail
- La NavigationBar est remplacée par la toolbar du splitview
- En paysage : possibilité d'afficher les items cochés dans un panneau secondaire (à valider)

## Adaptations macOS

- La liste est dans le detail pane de la window
- AddItemBar en bas, avec raccourci Cmd+T pour focus
- Swipe actions remplacées par menu contextuel (clic droit) et raccourcis (Delete)
- Le SyncIndicator est dans la toolbar de la window
