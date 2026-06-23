# Mockup — Import vocal (Foundation Models)

> US couvertes : US-16, US-18, US-19
> A VALIDER PAR L'UTILISATEUR AVANT IMPLEMENTATION

---

## Sheet VoiceImport — Etat : idle

```
┌─────────────────────────────────────────────┐
│  (contenu derrière, assombri)                │
│                                             │
│                                             │
├─────────────────────────────────────────────┤
│            ════                             │  ← Grabber (detent .medium → .large)
│                                             │
│  ✕                  Import vocal           │  ← xmark ferme la sheet
│  Font.qlBody         Font.qlTitle3          │    (si pas d'enregistrement actif)
│  qlAccent            qlPrimaryLabel.semibold│
│                                             │
│                                             │
│                                             │
│              ┌───────────────┐              │
│              │               │              │
│              │    mic.fill   │              │  ← Bouton microphone principal
│              │    (36pt)     │              │    Cercle 80pt de diamètre
│              │               │              │    bg Color.qlAccent
│              └───────────────┘              │    Color.white pour icône
│                                             │    Shadow.qlCard
│                                             │
│   Dites vos items à voix haute.             │  ← ql.voice.instruction
│   Font.qlBody · Color.qlSecondaryLabel      │    centré
│   (centré, padding horizontal Spacing.qlXXL)│
│                                             │
│   Exemple : "du lait, des pâtes et          │  ← Hint text
│   appeler le dentiste"                      │    Font.qlFootnote
│   Font.qlFootnote                           │    Color.qlTertiaryLabel
│   Color.qlTertiaryLabel (centré)            │    italique optionnel
│                                             │
│                                             │
│                                             │
│ ████████████████████████████████████████████│
└─────────────────────────────────────────────┘
```

---

## Sheet VoiceImport — Etat : recording

```
├─────────────────────────────────────────────┤
│            ════                             │
│                                             │
│  ✕              Import vocal  ●  0:03      │  ← Chronomètre de durée
│                                 qlDanger    │    Point rouge pulse = REC
│                                             │
│                                             │
│   ▁▂▃▅▆▄▂▁▃▅▇▅▃▁▂▄▆▇▆▄▂▁▃▅▄▃▂▁           │  ← Waveform animée
│   (représentation ASCII, en réalité SVG     │    Barres de hauteur variable
│    ou Canvas animé selon amplitude micro)   │    Color.qlAccent pour les barres
│                                             │    Reduce Motion → barres fixes
│                                             │
│   "du lait, des pâtes et appeler…"         │  ← Transcription live (Speech)
│   Font.qlBody · qlPrimaryLabel             │    Texte apparaît au fur et à mesure
│   (zone de 3-4 lignes, centré)             │    Légère opacité sur le texte en cours
│                                             │
│                                             │
│              ┌───────────────┐              │  ← Bouton Stop
│              │               │              │    Cercle 80pt
│              │ stop.fill     │              │    bg Color.qlDanger
│              │ (36pt)        │              │    Color.white pour icône
│              │               │              │
│              └───────────────┘              │
│                                             │
│  "Parlez maintenant…"                       │  ← Label état
│  Font.qlCallout · qlSecondaryLabel (centré) │
│                                             │
│ ████████████████████████████████████████████│
```

---

## Sheet VoiceImport — Etat : processing

```
├─────────────────────────────────────────────┤
│            ════                             │
│                                             │
│  ✕              Import vocal               │
│                                             │
│                                             │
│              sparkles (28pt)               │  ← Icon IA centré
│              Color.qlAIAccent              │    pulse si Reduce Motion off
│                                             │
│   Analyse en cours…                         │  ← ql.voice.processing
│   Font.qlBody · qlSecondaryLabel (centré)  │
│                                             │
│                                             │
│  ┌──────────────────────────────────────┐  │  ← Placeholder items en shimmer
│  │  ░░░░░░░░░░░░░░░░░░░░░░░░░░          │  │    (skeleton loading)
│  │  ░░░░░░░░░░░░░░░                     │  │    3 lignes de hauteur ListRow
│  │  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░        │  │    bg qlSurface avec shimmer
│  └──────────────────────────────────────┘  │    animé si Reduce Motion off
│                                             │
│                                             │
│ ████████████████████████████████████████████│
```

---

## Sheet VoiceImport — Etat : review

```
├─────────────────────────────────────────────┤
│            ════                             │
│                                             │
│  Modifier            Import vocal   Ajouter │  ← "Ajouter [3] items"
│  Font.qlBody.qlAccent Font.qlTitle3  btn    │    Font.qlBody.semibold qlAccent
│                                             │    désactivé si 0 items cochés
│                                             │
│  3 items trouvés                            │  ← Résumé
│  Font.qlCallout · qlSecondaryLabel          │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  ☑  Lait                  Crèmerie  │  │  ← Item parsé avec checkbox
│  │     Font.qlBody            qlCaption │  │    Tous cochés par défaut
│  │     qlPrimaryLabel         qlSecondaryLabel
│  ├──────────────────────────────────────┤  │
│  │  ☑  Pâtes                 Épicerie  │  │
│  ├──────────────────────────────────────┤  │
│  │  ☑  Appeler le dentiste   Tâches ●  │  │  ← Routage : proposition de liste
│  │     Font.qlBody            badge     │  │    Badge "Tâches" : qlAccent bg
│  └──────────────────────────────────────┘  │    Font.qlCaption1.bold white
│                                             │    (si liste différente de la courante)
│                                             │
│  Les items seront ajoutés à :               │  ← Footer explicatif
│  "Courses" (2 items) · "Tâches" (1 item)   │    Font.qlFootnote qlSecondaryLabel
│                                             │
│                                             │
│ ████████████████████████████████████████████│
```

---

## Cas : confiance faible sur le routage (US-18)

Si Foundation Models a une confiance faible sur la liste de destination d'un item, cet item est signalé :

```
│  ┌──────────────────────────────────────┐  │
│  │  ☑  truc à faire               [?]  │  │  ← Badge "?" orange
│  │     Font.qlBody         questionmark │  │    Color.qlWarning
│  │                          .circle.fill│  │    Tap → InboxRoutingSheet inline
│  └──────────────────────────────────────┘  │
```

---

## Etat : Erreur

```
│              exclamationmark.triangle.fill   │  ← Icône erreur
│              (28pt, Color.qlDanger)          │
│                                             │
│  Impossible d'analyser l'audio.             │
│  Font.qlBody · qlPrimaryLabel (centré)      │
│                                             │
│  Vérifiez les permissions du microphone     │
│  et réessayez.                              │
│  Font.qlCallout · qlSecondaryLabel (centré) │
│                                             │
│         ┌──────────────────┐               │
│         │   Réessayer      │               │  ← Bouton retry qlAccent
│         └──────────────────┘               │
```

---

## Etat : Apple Intelligence indisponible (US-19)

Le bouton [mic] est absent de l'AddItemBar. Si l'utilisateur accède malgré tout à la sheet (via un lien direct ou un bug), on montre :

```
│              sparkles.slash (28pt)          │
│              Color.qlSecondaryLabel         │
│                                             │
│  Apple Intelligence                         │
│  non disponible                             │
│  Font.qlTitle2 · qlPrimaryLabel (centré)   │
│                                             │
│  L'import vocal nécessite Apple             │
│  Intelligence (iOS 26+).                    │
│  Font.qlBody · qlSecondaryLabel (centré)   │
│                                             │
│         ┌──────────────────┐               │
│         │     Fermer       │               │  ← qlSecondaryLabel
│         └──────────────────┘               │
```

---

## Interactions

| Action | Geste | Feedback |
|--------|-------|----------|
| Démarrer enregistrement | Tap bouton micro | UIImpactFeedbackGenerator(.heavy) |
| Arrêter | Tap bouton stop | UIImpactFeedbackGenerator(.medium) |
| Cocher/décocher item | Tap | UIImpactFeedbackGenerator(.light) |
| Éditer item inline | Tap sur texte de l'item | UIImpactFeedbackGenerator(.light) + focus |
| Valider | Tap "Ajouter N items" | UINotificationFeedbackGenerator(.success) |
| Fermer | Tap ✕ ou swipe down | — |

---

## Adaptations iPad / macOS

iPad : la sheet s'affiche en `.formSheet`. La waveform est plus large.

macOS : fonctionnalité disponible via le menu Edition > "Dicter des items" ou raccourci. La sheet devient un panneau flottant (NSPanel). La waveform s'adapte à la fenêtre.
