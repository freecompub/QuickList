# Mockup — Inbox et Auto-routage (confiance faible)

> US couvertes : US-18, US-19
> A VALIDER PAR L'UTILISATEUR AVANT IMPLEMENTATION

---

## Concept

L'Inbox est une liste système invisible tant qu'elle est vide. Elle reçoit les items pour lesquels Foundation Models a une confiance de routage trop faible pour assigner automatiquement une liste.

L'utilisateur n'est jamais bloqué : l'item est toujours sauvegardé, jamais perdu.

---

## HomeView — Inbox visible (badge d'alerte)

```
┌─────────────────────────────────────────────┐
│ ████████████████████████████████████████████│
├─────────────────────────────────────────────┤
│                                             │
│  Mes listes                      [person+] │
│  Font.qlLargeTitle                          │
│                                             │
├─────────────────────────────────────────────┤
│                                             │
│  ┌──────────────────────────────────────┐  │  ← Inbox card (pleine largeur)
│  │                                      │  │    Positionnée en TÊTE de liste
│  │  tray.fill   Inbox          [2] ●   │  │    tray.fill en qlWarning
│  │  (20pt)      Font.qlHeadline  badge  │  │    Badge qlWarning background
│  │                                      │  │    Fond : qlWarning opacity 0.08
│  │  2 items à router                    │  │    Sous-titre : qlSecondaryLabel
│  │  Font.qlCallout · qlSecondaryLabel  │  │    Border : 1pt qlWarning opacity 0.3
│  │                                      │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌───────────────────┐ ┌─────────────────┐ │
│  │  cart.fill  [5] ● │ │ checklist [12] ●│ │
│  │  Courses          │ │ Tâches          │ │
│  │  5 items · ☁      │ │ 12 items        │ │
│  └───────────────────┘ └─────────────────┘ │
│  ...                                        │
└─────────────────────────────────────────────┘
```

---

## InboxView — Liste des items non routés

```
┌─────────────────────────────────────────────┐
│ ████████████████████████████████████████████│
├─────────────────────────────────────────────┤
│  ◀ Mes listes    Inbox    [2]    [trier]    │  ← NavigationBar
│                  Font.qlTitle1              │    Badge count dans le titre
│                                             │
├─────────────────────────────────────────────┤
│                                             │
│  Ces items n'ont pas pu être classés        │  ← Bandeau explicatif (non intrusif)
│  automatiquement. Choisissez une liste      │    Font.qlCallout
│  pour chacun.                               │    Color.qlSecondaryLabel
│  bg qlSecondaryBackground                  │    padding qlL
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │                                      │  │  ← Item 1
│  │  tray.fill  truc à faire             │  │    Pas de checkbox
│  │  (tray icon = inbox indicator)       │  │    Icon = tray.fill (inlet)
│  │             Font.qlBody qlPrimaryLbl │  │    Tap → InboxRoutingSheet
│  │                                      │  │    chevron.right en trailing
│  │  [Choisir une liste >]               │  │    Font.qlCallout qlAccent
│  │  Font.qlCallout · qlAccent           │  │
│  │                                      │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │                                      │  │
│  │  tray.fill  acheter un truc          │  │
│  │             Font.qlBody qlPrimaryLbl │  │
│  │                                      │  │
│  │  [Choisir une liste >]               │  │
│  │  Font.qlCallout · qlAccent           │  │
│  │                                      │  │
│  └──────────────────────────────────────┘  │
│                                             │
│                                             │
│ ████████████████████████████████████████████│
└─────────────────────────────────────────────┘
```

---

## InboxRoutingSheet — Choisir la liste de destination

```
┌─────────────────────────────────────────────┐
│  (contenu derrière, assombri)                │
│                                             │
│                                             │
├─────────────────────────────────────────────┤
│            ════                             │  ← Grabber
│                                             │
│  Annuler         Dans quelle liste ?        │  ← Titre
│  qlAccent        Font.qlTitle3.semibold     │
│                  qlPrimaryLabel             │
│                                             │
│  ┌──────────────────────────────────────┐  │  ← Item concerné (readonly, en tête)
│  │  "truc à faire"                      │  │    bg qlSecondaryBackground
│  │  Font.qlHeadline · qlPrimaryLabel   │  │    padding qlL
│  │  (non-éditable ici)                  │  │    Radius.qlMedium
│  └──────────────────────────────────────┘  │
│                                             │
│  SUGGESTIONS IA                             │  ← Si Apple Intelligence dispo
│  Font.qlCaption1.uppercased               │    Section header
│  qlSecondaryLabel                           │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  checklist     Tâches         60%   │  │  ← Suggestion IA #1
│  │  Font.qlBody   qlPrimaryLabel  badge │  │    Badge confidence : "60%"
│  │                               qlAccent   bg qlAccent opacity 0.15
│  │                               Font.qlCaption1
│  └──────────────────────────────────────┘  │
│                                             │
│  TOUTES LES LISTES                          │  ← Section "toutes options"
│  Font.qlCaption1.uppercased               │
│  qlSecondaryLabel                           │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  cart.fill   Courses                 │  │  ← Chaque liste dispo
│  ├──────────────────────────────────────┤  │    icon + nom + chevron
│  │  checklist   Tâches               ✓ │  │  ← Sélection (correspond suggestion)
│  ├──────────────────────────────────────┤  │    checkmark.fill qlAccent
│  │  lightbulb   Idées                  │  │
│  ├──────────────────────────────────────┤  │
│  │  folder      Projets                │  │
│  ├──────────────────────────────────────┤  │
│  │  star        Favoris                │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  tray.fill   Laisser dans l'Inbox    │  │  ← Option de ne rien faire
│  │              qlSecondaryLabel        │  │    qlTertiaryLabel pour icône
│  └──────────────────────────────────────┘  │
│                                             │
│ ████████████████████████████████████████████│
└─────────────────────────────────────────────┘
```

---

## Comportement après sélection

Tap sur une liste :
1. Sheet dismiss (Motion.qlFade)
2. Item retiré de l'Inbox et ajouté à la liste sélectionnée
3. Toast de confirmation : "[Item] ajouté à [Nom de liste]"
4. Si l'Inbox est maintenant vide : la card Inbox disparaît de HomeView (fade)

Feedback haptique : UINotificationFeedbackGenerator(.success)

---

## Etat : Inbox vide

L'Inbox ne s'affiche pas sur la HomeView. Aucun élément ne signale son existence. Elle est transparente pour l'utilisateur.

---

## Etat : Sans Apple Intelligence (US-19)

La section "SUGGESTIONS IA" est absente. Seule la liste de toutes les listes est présentée.

```
│                                             │
│  TOUTES LES LISTES                          │  ← Sans section suggestions
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  cart.fill   Courses                 │  │
│  ├──────────────────────────────────────┤  │
│  │  checklist   Tâches                  │  │
│  ...                                        │
```

Note : sans Apple Intelligence, la fonction d'auto-routage n'existe pas. Donc l'Inbox ne devrait jamais se remplir (pas de classification automatique). La fiche Inbox est donc présente dans le design pour les cas où Apple Intelligence était disponible mais a renvoyé une confiance faible — ou pour un ajout depuis une capture rapide globale (future feature).

---

## Interactions

| Action | Geste | Feedback |
|--------|-------|----------|
| Tap item dans Inbox | Tap | UIImpactFeedbackGenerator(.light) + InboxRoutingSheet |
| Sélectionner liste | Tap | UINotificationFeedbackGenerator(.success) + dismiss |
| Laisser dans Inbox | Tap "Laisser dans l'Inbox" | UIImpactFeedbackGenerator(.light) + dismiss |
| Swipe to delete (Inbox) | Swipe gauche | Suppression avec UndoToast |

---

## Adaptations iPad / macOS

iPad : le routage se fait dans un popover ancré sur l'item dans la sidebar ou le detail pane.

macOS : sheet modal natif. Les suggestions IA s'affichent avec le niveau de confiance en pourcentage.
