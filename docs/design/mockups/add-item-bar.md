# Mockup — Barre d'ajout + Suggestions (Zoom)

> US couvertes : US-01, US-20, US-16
> A VALIDER PAR L'UTILISATEUR AVANT IMPLEMENTATION

---

## Anatomie complète de l'AddItemBar (décision QO-2 validée : [+] externe)

Le bouton [+] est positionné à droite du TextField, hors du champ. C'est la disposition définitive.

```
┌──────────────────────────────────────────────────────────┐
│  Material.qlBarBackground + Shadow.qlAddBar              │
│  Padding : Spacing.qlL horizontal, Spacing.qlM vertical  │
│                                                          │
│  [chip 1]  [chip 2]  [chip 3]  [chip 4] →               │  ← SuggestionChips (si dispo)
│  Scroll horizontal, LazyHStack, Spacing.qlXS entre chips │
│                                                          │
│  ┌──────────────────────────────────┐    [+]            │
│  │                            [🎤]  │  plus.circle.fill │  ← TextField + boutons
│  │  Ajouter un item…          16pt  │  32pt symbol      │    Height TextField : 48pt
│  │  qlPlaceholder             44pt  │  44x44pt target   │    Radius.qlMedium
│  └──────────────────────────────────┘  Color.qlAccent   │    bg qlSecondaryBackground
│                                         (si typing)     │
│  Safe area bottom                       qlTertiaryLabel  │
│                                         (si idle)       │
│  ████████████████████████████████████████████████████████│
└──────────────────────────────────────────────────────────┘
```

---

## Etat : idle (champ vide)

```
│  ┌──────────────────────────────────┐    [+]            │
│  │                            [🎤]  │  qlTertiaryLabel  │  ← [+] visuellement inactif
│  │  Ajouter un item…                │                   │    (non-tappable pour éviter
│  └──────────────────────────────────┘                   │    les soumissions vides)
```

---

## Etat : typing (en cours de saisie)

```
│  ┌──────────────────────────────────┐    [+]            │
│  │                            [🎤]  │  Color.qlAccent   │  ← [+] passe en qlAccent
│  │  lait de soja|                   │  spring 0.2s      │    dès la première lettre
│  └──────────────────────────────────┘                   │    cursor | visible
│                                                          │
│  [lait entier]  [lait demi-écrémé]  [lait de coco] →   │  ← Suggestions apparues
│  SuggestionChips, LazyHStack, scroll horizontal         │    Motion.qlQuick (spring)
```

---

## Etat : voix active (US-16 — mic tap)

```
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │                                                  │  │  ← Le TextField est remplacé
│  │  ▁▂▄▆▄▂▁▂▃▅▆▅▃▂▁  ●  [Stop]                    │  │    par la waveform
│  │  Waveform animée (AudioKit ou AVFoundation)      │  │    Bouton Stop : carré rouge
│  │  Color.qlDanger pour stop                        │  │    44x44pt
│  │  "du lait, des pâtes…" (transcription live)      │  │    Texte transcrit sous la wave
│  │  Font.qlCallout · qlSecondaryLabel               │  │
│  └──────────────────────────────────────────────────┘  │
│                                                          │
│  Material.qlBarBackground                               │
```

---

## SuggestionChips — Anatomie détaillée

```
╔══════════════════════╗  ╔══════════════╗  ╔════════════════╗
║  [leaf]  Tomates     ║  ║  Lait entier ║  ║  [star] Café   ║
╚══════════════════════╝  ╚══════════════╝  ╚════════════════╝

Hauteur : 32pt
Padding : Spacing.qlS (8pt) vertical, Spacing.qlM (12pt) horizontal
bg : Color.qlSurface
border : 1pt Color.qlSeparator
corner : Radius.qlPill
texte : Font.qlSuggestionChip · Color.qlAccent
icône : SF Symbol 14pt · Color.qlSecondaryLabel (optionnelle, si rayon connu)
```

---

## Comportement des suggestions

Source des suggestions (par priorité) :
1. Items précédemment ajoutés dans cette liste (historique)
2. Items fréquents de toutes les listes du même type
3. Suggestions génériques selon le type de liste (Courses : aliments courants)

Filtrage : les chips sont filtrées en temps réel sur le texte saisi. Si le texte match une suggestion, elle est mise en premier.

Tap sur une chip :
- Item ajouté immédiatement à la liste
- La chip disparaît de la rangée (si item unique)
- Focus revient sur le TextField

---

## Interactions

| Action | Geste | Feedback |
|--------|-------|----------|
| Valider item | Return ou tap [+] | UIImpactFeedbackGenerator(.light) |
| Utiliser suggestion | Tap chip | UIImpactFeedbackGenerator(.light) + scale 0.94 |
| Dicter | Tap [mic] | UIImpactFeedbackGenerator(.medium) + VoiceImportSheet |
| Annuler dictée | Tap Stop | UIImpactFeedbackGenerator(.light) |

---

## VoiceOver

- TextField : accessibilityLabel "Ajouter un item", accessibilityHint "Taper le nom et appuyer sur Entrée"
- Bouton [+] : accessibilityLabel "Ajouter", accessibilityHint "Ajoute le texte saisi à la liste"
- Bouton [mic] : accessibilityLabel "Dicter des items", accessibilityHint "Ouvre l'import vocal"
- Chip : accessibilityLabel "Suggestion : [texte]", accessibilityHint "Toucher deux fois pour ajouter"

---

## Adaptations iPad / macOS

iPad : la barre est identique, légèrement plus large. Les suggestions s'affichent en grille (2 rangées) si l'espace le permet.

macOS : pas de barre flottante — le champ d'ajout est intégré en bas de la liste dans le detail pane. Le bouton mic est absent (pas de Speech Recognition en temps réel sur macOS via même API). Raccourci : Cmd+T pour focus.
