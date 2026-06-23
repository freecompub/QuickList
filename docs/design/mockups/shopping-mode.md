# Mockup — Mode Courses dédié (plein écran)

> US couvertes : US-08, US-09, US-07
> A VALIDER PAR L'UTILISATEUR AVANT IMPLEMENTATION

---

## iPhone Portrait — Mode Courses actif

Accès : onglet "Courses" de la TabBar (décision QO-4). Ce n'est plus un fullScreenCover — c'est la vue racine de l'onglet 1.

```
┌─────────────────────────────────────────────┐
│ ████████████████████████████████████████████│  ← Status bar
├─────────────────────────────────────────────┤
│  Courses                     [3/8 faits]    │  ← NavigationTitle (onglet racine)
│  Font.qlTitle1.semibold       Font.qlCallout│    Pas de bouton [✕] — on change d'onglet
│  qlPrimaryLabel               qlSecondaryLabel   Compteur : "[N faits]/[N total] faits"
├─────────────────────────────────────────────┤
│                                             │
│  ┌──────────────────────────────────────┐  │  ← CategoryHeader : FRUITS & LÉGUMES
│  │ leaf.fill   FRUITS & LÉGUMES  · 3   │  │    Hauteur 40pt (plus grand qu'en détail)
│  └──────────────────────────────────────┘  │    bg Color.qlRayonFruitsLegumes
│  Color.qlRayonFruitsLegumes (fond section)  │    (s'étend sur toute la section)
│                                             │
│  ┌──────────────────────────────────────┐  │  ← ListRow variante shoppingMode
│  │                                      │  │    Hauteur : 64pt minimum
│  │  ○   Tomates                         │  │    Font.qlHeadline (plus grand)
│  │      Font.qlHeadline                 │  │    checkbox : 32pt (grande cible)
│  │                                      │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │                                      │  │
│  │  ○   Pommes                          │  │
│  │      Font.qlHeadline                 │  │
│  │                                      │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │  ← Item coché (fait) — QO-3 validée
│  │                                      │  │    L'item glisse en bas de sa section
│  │  ✓   ̶P̶o̶m̶m̶e̶s̶ ̶d̶e̶ ̶t̶e̶r̶r̶e̶              ✓  │  │    checkmark.circle.fill qlSuccess
│  │      ̶F̶o̶n̶t̶.̶q̶l̶H̶e̶a̶d̶l̶i̶n̶e̶ strikethrough │  │    Texte grisé, opacité 0.5
│  │      Color.qlItemDone opacity 0.5    │  │    Animation spring (Motion.qlStandard)
│  │                                      │  │    L'item reste visible (jamais masqué)
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │  ← CategoryHeader : CRÈMERIE
│  │ drop.fill   CRÈMERIE          · 2   │  │
│  └──────────────────────────────────────┘  │
│  Color.qlRayonCremerie                      │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │                                      │  │
│  │  ○   Lait                            │  │
│  │      Font.qlHeadline                 │  │
│  │                                      │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │                                      │  │
│  │  ○   Yaourts nature                  │  │
│  │      Font.qlHeadline                 │  │
│  │                                      │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │  ← CategoryHeader : ÉPICERIE
│  │ archivebox.fill  ÉPICERIE    · 1    │  │
│  └──────────────────────────────────────┘  │
│  Color.qlRayonEpicerie                      │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │                                      │  │
│  │  ○   Pâtes                           │  │
│  │      Font.qlHeadline                 │  │
│  │                                      │  │
│  └──────────────────────────────────────┘  │
│                                             │
├─────────────────────────────────────────────┤
│  [checklist]              [cart.fill ●]     │  ← TabBar — onglet Courses actif
│   Listes                   Courses          │    qlAccent sur Courses
│ ████████████████████████████████████████████│
└─────────────────────────────────────────────┘
```

Note design : en mode Courses, l'AddItemBar est absente. Le focus est sur la coche rapide. Pour ajouter un item, l'utilisateur bascule sur l'onglet "Listes" via la TabBar, ouvre la liste Courses, ajoute l'item, puis revient sur "Courses".

---

## Progression : tous les items faits (QO-5 validée — animation minimaliste)

Décision QO-5 : état de célébration minimaliste. Checkmark + fondu uniquement. Pas de confetti.

```
┌─────────────────────────────────────────────┐
│ ████████████████████████████████████████████│
├─────────────────────────────────────────────┤
│  Courses                     [8/8 faits]    │
│                               Color.qlSuccess│  ← Compteur passe en vert (fade 0.3s)
├─────────────────────────────────────────────┤
│                                             │
│                                             │
│          checkmark.circle.fill              │  ← Icône (56pt, Color.qlSuccess)
│          (56pt, Color.qlSuccess)            │    Apparition : scale 0.6 → 1.0
│          scale spring + fade in             │    spring response 0.4, damping 0.6
│                                             │    Reduce Motion → simple fade in
│                                             │
│         Courses terminées.                  │  ← Titre (pas de "!")
│         Font.qlTitle2                       │    Ton calme et satisfait
│         Color.qlPrimaryLabel                │    Fade in 0.3s après l'icône
│                                             │
│    Tous vos articles ont été cochés.        │  ← Sous-titre
│    Font.qlBody · Color.qlSecondaryLabel     │    Fade in 0.4s
│                                             │
│         ┌──────────────────────┐            │
│         │   Terminer les       │            │  ← Bouton primary
│         │     courses          │            │    bg qlAccent, white label
│         └──────────────────────────────────┘    Radius.qlPill
│                                             │    Font.qlHeadline.semibold
│         ┌──────────────────────┐            │
│         │  Tout décocher       │            │  ← Bouton secondary (recommencer)
│         └──────────────────────────────────┘    bg transparent, qlSecondaryLabel
│                                             │    (moins proéminent que "Terminer")
├─────────────────────────────────────────────┤
│  [checklist]              [cart.fill ●]     │  ← TabBar
│ ████████████████████████████████████████████│
└─────────────────────────────────────────────┘
```

---

## Long Press — Corriger un rayon (US-09)

```
┌─────────────────────────────────────────────┐
│                                             │
│  ┌──────────────────────────────────────┐  │  ← Long press sur item "Tofu"
│  │                                      │  │    Item se "soulève" légèrement
│  │  ○   Tofu                            │  │    (scale 1.03, shadow visible)
│  │      Font.qlHeadline                 │  │
│  │                                      │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  ContextMenu (HIG : Context Menus) :        │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  Déplacer vers le rayon              │  │  ← Menu title (non-tappable)
│  │  ─────────────────────────────────── │  │
│  │  leaf.fill      Fruits & Légumes     │  │
│  │  fork.knife     Boucherie            │  │
│  │  drop.fill    ✓ Crèmerie             │  │  ← Rayon actuel = checkmark
│  │  archivebox.fill Épicerie            │  │
│  │  snowflake      Surgelés             │  │
│  │  birthday.cake.fill Boulangerie      │  │
│  │  cup.and.saucer.fill Boissons        │  │
│  │  shower.fill    Hygiène              │  │
│  │  square.grid.2x2.fill Autres         │  │
│  └──────────────────────────────────────┘  │
```

---

## Comportement items faits (QO-3 validée — glissement en bas)

Les items cochés glissent en bas de leur section. Comportement unique, pas de réglage.

Animation : `Motion.qlStandard` (spring response 0.3, damping 0.75). L'item se déplace visuellement vers le bas de la section, sous les items non faits. Il reste visible mais grisé (`Color.qlItemDone`, opacité 0.5, strikethrough). L'utilisateur peut ainsi voir ce qui est déjà dans son panier.

Il n'y a pas d'option de masquage dans les réglages. Cette décision simplifie l'implémentation et l'interface.

---

## Interactions

| Action | Geste | Feedback |
|--------|-------|----------|
| Cocher item | Tap n'importe où sur la row (64pt) | UIImpactFeedbackGenerator(.medium) |
| Décocher item | Tap sur item grisé | UIImpactFeedbackGenerator(.light) |
| Corriger rayon | Long press | UIImpactFeedbackGenerator(.medium) + ContextMenu |
| Quitter mode | Tap onglet Listes (TabBar) | Transition native TabView |
| Faire défiler | Swipe vertical | — |

---

## Adaptations iPad

- Mode Courses en splitview : sidebar montre les rayons (liens d'ancrage), contenu à droite
- En paysage, les rows peuvent passer en 2 colonnes pour utiliser la largeur disponible (à valider)

## Adaptations macOS

- Le mode Courses est une vue dans le detail pane, pas un fullScreenCover
- Les CategoryHeaders s'affichent comme des section headers de List
- La coche se fait au clavier (Espace) ou à la souris
