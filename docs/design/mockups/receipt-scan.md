# Mockup — Scan de ticket de caisse (Foundation Models)

> US couvertes : US-17, US-19
> A VALIDER PAR L'UTILISATEUR AVANT IMPLEMENTATION

---

## Vue fullScreenCover — Etat : camera

```
┌─────────────────────────────────────────────┐
│  (Fond noir — vue camera plein écran)       │  ← AVFoundation Camera
│                                             │
│  ████████████████████████████████████████  │  ← Status bar (light content)
│                                             │
│  ✕                      Scanner un ticket  │  ← NavigationBar sur fond camera
│  xmark                  Font.qlTitle3      │    Tout en blanc (fond sombre)
│  white                  white              │
│                                             │
│                                             │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │                                      │  │
│  │                                      │  │
│  │   [Zone de capture guidée]           │  │  ← Rectangle guide
│  │   Coins arrondis lumineux            │  │    Radius.qlLarge
│  │   (white, 2pt stroke)                │  │    Coin renforcés (L-shapes)
│  │                                      │  │    Blanc, 2pt stroke
│  │                                      │  │    Rapport : A4 portrait ~
│  │                                      │  │    3/4 de la largeur écran
│  │                                      │  │
│  │                                      │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  Cadrez le ticket dans le rectangle        │  ← Guide textuel
│  Font.qlCallout · white opacity 0.9        │    centré, sous le guide
│                                             │
│                                             │
│                                             │
│         ┌──────────────────────────┐       │
│         │ ○ [capture]              │       │  ← Bouton déclencheur
│         │   Cercle blanc 72pt      │       │    Style natif camera
│         │   ring intérieur 64pt    │       │
│         └──────────────────────────┘       │
│                                             │
│                                             │
│  ████████████████████████████████████████  │
└─────────────────────────────────────────────┘
```

Note : si VisionKit peut détecter automatiquement un document, un flash visuel (highlight vert) signale la détection et déclenche la capture automatiquement.

---

## Etat : Processing (Foundation Models en cours)

```
┌─────────────────────────────────────────────┐
│  (Photo capturée visible en fond, assombrie) │  ← Image capturée
│  overlay : qlOverlay (noir 40% opacity)     │    opacity réduite à 0.3
│                                             │
│                                             │
│                                             │
│                                             │
│                                             │
│                                             │
│              sparkles (32pt)               │  ← Icône IA
│              Color.qlAIAccent              │    centré
│              pulse animation               │
│                                             │
│   Extraction des produits…                  │  ← ql.receipt.processing
│   Font.qlTitle3 · white (centré)           │
│                                             │
│   Cela peut prendre quelques instants.      │
│   Font.qlBody · white opacity 0.7 (centré) │
│                                             │
│                                             │
│                                             │
│   ┌──────────────────────────────────┐     │  ← Barre de progression indéterminée
│   │ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │     │    ProgressView système (blanc)
│   └──────────────────────────────────┘     │
│                                             │
│                                             │
└─────────────────────────────────────────────┘
```

---

## Etat : Review (items extraits)

```
┌─────────────────────────────────────────────┐
│ ████████████████████████████████████████████│
├─────────────────────────────────────────────┤
│  ✕ Annuler    Ticket scanné    Ajouter [5] →│  ← "Ajouter [N] sélectionnés"
│              Font.qlTitle3     Font.qlBody  │    Actif si ≥ 1 item coché
│                               .semibold     │    qlAccent
│                               qlAccent      │
├─────────────────────────────────────────────┤
│                                             │
│  5 produits détectés                        │  ← Résumé
│  Font.qlCallout · qlSecondaryLabel          │
│                                             │
│  ┌──────────────────────────────────────┐  │  ← Liste des items extraits
│  │  ☑  Lait demi-écrémé 1L             │  │    Tous cochés par défaut
│  │     Font.qlBody · qlPrimaryLabel    │  │    Checkbox 24pt
│  ├──────────────────────────────────────┤  │    Minimum 44pt hauteur
│  │  ☑  Yaourts nature x4               │  │
│  ├──────────────────────────────────────┤  │
│  │  ☑  Pâtes linguine 500g             │  │
│  ├──────────────────────────────────────┤  │
│  │  ☐  TAXE TVA 5.5%                   │  │  ← Item non-produit (ligne de taxe)
│  │     Font.qlBody · qlSecondaryLabel  │  │    Décoché automatiquement
│  │     (apparence grisée)              │  │    L'utilisateur peut recocher
│  ├──────────────────────────────────────┤  │
│  │  ☑  Pain de campagne                │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │  ← Aperçu du ticket (miniature)
│  │  [Image du ticket, miniature 80x120] │  │    En bas, collapsable
│  │  Corner radius qlSmall               │  │    Tap pour agrandir
│  │  opacity 0.8                         │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  Touchez un item pour le modifier          │  ← Hint édition
│  Font.qlFootnote · qlTertiaryLabel (centré)│
│                                             │
│ ████████████████████████████████████████████│
└─────────────────────────────────────────────┘
```

---

## Edition inline d'un item extrait

```
│  ┌──────────────────────────────────────┐  │
│  │  ☑  ┌─────────────────────────────┐ │  │  ← Tap sur le texte → éditable
│  │     │  Lait demi-écrémé 1L|       │ │  │    TextField inline, focus
│  │     └─────────────────────────────┘ │  │    Clavier monte
│  └──────────────────────────────────────┘  │    Return pour valider
```

---

## Etat : Erreur (extraction impossible)

```
├─────────────────────────────────────────────┤
│  ✕ Annuler     Ticket scanné               │
├─────────────────────────────────────────────┤
│                                             │
│              doc.badge.exclamationmark      │
│              (32pt, Color.qlDanger)         │
│                                             │
│   Impossible d'extraire les produits.       │
│   Font.qlTitle3 · qlPrimaryLabel (centré)  │
│                                             │
│   Le ticket est peut-être illisible ou      │
│   mal cadré. Réessayez en veillant à        │
│   photographier tout le ticket.             │
│   Font.qlBody · qlSecondaryLabel (centré)  │
│                                             │
│         ┌────────────────────────┐         │
│         │   Rescanner            │         │  ← Retry : revient à la camera
│         └────────────────────────┘         │    qlAccent
│                                             │
│         ┌────────────────────────┐         │
│         │   Saisir manuellement  │         │  ← Fallback : retour à la liste
│         └────────────────────────┘         │    qlSecondaryLabel
│                                             │
│ ████████████████████████████████████████████│
```

---

## Etat : Apple Intelligence indisponible (US-19)

Le bouton de scan est absent de l'interface. Si accès direct :

```
│              doc.viewfinder.slash           │  ← Icône
│              (32pt, qlSecondaryLabel)       │    (doc.viewfinder + slash overlay)
│                                             │
│   Scan de ticket non disponible            │
│   Font.qlTitle3 · qlPrimaryLabel (centré)  │
│                                             │
│   Cette fonctionnalité nécessite Apple      │
│   Intelligence (iOS 26+).                  │
│   Font.qlBody · qlSecondaryLabel (centré)  │
│                                             │
│         ┌────────────────────────┐         │
│         │     Fermer             │         │
│         └────────────────────────┘         │
```

---

## Interactions

| Action | Geste | Feedback |
|--------|-------|----------|
| Déclencher capture | Tap bouton ou détection auto | UIImpactFeedbackGenerator(.medium) |
| Cocher/décocher item | Tap checkbox | UIImpactFeedbackGenerator(.light) |
| Editer item | Tap sur texte | Focus inline |
| Annuler | Tap ✕ | — |
| Ajouter sélection | Tap "Ajouter [N]" | UINotificationFeedbackGenerator(.success) |
| Agrandir ticket | Tap miniature | Motion.qlExpressive (zoom in) |

---

## Adaptations iPad / macOS

iPad : la vue camera utilise `UIDocumentCameraViewController` pour un meilleur résultat de scan. La review s'affiche en `.formSheet`.

macOS : la feature scan est absente sur macOS (pas de camera orientée document). Le menu "Scanner un ticket" n'est pas visible sur macOS.
