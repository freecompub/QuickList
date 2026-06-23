# QuickList — Stratégie cross-platform

> Version 1.0 — Décision validée le 2026-06-23
> Auteur : UI Designer Agent

---

## Principe général

Un seul module SPM `QuickListDesignSystem`, une seule identité visuelle (tokens partagés), des conteneurs de navigation natifs distincts par plateforme. SwiftUI gère automatiquement les adaptations de densité via les size classes (`.compact` / `.regular`).

---

## Tableau de correspondance par plateforme

| Concept | iPhone | iPad | macOS |
|---------|--------|------|-------|
| Conteneur principal | `TabView` + `NavigationStack` | `NavigationSplitView` | `NavigationSplitView` |
| Accès "Toutes les listes" | Onglet 0 "Listes" | Sidebar (bas) | Sidebar (bas) |
| Accès "Mode Courses" | Onglet 1 "Courses" | Entrée sidebar (haut) | Entrée sidebar (haut) + `Cmd+Shift+C` |
| Accès "Réglages" | `gearshape.fill` dans NavigationBar | Idem + Préférences système | Menu QuickList > Préférences (`Cmd+,`) |
| Création de liste | FAB `plus.circle.fill` (flottant) | Bouton toolbar sidebar | Bouton toolbar sidebar + `Cmd+N` |
| Sheets modales | Présentées depuis le bas | Présentées en `.formSheet` (centrées) | Présentées en `NSPanel` ou sheet native |
| Scan ticket | `fullScreenCover` camera | `UIDocumentCameraViewController` | Absent (feature iOS/iPadOS uniquement) |

---

## 1. iPhone — TabBar + NavigationStack

HIG référence : "Tab Bars", "NavigationStack"

### Structure NavigationStack par onglet

**Onglet 0 — Listes**
```
TabView
  └─ NavigationStack
       ├─ HomeView (root)
       │    └─ ListDetailView (push on tap)
       │         └─ [Sheets modales au-dessus]
       └─ [CreateListSheet, ListOptionsSheet, etc.]
```

**Onglet 1 — Courses**
```
TabView
  └─ NavigationStack
       └─ ShoppingModeView (root de cet onglet)
            ├─ Sélecteur de liste si plusieurs listes Courses
            └─ Vue items par rayon
```

### Règles iPhone spécifiques
- La TabBar reste visible dans les deux onglets (jamais masquée)
- Les `fullScreenCover` (scan camera) masquent la TabBar temporairement — comportement système
- Les sheets `.medium` et `.large` n'affectent pas la TabBar
- En mode paysage : TabBar toujours en bas (pas de transformation en sidebar)
- Safe area bottom : l'AddItemBar est positionnée au-dessus de la TabBar (`Spacing.qlSafeAreaBottom` tient compte de la hauteur de la TabBar)

---

## 2. iPad — NavigationSplitView

HIG référence : "Split Views", "Sidebars"

### Structure

```
NavigationSplitView(columnVisibility: .all)
  ├─ sidebar
  │    ├─ [cart.fill] Courses        ← Entrée dédiée en tête
  │    ├─ Divider()
  │    ├─ ListCard (row) "Tâches"
  │    ├─ ListCard (row) "Idées"
  │    ├─ ListCard (row) "Projets"
  │    ├─ ListCard (row) "Favoris"
  │    ├─ ListCard (row) "Inbox" (si non vide)
  │    └─ [+ Nouvelle liste]
  └─ detail
       ├─ ShoppingModeView (si Courses sélectionné)
       ├─ ListDetailView (si liste sélectionnée)
       └─ EmptyState (si rien sélectionné)
```

### Règles iPad spécifiques
- En paysage : sidebar toujours visible (`.sidebar` style, largeur ~280pt)
- En portrait : sidebar rétractable (toolbar button pour toggle)
- Les sheets sont présentées en `.formSheet` (taille fixe, centrées), pas en plein écran
- `ReceiptScanView` utilise `UIDocumentCameraViewController` pour un meilleur résultat
- L'AddItemBar dans le detail pane est identique à iPhone (même composant, size class `.regular` → padding légèrement augmenté)
- Grille HomeView : 3 colonnes en paysage (`.regular` width), 2 colonnes en portrait (`.compact` width)

---

## 3. macOS — Window + Sidebar + Menu Bar

HIG référence : "Mac Idioms", "Sidebars", "Menus"

### Structure window

```
Window (NavigationSplitView macOS)
  ├─ sidebar (style .sidebar, largeur fixe ~240pt)
  │    ├─ [cart.fill] Courses        ← Entrée dédiée en tête
  │    ├─ Divider()
  │    ├─ Section "Mes listes"
  │    │    ├─ ListRow "Tâches" (sidebar style)
  │    │    ├─ ListRow "Idées"
  │    │    └─ ...
  │    ├─ Section "Partagées"
  │    │    └─ ListRow "Courses du samedi"
  │    └─ [+ Nouvelle liste]
  └─ detail
       ├─ ShoppingModeView (si Courses sélectionné)
       ├─ ListDetailView (si liste sélectionnée)
       └─ EmptyState (si rien sélectionné)
```

### Menu Bar macOS

```
QuickList | Fichier | Edition | Liste | Affichage | Aide

QuickList
  ├─ À propos de QuickList
  ├─ Préférences…        Cmd+,
  └─ Quitter QuickList   Cmd+Q

Fichier
  ├─ Nouvelle liste      Cmd+N
  ├─ Fermer              Cmd+W
  └─ Scanner un ticket   (absent — feature iOS/iPadOS uniquement)

Edition
  ├─ Annuler             Cmd+Z
  ├─ Rétablir            Cmd+Shift+Z
  ├─ Couper              Cmd+X
  ├─ Copier              Cmd+C
  └─ Coller              Cmd+V

Liste (contextuel, actif si une liste est sélectionnée)
  ├─ Nouvel item         Cmd+T
  ├─ Renommer…           (inline dans la sidebar)
  ├─ Mode Courses        Cmd+Shift+C
  ├─ Partager…           Cmd+Shift+S
  ├─ Trier par
  │    ├─ Ordre d'ajout
  │    ├─ Alphabétique
  │    └─ Statut
  └─ Supprimer…          Backspace (avec confirmation)

Affichage
  ├─ Afficher/Masquer la sidebar   Cmd+Ctrl+S
  └─ Items faits         (toggle visible/masqué — futur)
```

### Règles macOS spécifiques
- Les swipe actions iOS sont remplacées par menu contextuel (clic droit) et raccourcis clavier
- L'AddItemBar est intégrée dans le bas du detail pane (pas de barre flottante — la window n'a pas de safe area)
- `Cmd+T` focus sur le champ d'ajout
- La barre d'ajout est visuellement différente : fond `Color.qlSecondaryBackground` (pas de Material, moins pertinent sur macOS) avec une séparation `Divider` au-dessus
- Le bouton `[mic]` (dictée) est absent sur macOS (API Speech non disponible de la même façon)
- Le scan ticket est absent sur macOS
- La VoiceImportSheet est accessible via Edition > "Dicter des items" si l'API est disponible
- Haptique absent sur macOS — les feedbacks sont purement visuels (highlights, animations)

---

## 4. Size Classes et densité des composants

SwiftUI expose les size classes via `@Environment(\.horizontalSizeClass)` et `@Environment(\.verticalSizeClass)`.

| Composant | `.compact` (iPhone) | `.regular` (iPad/Mac) |
|-----------|--------------------|-----------------------|
| ListRow | hauteur 44pt, `Font.qlBody` | hauteur 36pt, `Font.qlBody` (compact variant) |
| ListCard | grille 2 colonnes | grille 3+ colonnes ou liste |
| AddItemBar | padding qlL | padding qlXL (plus d'espace horizontal) |
| SuggestionChips | scroll horizontal 1 rangée | grille 2 rangées si place suffisante |
| CategoryHeader | hauteur 32pt | hauteur 28pt |
| ShoppingModeView rows | hauteur 64pt | hauteur 56pt (plus de place, pouce moins nécessaire) |

---

## 5. Tokens partagés — garanties cross-platform

Tous les tokens de `QuickListDesignSystem` fonctionnent sur les trois plateformes :

- `Color.qlAccent` = `.accentColor` : adapté automatiquement (iOS/macOS)
- `Color.qlBackground` = `.systemBackground` : adapté automatiquement
- `Font.qlBody` = `.body` : Dynamic Type sur iOS, taille fixe équivalente sur macOS
- `Material.qlBarBackground` = `.ultraThinMaterial` : supporté sur iOS 15+ et macOS 12+
- SF Symbols : disponibles sur iOS 17+ et macOS 14+ (versions ciblées)

---

*Fin du document cross-platform.md*
*Version 1.0 — Décision cross-platform validée*
