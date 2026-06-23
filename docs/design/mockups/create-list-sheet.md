# Mockup — Sheet de création de liste

> US couvertes : US-03
> A VALIDER PAR L'UTILISATEUR AVANT IMPLEMENTATION

---

## iPhone Portrait — Sheet de création (.medium → .large)

```
┌─────────────────────────────────────────────┐
│  (contenu derrière, assombri par l'overlay)  │
│                                             │
│                                             │
│                                             │
│                                             │
├────────────────────────────────────────────┤  ← Sheet "grabber" bar
│              ════                          │    Color.qlSheetGrabber, 36x4pt
│                                            │    centré, Spacing.qlS depuis bord
├────────────────────────────────────────────┤
│                                            │
│  Annuler          Nouvelle liste  Créer    │  ← Sheet navigation bar
│  Font.qlBody      Font.qlTitle3   Font.qlBody.semibold
│  qlAccent         qlPrimaryLabel  qlAccent │
│  (disabled until  .semibold               │    "Créer" désactivé si nom vide
│   name entered)                            │
│                                            │
├────────────────────────────────────────────┤
│                                            │
│  ┌────────────────────────────────────┐   │  ← TextField nom
│  │  Nom de la liste                   │   │    bg Color.qlSecondaryBackground
│  │  Font.qlTitle2 · qlPlaceholder    │   │    Radius.qlMedium
│  │  Height : 52pt                     │   │    Padding : Spacing.qlL
│  └────────────────────────────────────┘   │    focus auto à l'ouverture
│  Spacing.qlXXL                             │
│                                            │
│  TYPE DE LISTE                             │  ← Section header
│  Font.qlCaption1.uppercased               │    Font.qlCaption1
│  Color.qlSecondaryLabel                   │    Color.qlSecondaryLabel
│  Padding left : Spacing.qlL               │
│                                            │
│  ┌──────────────────────────────────────┐ │  ← Type selector (5 options)
│  │                                      │ │    UISegmentedControl ou custom
│  │ [cart] [✓] [💡] [📁] [★]            │ │    grid 5 icônes
│  │  C-ses Tâch Idées Proj Fav           │ │    Sélection : ring qlAccent
│  │                                      │ │    bg Color.qlSurface
│  │  (icône active : grande, colorée)    │ │    Radius.qlLarge
│  └──────────────────────────────────────┘ │
│                                            │
│  Spacing.qlXXL                             │
│                                            │
│  ┌──────────────────────────────────────┐ │  ← Preview card (live)
│  │  [icon sélectionné 32pt]   [0] ●    │ │    Montre à quoi ressemblera
│  │                                      │ │    la ListCard
│  │  [Nom saisi ou "Ma liste"]           │ │    bg Color.qlSurface
│  │  0 items                             │ │    Radius.qlMedium · Shadow.qlCard
│  └──────────────────────────────────────┘ │    Transition live (typing)
│                                            │
│                                            │
│  ████████████████████████████████████████  │  ← Safe area
└────────────────────────────────────────────┘
```

---

## Sélecteur de type — Détail

Chaque type a une représentation visuelle distincte :

```
                COURSES         TÂCHES          IDÉES          PROJETS        FAVORIS
Icône         cart.fill       checklist      lightbulb.fill   folder.fill    star.fill
Couleur       qlAccent        qlPrimaryLabel qlWarning (jne) qlSecondaryLbl qlWarning (or)
Rendu         .multicolor     .hierarchical  .multicolor      .hierarchical  .multicolor

Etat actif :
  - Icône 28pt (vs 20pt inactif)
  - Fond circulaire qlAccent opacity 0.15
  - Label Font.qlCaption1.bold (vs .regular inactif)
  - Animation scale 1.0 → 1.2 → 1.0 (Motion.qlQuick, spring)

Etat inactif :
  - Icône 20pt, Color.qlTertiaryLabel
  - Pas de fond
  - Label Font.qlCaption2 qlTertiaryLabel
```

---

## Comportement

1. Sheet s'ouvre en detent `.medium` (50%)
2. Focus automatique sur le TextField nom
3. Le clavier monte → sheet passe à `.large` automatiquement (ou clavier couvre le sélecteur, à valider)
4. Saisie du nom : preview card se met à jour en live
5. Sélection du type : icône animée, preview card se met à jour
6. Tap "Créer" :
   - Sheet dismiss avec animation
   - HomeView : nouvelle ListCard apparaît (Motion.qlItemInsert)
   - Navigation vers ListDetail de la nouvelle liste (push immédiat)
   - Feedback haptique : UINotificationFeedbackGenerator(.success)

---

## Validation

- "Créer" est désactivé (grisé, non-tappable) si le nom est vide ou contient uniquement des espaces
- Pas de doublon forcé : deux listes peuvent avoir le même nom (c'est l'utilisateur qui gère)
- Nom limité à 50 caractères (limite douce : compteur visible après 40 caractères)

---

## Etat : Nom saisi, type Courses sélectionné

```
│  Annuler     Nouvelle liste       Créer     │  ← "Créer" activé (qlAccent)
│                                             │
│  ┌────────────────────────────────────┐    │
│  │  Courses du samedi                 │    │  ← Nom saisi
│  └────────────────────────────────────┘    │
│                                             │
│  TYPE DE LISTE                             │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │ [cart●]  [✓]  [💡]  [📁]  [★]       │  │  ← cart.fill sélectionné (ring qlAccent)
│  │  Cses    Tâch  Idées  Proj  Fav      │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  cart.fill (32pt, .multicolor)  [0]●│  │  ← Preview card live
│  │                                      │  │
│  │  Courses du samedi                   │  │
│  │  0 items                             │  │
│  └──────────────────────────────────────┘  │
```

---

## VoiceOver

- TextField nom : accessibilityLabel "Nom de la liste"
- Sélecteur type : accessibilityLabel "[Type]", accessibilityHint "Toucher deux fois pour sélectionner ce type de liste"
- Bouton Créer : accessibilityLabel "Créer la liste [nom]", accessibilityTraits .button (disabled si vide)
- Preview : accessibilityLabel "Aperçu : liste [nom], type [type], 0 items", accessibilityElementsHidden true (décoratif)

---

## Adaptations iPad / macOS

iPad : la sheet s'affiche en `.formSheet` (taille fixe, centrée), pas en plein écran.

macOS : panneau modal ou popover depuis le bouton "+" de la sidebar. Le type de liste est une roue de sélection ou un menu déroulant.
