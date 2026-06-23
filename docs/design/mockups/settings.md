# Mockup — Réglages

> US couvertes : US-10, US-19, transversales
> A VALIDER PAR L'UTILISATEUR AVANT IMPLEMENTATION

---

## Accès

Les Réglages sont accessibles depuis la HomeView via un bouton `gearshape.fill` dans la NavigationBar (trailing, secondaire derrière le bouton +) ou depuis les Réglages système iOS (bundle de l'app → Réglages in-app).

---

## iPhone Portrait — SettingsView

```
┌─────────────────────────────────────────────┐
│ ████████████████████████████████████████████│
├─────────────────────────────────────────────┤
│  ◀ Retour            Réglages               │  ← NavigationBar
│                      Font.qlTitle1          │
│                      .semibold              │
├─────────────────────────────────────────────┤
│                                             │  ← SwiftUI Form (grouped)
│  SYNCHRONISATION                            │  ← Section header
│  Font.qlCaption1.uppercased                │    qlSecondaryLabel
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  icloud.fill   iCloud                │  │  ← Row statut iCloud
│  │  qlAccent      Font.qlBody          │  │    Sous-titre : SyncIndicator inline
│  │                Actif ☁✓              │  │    "Actif" / "Désactivé" / "Erreur"
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  Compte iCloud   freecompub5@gmail   │  │  ← Email (anonymisé en prod)
│  │  Font.qlBody     Font.qlCallout      │  │    qlSecondaryLabel pour l'email
│  └──────────────────────────────────────┘  │
│                                             │
│  APPLE INTELLIGENCE                         │  ← Section IA
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  sparkles      Apple Intelligence    │  │  ← Statut Apple Intelligence
│  │  qlAIAccent    Font.qlBody          │  │    badge "Disponible" / "Indisponible"
│  │               [Disponible ●]         │  │    ● vert si dispo, gris si non
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  Tri par rayon (IA)    [Toggle ON]   │  │  ← Toggle : activer/désactiver
│  │  Font.qlBody                         │  │    Désactivé si IA indisponible
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  Suggestions d'items    [Toggle ON]  │  │
│  │  Font.qlBody                         │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  Import vocal (dictée)  [Toggle ON]  │  │
│  │  Font.qlBody                         │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  Scan de ticket        [Toggle ON]   │  │
│  │  Font.qlBody                         │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  APPARENCE                                  │  ← Section apparence
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  Thème           [Auto | Clair | Sombre] ← Picker tri-état
│  │  Font.qlBody                         │  │    Segmented style
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  Couleur d'accent    [● Bleu (déf.)] │  │  ← Sélecteur couleur d'accent
│  │  Font.qlBody         Font.qlCallout  │  │    (si couleur personnalisable)
│  │                      qlAccent        │  │    → voir Questions Ouvertes
│  └──────────────────────────────────────┘  │
│                                             │
│  MODE COURSES                               │  ← Section courses
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  Articles faits       [Bas | Masqués]│  │  ← Segmented picker
│  │  Font.qlBody                         │  │    "En bas de section" / "Masqués"
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  Réinitialiser les catégories IA     │  │  ← Bouton destructif (modal)
│  │  Font.qlBody · Color.qlDanger        │  │    Efface CategoryPreference
│  └──────────────────────────────────────┘  │
│                                             │
│  À PROPOS                                   │  ← Section about
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  Version             1.0.0 (42)      │  │
│  ├──────────────────────────────────────┤  │
│  │  Confidentialité  [Voir la politique]│  │
│  ├──────────────────────────────────────┤  │
│  │  Mentions légales                 >  │  │
│  ├──────────────────────────────────────┤  │
│  │  Contacter le support             >  │  │
│  └──────────────────────────────────────┘  │
│                                             │
│                                             │
│ ████████████████████████████████████████████│
└─────────────────────────────────────────────┘
```

---

## Etat : Apple Intelligence indisponible (US-19)

```
│  ┌──────────────────────────────────────┐  │
│  │  sparkles.slash   Apple Intelligence │  │  ← qlSecondaryLabel (pas qlAIAccent)
│  │  qlSecondaryLabel Font.qlBody       │  │
│  │               [Non disponible ○]     │  │    ● gris
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  Tri par rayon (IA)    [Toggle OFF]  │  │  ← Toggles grisés et non-interactifs
│  │  Font.qlBody · qlTertiaryLabel       │  │    visually disabled
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  Suggestions d'items    [Toggle OFF] │  │
│  │  qlTertiaryLabel                     │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  En savoir plus sur Apple            │  │  ← Lien vers la page Apple
│  │  Intelligence              [→ Apple] │  │    Font.qlCallout qlAccent
│  └──────────────────────────────────────┘  │
```

---

## Interactions

| Action | Geste | Feedback |
|--------|-------|----------|
| Toggle IA | Tap toggle | UIImpactFeedbackGenerator(.light) |
| Thème | Tap segmented | UIImpactFeedbackGenerator(.light) |
| Réinitialiser catégories | Tap | Alert de confirmation → UINotificationFeedbackGenerator(.warning) |
| Lien externe | Tap | Ouverture Safari |

---

## Adaptations iPad / macOS

iPad : les réglages s'ouvrent dans un detail pane dédié (NavigationSplitView avec sidebar Réglages).

macOS : les Réglages sont accessibles via le menu QuickList > Préférences (Cmd+,). Ils s'ouvrent dans un panneau SwiftUI Settings (macOS 13+ style tabView).

Onglets macOS :
- "Général" (synchronisation, apparence)
- "Apple Intelligence" (IA toggles)
- "Mode Courses" (comportement courses)
- "À propos"
