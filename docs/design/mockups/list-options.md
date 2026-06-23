# Mockup — Options de liste (Renommer / Supprimer / Tri / Partage)

> US couvertes : US-05, US-06, US-21
> A VALIDER PAR L'UTILISATEUR AVANT IMPLEMENTATION

---

## Point d'accès

L'icône `ellipsis.circle` dans la NavigationBar du ListDetail ouvre ce panneau. Sur iPhone, c'est une sheet `.medium`. Sur iPad/macOS, c'est un popover.

---

## iPhone Portrait — ListOptions Sheet (.medium detent)

```
┌─────────────────────────────────────────────┐
│  (contenu derrière, assombri)                │
│                                             │
│                                             │
│                                             │
│                                             │
│                                             │
├─────────────────────────────────────────────┤
│            ════                             │  ← Grabber
│                                             │
│   Options  "Tâches"                         │  ← Titre contextuel (nom de la liste)
│   Font.qlTitle3.semibold                    │    centré ou leading
│   Color.qlPrimaryLabel                      │
│                                             │
│  ┌──────────────────────────────────────┐   │  ← Grouped sections (SwiftUI Form style)
│  │                                      │   │    bg Color.qlGroupedBackground
│  │   pencil    Renommer                 │   │    chaque row : 44pt min
│  │   Font.qlBody    qlPrimaryLabel      │   │
│  ├──────────────────────────────────────┤   │
│  │                                      │   │
│  │   person.2.badge.plus  Partager      │   │
│  │   Font.qlBody    qlPrimaryLabel      │   │
│  └──────────────────────────────────────┘   │
│                                             │
│  Note : "Mode Courses" n'est plus dans ce   │  ← Accès via onglet Courses (TabBar)
│  menu depuis la décision QO-4.              │    La ListOptionsSheet ne propose pas
│                                             │    de raccourci vers ShoppingModeView.
│                                             │
│  ┌──────────────────────────────────────┐   │  ← Section "Tri"
│  │   TRIER PAR                          │   │    Section header : qlCaption1.uppercased
│  ├──────────────────────────────────────┤   │    Color.qlSecondaryLabel
│  │                                      │   │
│  │  ✓  Ordre d'ajout                   │   │  ← Tri actuel : checkmark.fill qlAccent
│  │     Font.qlBody                      │   │
│  ├──────────────────────────────────────┤   │
│  │                                      │   │
│  │     Alphabétique                     │   │
│  │     Font.qlBody                      │   │
│  ├──────────────────────────────────────┤   │
│  │                                      │   │
│  │     Statut (fait / pas fait)         │   │
│  │     Font.qlBody                      │   │
│  │                                      │   │
│  └──────────────────────────────────────┘   │
│                                             │
│  ┌──────────────────────────────────────┐   │  ← Section "Danger zone"
│  │                                      │   │
│  │   trash.fill   Supprimer la liste    │   │    Color.qlDanger pour texte et icône
│  │   Font.qlBody  Color.qlDanger        │   │    Séparation visuelle claire
│  │                                      │   │
│  └──────────────────────────────────────┘   │
│                                             │
│ ████████████████████████████████████████████│
└─────────────────────────────────────────────┘
```

---

## Action : Renommer (inline — décision QO-6 validée)

Le renommage est **toujours inline**. La row "Renommer" se transforme en TextField in-place après tap. Pas d'alert système.

```
│  ┌──────────────────────────────────────┐   │
│  │  pencil  ┌────────────────────────┐  │   │
│  │          │  Tâches|               │  │   │  ← TextField inline
│  │          └────────────────────────┘  │   │    focus auto à l'ouverture
│  │          [Annuler]         [OK]       │   │    texte existant pré-sélectionné
│  └──────────────────────────────────────┘   │    Return ou tap [OK] pour valider
```

Comportement détaillé :
- Tap "Renommer" : la row se transforme en TextField avec le nom actuel pré-rempli et entièrement sélectionné
- Le clavier s'ouvre immédiatement (focus auto)
- Return ou tap [OK] : sauvegarde et revient à la row normale (fade)
- Tap [Annuler] ou Escape : annule et revient à la row normale sans modification
- La sheet passe en detent `.large` automatiquement si le clavier recouvrirait le champ

---

## Action : Supprimer (Confirmation)

Tap "Supprimer la liste" → Alert de confirmation (HIG : Destructive Actions) :

```
┌─────────────────────────────────────────────┐
│                                             │
│  ╔═════════════════════════════════════╗    │
│  ║                                     ║    │
│  ║  Supprimer "Tâches" ?               ║    │  ← Alert (system modal)
│  ║                                     ║    │    Font.qlHeadline (titre)
│  ║  Cela supprimera également les      ║    │
│  ║  12 items de cette liste.           ║    │    Message : Font.qlBody
│  ║  Cette action est irréversible.     ║    │    Color.qlSecondaryLabel
│  ║                                     ║    │
│  ╠═════════════════════════════════════╣    │
│  ║  Annuler                            ║    │  ← Bouton non-destructif (leading)
│  ╠═════════════════════════════════════╣    │    Font.qlBody.semibold qlAccent
│  ║  Supprimer                          ║    │  ← Bouton destructif
│  ╚═════════════════════════════════════╝    │    Font.qlBody.bold Color.qlDanger
│                                             │    .destructive role
└─────────────────────────────────────────────┘
```

Après suppression :
- Sheet dismiss + NavigationStack pop (retour HomeView)
- HomeView : ListCard animée sort (fade + scale 0.9)
- Pas d'UndoToast pour la suppression de liste (action trop lourde pour être annulée trivialement)
- Feedback : UINotificationFeedbackGenerator(.warning)

---

## Action : Partager (US-21)

Tap "Partager" → dismiss ListOptionsSheet → présentation ShareListSheet (autre sheet `.large`).

---

## Interactions

| Action | Geste | Feedback |
|--------|-------|----------|
| Ouvrir options | Tap ellipsis.circle | UIImpactFeedbackGenerator(.light) |
| Sélectionner tri | Tap rangée | UIImpactFeedbackGenerator(.light) + checkmark animé |
| Renommer | Tap "Renommer" | UIImpactFeedbackGenerator(.light) + focus inline |
| Supprimer | Tap "Supprimer" | UINotificationFeedbackGenerator(.warning) avant alert |
| Dismiss sheet | Swipe down | — |

---

## Adaptations iPad / macOS

iPad : le panneau est un popover ancré sur l'icône ellipsis.circle (pas une sheet). Largeur 320pt.

macOS : menu déroulant depuis l'icône, ou menu contextuel (clic droit sur la liste dans la sidebar). Les options de tri sont dans le menu "Affichage" de la Menu Bar. La suppression ouvre une alert native macOS.
