# QuickList — Design System

> Version 0.2 — Décisions QO-1 à QO-7 intégrées le 2026-06-23
> Auteur : UI Designer Agent

Ce document définit l'ensemble des tokens, composants et règles visuelles du module SPM `QuickListDesignSystem`. Aucune couleur, typographie, espacement ni string ne doit être codé en dur dans le code applicatif — tout passe par ce système de tokens.

---

## 1. Principes directeurs

- **Vitesse avant tout** : l'interface ne doit jamais ralentir l'utilisateur. Les animations sont courtes, les états de chargement discrets.
- **Minimalisme Apple** : s'appuyer sur les primitives système (SF Symbols, Dynamic Type, materials) plutôt que de réinventer des composants.
- **Adaptation contextuelle** : l'app change de forme selon le contexte (mode courses en magasin = grands boutons, mode bureau = densité maximale).
- **Repli gracieux** : chaque feature IA a un état sans intelligence. Le design système doit prévoir explicitement ces deux états.
- **Accessibilité non négociable** : WCAG AA minimum, Dynamic Type jusqu'à accessibilityExtraExtraExtraLarge, VoiceOver sur chaque élément interactif.

---

## 2. Tokens de couleur

### 2.1 Philosophie

Les couleurs sémantiques sont définies en termes de rôle, pas de teinte. Elles s'appuient en priorité sur les couleurs système Apple (`Color.accentColor`, `Color.systemBackground`, etc.) pour garantir la cohérence avec le système et l'adaptation automatique au mode clair/sombre.

La couleur d'accent est **bleu système Apple** (`.accentColor` / `.tint`). Ce token délègue entièrement la valeur au système : il s'adapte automatiquement au mode clair/sombre, respecte les réglages d'accessibilité de l'utilisateur (« Augmenter le contraste ») et reste cohérent avec les autres apps iOS/macOS. Aucune valeur hexadécimale n'est définie pour `qlAccent` — c'est une décision de conception intentionnelle.

### 2.2 Palette sémantique

```
Token                       | Mode clair                      | Mode sombre
----------------------------|---------------------------------|----------------------------------
Color.qlAccent              | .accentColor (bleu système)     | .accentColor (bleu système)
Color.qlBackground          | .systemBackground               | .systemBackground
Color.qlSecondaryBackground | .secondarySystemBackground      | .secondarySystemBackground
Color.qlGroupedBackground   | .systemGroupedBackground        | .systemGroupedBackground
Color.qlSurface             | .secondarySystemGroupedBackground| .secondarySystemGroupedBackground
Color.qlSeparator           | .separator                      | .separator
Color.qlPrimaryLabel        | .label                          | .label
Color.qlSecondaryLabel      | .secondaryLabel                 | .secondaryLabel
Color.qlTertiaryLabel       | .tertiaryLabel                  | .tertiaryLabel
Color.qlPlaceholder         | .placeholderText                | .placeholderText
Color.qlSuccess             | #34C759 (green)                 | #30D158 (green accessible dark)
Color.qlWarning             | #FF9F0A (orange)                | #FFD60A (yellow)
Color.qlDanger              | #FF3B30 (red)                   | #FF453A (red dark)
Color.qlAIAccent            | #BF5AF2 (purple)                | #DA8FFF (purple light dark)
Color.qlSyncPending         | #FF9F0A (orange)                | #FFD60A (yellow)
Color.qlSyncSuccess         | Color.qlSuccess                 | Color.qlSuccess
Color.qlItemDone            | .tertiaryLabel                  | .tertiaryLabel
Color.qlCategoryHeader      | .secondaryLabel                 | .secondaryLabel
Color.qlOverlay             | .black.opacity(0.4)             | .black.opacity(0.6)
Color.qlToastBackground     | .systemGray6                    | .systemGray5
Color.qlSheetGrabber        | .systemGray4                    | .systemGray3
```

### 2.3 Couleurs des rayons (Mode Courses)

Chaque rayon a une teinte pastel légère pour les category headers. Ces teintes sont intentionnellement désaturées pour ne pas saturer visuellement l'écran en magasin.

```
Token                           | Mode clair          | Mode sombre
--------------------------------|---------------------|---------------------
Color.qlRayonFruitsLegumes      | #E8F5E9 (vert pâle) | #1B3A20
Color.qlRayonBoucherie          | #FCE4EC (rose pâle) | #3B1520
Color.qlRayonCremerie           | #FFF8E1 (crème)     | #3B3000
Color.qlRayonEpicerie           | #E3F2FD (bleu pâle) | #0D2A3B
Color.qlRayonSurgeles           | #E0F7FA (cyan pâle) | #003038
Color.qlRayonBoulangerie        | #FFF3E0 (ambre pâle)| #3B2000
Color.qlRayonBoissons           | #EDE7F6 (violet)    | #1A0A3B
Color.qlRayonHygiene            | #F3E5F5 (lilas)     | #2A1030
Color.qlRayonAutres             | .systemGray6        | .systemGray5
```

---

## 3. Typographie

Basée exclusivement sur SF Pro via le système Dynamic Type Apple. Aucune taille n'est hardcodée — on utilise les styles texte système.

### 3.1 Rôles typographiques

```
Token                    | Style SwiftUI        | Usage
-------------------------|----------------------|--------------------------------------------
Font.qlLargeTitle        | .largeTitle          | Titre page d'accueil (mode scrollé)
Font.qlTitle1            | .title               | Titre de liste (NavigationTitle)
Font.qlTitle2            | .title2              | Nom de section / rayon
Font.qlTitle3            | .title3              | Titre de sheet
Font.qlHeadline          | .headline            | Label item (mode Courses, gros)
Font.qlBody              | .body                | Label item standard, texte courant
Font.qlCallout           | .callout             | Sous-titre, metadata
Font.qlSubheadline       | .subheadline         | Count badge, indicateur sync
Font.qlFootnote          | .footnote            | Timestamp, note secondaire
Font.qlCaption1          | .caption             | Label catégorie header (compact)
Font.qlCaption2          | .caption2            | Legal, micro-metadata
Font.qlAddItemField      | .body                | Champ de saisie add item
Font.qlSuggestionChip    | .subheadline         | Chip de suggestion
Font.qlBadgeCount        | .caption.bold()      | Badge nombre d'items
```

### 3.2 Poids

- Titres de navigation et de liste : `.semibold`
- Labels d'items standard : `.regular`
- Labels d'items cochés : `.regular` + strikethrough
- Category headers : `.medium`
- Boutons d'action primaire : `.semibold`
- Labels de chip : `.medium`

### 3.3 Règles Dynamic Type

- Tout texte utilise les styles système → adaptation automatique.
- En accessibilityExtraExtraExtraLarge : les chips de suggestion passent en liste verticale plutôt qu'horizontale scrollable.
- Le mode Courses augmente la taille de base de `.headline` → `.title3` pour améliorer la lisibilité en magasin (via `ScaledMetric`).
- Les category headers restent en `.caption` même au-delà d'un certain seuil pour préserver la hiérarchie visuelle.

---

## 4. Iconographie (SF Symbols)

Tous les symboles sont des SF Symbols. Le rendu utilise `.symbolRenderingMode(.hierarchical)` par défaut, `.multicolor` pour les états colorés spéciaux.

```
Concept                    | SF Symbol                        | Variante / Note
---------------------------|----------------------------------|-------------------------------------------
Ajouter un item            | plus.circle.fill                 | .multicolor, couleur qlAccent
Supprimer                  | trash.fill                       | .hierarchical, couleur qlDanger
Cocher (fait)              | checkmark.circle.fill            | .multicolor, couleur qlSuccess
Décocher (pas fait)        | circle                           | .hierarchical, couleur qlSecondaryLabel
Annuler / Undo             | arrow.uturn.backward.circle.fill | .hierarchical
Trier                      | line.3.horizontal.decrease.circle| .hierarchical
Trier alphabétique         | textformat.abc                   | .hierarchical
Trier par date             | calendar.badge.clock             | .hierarchical
Trier par statut           | checkmark.circle.badge.clock     | .hierarchical
Renommer                   | pencil                           | .hierarchical
Partager                   | person.2.badge.plus              | .hierarchical
Partage actif (collab)     | person.2.fill                    | .multicolor
Courses (type de liste)    | cart.fill                        | .multicolor
Tâches (type de liste)     | checklist                        | .hierarchical
Idées (type de liste)      | lightbulb.fill                   | .multicolor
Projets (type de liste)    | folder.fill                      | .hierarchical
Favoris (type de liste)    | star.fill                        | .multicolor, couleur qlWarning
Intelligence IA            | sparkles                         | .multicolor, couleur qlAIAccent
IA en cours                | sparkles (animé, pulse)          | .multicolor
IA indisponible            | sparkles.slash                   | .hierarchical, couleur qlSecondaryLabel
Sync en cours              | arrow.triangle.2.circlepath      | animé rotation, couleur qlSyncPending
Sync OK                    | icloud.fill                      | .hierarchical, couleur qlSyncSuccess
Sync erreur                | icloud.slash.fill                | .hierarchical, couleur qlDanger
Dictée vocale              | mic.fill                         | .multicolor
Scan de ticket             | doc.viewfinder                   | .hierarchical
Inbox / Capture rapide     | tray.fill                        | .hierarchical
Réglages                   | gearshape.fill                   | .hierarchical
Créer une liste            | plus.square.fill.on.square.fill  | .hierarchical
Mode Courses (dédié)       | cart.badge.checkmark             | .multicolor
Options de liste           | ellipsis.circle                  | .hierarchical
Rayon Fruits & Légumes     | leaf.fill                        | .multicolor
Rayon Boucherie            | fork.knife                       | .hierarchical
Rayon Crèmerie             | drop.fill                        | .multicolor
Rayon Épicerie             | archivebox.fill                  | .hierarchical
Rayon Surgelés             | snowflake                        | .multicolor
Rayon Boulangerie          | birthday.cake.fill               | .multicolor
Rayon Boissons             | cup.and.saucer.fill              | .hierarchical
Rayon Hygiène              | shower.fill                      | .hierarchical
Rayon Autres               | square.grid.2x2.fill             | .hierarchical
Widget interactif          | widget.small                     | système
```

---

## 5. Espacements

Échelle basée sur une unité de base de 4pt.

```
Token                    | Valeur | Usage typique
-------------------------|--------|----------------------------------------------
Spacing.qlXXS            | 2pt    | Micro-espacement (badge interne)
Spacing.qlXS             | 4pt    | Gap entre icône et label dans un chip
Spacing.qlS              | 8pt    | Padding interne léger, gap entre items
Spacing.qlM              | 12pt   | Padding horizontal d'une row compacte
Spacing.qlL              | 16pt   | Padding standard (section, card)
Spacing.qlXL             | 20pt   | Padding vertical de screen
Spacing.qlXXL            | 24pt   | Espacement entre sections
Spacing.qlXXXL           | 32pt   | Espacement entre blocs majeurs
Spacing.qlSection        | 40pt   | Espace au-dessus d'un header de section
Spacing.qlSafeAreaBottom | 88pt   | Espace minimal pour AddItemBar (barre + safe area)
```

---

## 6. Rayons (corner radius)

```
Token                | Valeur | Usage
---------------------|--------|----------------------------------------------
Radius.qlSmall       | 6pt    | Petites chips, badges
Radius.qlMedium      | 12pt   | Cards, cells avec fond
Radius.qlLarge       | 16pt   | Sheets présentées modalement, cards larges
Radius.qlXLarge      | 22pt   | Modales importantes (scan, vocal)
Radius.qlPill        | 9999pt | Boutons pill, chips de suggestion
```

---

## 7. Elevations et ombres

QuickList utilise les matériaux system Apple (`Material`) plutôt que des ombres personnalisées, pour garantir la cohérence cross-platform. Les ombres custom sont réservées aux toasts et overlays.

```
Token                   | Valeur                                         | Usage
------------------------|------------------------------------------------|-----------------------------
Shadow.qlToast          | radius: 16, y: 4, opacity: 0.15               | UndoToast
Shadow.qlSheet          | Natif UISheetPresentationController            | Toutes les sheets
Shadow.qlCard           | radius: 8, y: 2, opacity: 0.08                | ListCard en mode grille
Shadow.qlAddBar         | radius: 12, y: -4, opacity: 0.10              | Barre d'ajout (flottante)
Material.qlBarBackground| .ultraThinMaterial                             | AddItemBar background
Material.qlToastBG      | .regularMaterial                               | UndoToast background
```

---

## 8. Composants

### 8.1 ListRow

Représente un item de liste (coché ou non). Composant le plus fréquent de l'app.

**Anatomie**

```
┌─────────────────────────────────────────────────────┐
│  [checkbox 24pt]  [label .body]        [AI badge?]  │
│                   [sous-titre callout] [sync icon?] │
└─────────────────────────────────────────────────────┘
```

**Tokens utilisés**
- Background : transparent (fond de liste)
- Label : `Font.qlBody`, `Color.qlPrimaryLabel`
- Label fait : `Font.qlBody` + strikethrough, `Color.qlItemDone`
- Sous-titre : `Font.qlCallout`, `Color.qlSecondaryLabel`
- Hauteur minimale : 44pt (cible HIG)

**Etats**
- `default` : cercle vide `circle`, label normal
- `done` : `checkmark.circle.fill` vert, label barré et grisé, légère réduction d'opacité (0.6)
- `pressed` : scale 0.97, légère atténuation du fond
- `loading` (classification IA en cours) : AIBadge visible avec shimmer
- `classified` (IA terminée) : AIBadge disparaît avec fade out
- `error` : icône `exclamationmark.triangle.fill` en qlWarning, discret

**Variantes**
- `compact` (densité iPad/macOS) : hauteur 36pt, taille police réduite d'un rang
- `regular` (défaut iPhone) : hauteur 44pt minimum
- `shoppingMode` : hauteur 64pt, `Font.qlHeadline`, targets larges (US-08)

**Swipe actions (HIG : Swipe Actions)**
- Leading (gauche) : none
- Trailing (droite) : "Supprimer" `trash.fill`, `Color.qlDanger`

**Haptique**
- Cocher un item : `UIImpactFeedbackGenerator(.medium)`
- Décocher : `UIImpactFeedbackGenerator(.light)`
- Swipe suppression confirmé : `UINotificationFeedbackGenerator(.warning)`

**VoiceOver**
- Label : "[titre de l'item], [fait/pas fait]"
- Hint : "Toucher deux fois pour [cocher/décocher]"
- Swipe action : "Supprimer [titre]"

---

### 8.2 AddItemBar

Barre de saisie permanente en bas de l'écran de liste. Toujours visible, focus automatique.

**Anatomie** (bouton [+] externe — décision QO-2 validée)

```
┌────────────────────────────────────────────────────────────┐
│  Material.qlBarBackground + Shadow.qlAddBar                │
│                                                            │
│  ┌──────────────────────────────────────────┐  [+]        │
│  │  String.qlAddItemPlaceholder   [mic]     │  external   │
│  └──────────────────────────────────────────┘  44x44pt    │
│                                                            │
│  [chip] [chip] [chip]  ← SuggestionRow (optionnel)        │
│                            safe area bottom                │
└────────────────────────────────────────────────────────────┘
```

Le bouton [+] est positionné à droite du TextField, hors du champ de saisie, dans la même barre horizontale. Il est visuellement distinct (symbole `plus.circle.fill`, 32pt, `Color.qlAccent`, cible 44x44pt). Cette position évite toute ambiguïté avec les boutons d'accessoire clavier système.

**Tokens**
- Background : `Material.qlBarBackground`
- Shadow : `Shadow.qlAddBar`
- TextField placeholder : `Font.qlAddItemField`, `Color.qlPlaceholder`
- Bouton + : `plus.circle.fill`, 32pt symbol, cible 44x44pt — `Color.qlAccent` si champ non vide, `Color.qlTertiaryLabel` si champ vide (désactivé visuellement mais tappable pour focus)
- Bouton mic : `mic.fill`, `Color.qlSecondaryLabel`, 44pt — visible seulement si Apple Intelligence disponible (US-19)

**Etats**
- `idle` : champ vide, placeholder visible, [+] en `qlTertiaryLabel`
- `typing` : [+] passe en `qlAccent` (spring 0.2s) à la première lettre
- `submitting` : bref shimmer de 0.1s (imperceptible)
- `voiceActive` : champ remplacé par waveform animée, [+] et [mic] masqués

**Comportement**
- Focus conservé après chaque soumission (US-01)
- Soumission par Return ou tap sur [+]
- Tap [+] avec champ vide : action no-op (focus reste sur le champ)

**VoiceOver**
- TextField : "Ajouter un item"
- Bouton + : "Ajouter"
- Bouton mic : "Dicter des items"

---

### 8.3 CategoryHeader

En-tête de section pour le tri par rayon en mode Courses.

**Anatomie**

```
┌──────────────────────────────────────────────────────────┐
│  [icon rayon 18pt]  NOM DU RAYON  ··  [N articles]       │
│  Color.qlRayonXxx (bande de couleur 4pt hauteur)         │
└──────────────────────────────────────────────────────────┘
```

**Tokens**
- Background : `Color.qlRayonXxx` (selon rayon)
- Texte rayon : `Font.qlCaption1.uppercased().bold()`, `Color.qlCategoryHeader`
- Texte count : `Font.qlCaption2`, `Color.qlTertiaryLabel`
- Hauteur : 32pt
- Padding horizontal : `Spacing.qlL`

**VoiceOver**
- Label : "Section [nom du rayon], [N] articles"

---

### 8.4 ListCard

Card représentant une liste sur l'écran d'accueil.

**Anatomie**

```
┌──────────────────────────────────────┐
│  [icon liste 28pt]   [badge count]   │
│                                      │
│  Nom de la liste                     │
│  N items · [sync icon]               │
└──────────────────────────────────────┘
```

**Tokens**
- Background : `Color.qlSurface`
- Corner : `Radius.qlMedium`
- Shadow : `Shadow.qlCard`
- Icon : SF Symbol du type de liste, 28pt
- Nom : `Font.qlHeadline`, `Color.qlPrimaryLabel`
- Sous-titre : `Font.qlFootnote`, `Color.qlSecondaryLabel`
- Badge count : `Font.qlBadgeCount`, background `Color.qlAccent`, `Color.white`
- Taille minimale : 160 x 100pt (iPhone, grille 2 colonnes)

**Etats**
- `default`
- `pressed` : scale 0.96, réduction shadow
- `shared` : icône `person.2.fill` dans le coin supérieur droit
- `syncing` : SyncIndicator visible

**Variantes**
- `grid` (défaut iPhone) : 2 colonnes
- `list` (iPad sidebar/macOS) : rangée full-width avec plus d'infos

**Context Menu (long press)**
- "Renommer" : `pencil`
- "Partager" : `person.2.badge.plus`
- "Mode Courses" (si type groceries) : `cart.badge.checkmark`
- "Supprimer" : `trash.fill`, destructive

**VoiceOver**
- Label : "[Nom de liste], [N] items, [partagée/non partagée]"

---

### 8.5 AIBadge

Indicateur discret qu'une classification IA est en cours ou terminée.

**Anatomie**
- `sparkles` animé (pulse) : classification en cours
- `sparkles` statique avec fadeout : classification terminée
- Ne s'affiche jamais si Apple Intelligence est indisponible (US-19)

**Tokens**
- Couleur : `Color.qlAIAccent`
- Taille icône : 12pt
- Padding : `Spacing.qlXS` (4pt)
- Animation : pulse 1.0s repeat, Reduce Motion → aucune animation (icône statique en cours, disparaît en terminé)

**VoiceOver**
- En cours : "Classification en cours"
- Absent (terminé) : rien (silencieux)

---

### 8.6 SyncIndicator

Indicateur de synchronisation iCloud, discret et non-bloquant.

**Variantes**
- `syncing` : `arrow.triangle.2.circlepath` en rotation 360° / 1.5s, `Color.qlSyncPending`
- `synced` : `icloud.fill`, `Color.qlSyncSuccess`, fade-in puis disparaît après 2s
- `error` : `icloud.slash.fill`, `Color.qlDanger`, persistent avec tap pour détail
- `offline` : caché (on ne montre pas l'état offline en permanence)

**Position** : dans le NavigationBar trailing (droit), ou inline dans ListCard.

**VoiceOver**
- `syncing` : "Synchronisation en cours"
- `synced` : "Synchronisé"
- `error` : "Erreur de synchronisation. Toucher pour les détails."

---

### 8.7 UndoToast

Toast éphémère proposant d'annuler la dernière action destructive.

**Anatomie**

```
┌───────────────────────────────────────────────────┐
│  Material.qlToastBG + Shadow.qlToast              │
│  "Item supprimé"               [Annuler]          │
│  Font.qlCallout                Font.qlCallout.bold│
└───────────────────────────────────────────────────┘
```

**Comportement**
- Apparaît 0.2s après la suppression (spring animation)
- Disparaît après 4 secondes (avec fade)
- Positionné au-dessus de l'AddItemBar
- Tap "Annuler" : réinsère l'item, toast disparaît immédiatement
- Geste swipe down : dismiss manuel

**Tokens**
- Background : `Material.qlToastBG`
- Corner : `Radius.qlMedium`
- Shadow : `Shadow.qlToast`
- Texte action : `Font.qlCallout`, `Color.qlPrimaryLabel`
- Bouton : `Font.qlCallout.bold()`, `Color.qlAccent`

**Haptique**
- Apparition : aucun (ne pas interrompre le flux)
- Tap Annuler : `UIImpactFeedbackGenerator(.medium)`

**VoiceOver**
- Label toast : "[titre] supprimé"
- Bouton : "Annuler la suppression"

---

### 8.8 SuggestionChip

Chip proposant un item fréquent ou contextuel sous l'AddItemBar.

**Anatomie**

```
╔════════════════╗
║  [icon]  texte ║   ← background Color.qlSurface, border qlSeparator
╚════════════════╝
```

**Tokens**
- Background : `Color.qlSurface`
- Border : 1pt, `Color.qlSeparator`
- Corner : `Radius.qlPill`
- Texte : `Font.qlSuggestionChip`, `Color.qlAccent`
- Hauteur : 32pt (taille mini, scrollable horizontalement)
- Padding : `Spacing.qlS` vertical, `Spacing.qlM` horizontal

**Etats**
- `default`
- `pressed` : scale 0.94

**VoiceOver**
- Label : "Suggestion : [texte]"
- Hint : "Toucher deux fois pour ajouter"

---

### 8.9 VoiceImportSheet

Sheet modale de dictée vocale (US-16).

**Présentation** : `.sheet` medium detent (50% de l'écran), non-dismissable pendant l'enregistrement.

**Etats**
- `idle` : bouton micro centré, instruction textuelle
- `recording` : waveform animée, texte transcrit en direct, bouton stop
- `processing` : shimmer sur les items proposés
- `review` : liste des items parsés, chacun éditable
- `error` : message d'erreur + retry

---

### 8.10 TabBar iPhone (QO-4 validée)

La navigation principale sur iPhone utilise une `TabBar` à deux onglets (HIG : Tab Bars). Ce changement structurant remplace la décision initiale "pas de TabBar".

**Structure**

```
┌───────────────────────────────────────────────┐
│  [checklist]               [cart.fill]        │
│   Listes                    Courses           │
└───────────────────────────────────────────────┘
```

**Onglets**

| Index | Label | SF Symbol | Contenu |
|-------|-------|-----------|---------|
| 0 | Listes | `checklist` | HomeView (toutes les listes) → NavigationStack → ListDetail |
| 1 | Courses | `cart.fill` | ShoppingModeView (dernière liste Courses active, ou sélecteur si plusieurs) |

**Tokens**
- Sélectionné : `Color.qlAccent` (icône + label)
- Non sélectionné : `Color.qlTertiaryLabel`
- Background : `Material.ultraThinMaterial` (TabBar système iOS)
- Badge (onglet Courses) : badge rouge si des articles sont dans une liste Courses non vide — `Color.qlDanger`

**Règles**
- L'onglet Courses reste actif même si aucune liste Courses n'existe encore (état vide dédié)
- Tap sur l'onglet actif : scroll to top (comportement HIG standard)
- L'onglet Réglages n'est pas dans la TabBar — accès via `gearshape.fill` dans la NavigationBar de HomeView (question ouverte QO-8 : voir README)

**Comportement cross-platform**
- iPhone uniquement : TabBar visible en bas
- iPad : TabBar absente — la sidebar NavigationSplitView intègre "Courses" comme entrée en tête (au-dessus de la liste des listes), avec l'icône `cart.fill`
- macOS : TabBar absente — entrée "Courses" en tête de la sidebar, avec l'icône `cart.fill` et séparateur visuel

**VoiceOver**
- Onglet Listes : accessibilityLabel "Listes", accessibilityHint "Affiche toutes vos listes"
- Onglet Courses : accessibilityLabel "Courses", accessibilityHint "Ouvre le mode Courses"

---

### 8.12 ReceiptScanSheet

Sheet de scan OCR (US-17).

**Présentation** : `.fullScreenCover` (l'app camera nécessite le plein écran).

**Etats**
- `camera` : viewfinder avec guide de cadrage
- `processing` : overlay avec shimmer + "Analyse en cours..." (Foundation Models)
- `review` : liste scrollable des items extraits, chacun avec checkbox de sélection
- `error` : message + retry ou annuler

---

## 9. Accessibilité

### 9.1 Contraste

Tous les textes respectent WCAG 2.1 AA :
- Texte normal (< 18pt) : ratio ≥ 4.5:1
- Texte large (≥ 18pt ou 14pt bold) : ratio ≥ 3:1
- Les tokens système Apple (`Color.label`, `Color.secondaryLabel`) sont garantis conformes nativement.
- `Color.qlAIAccent` (#BF5AF2 sur fond blanc) doit être vérifié au niveau AA — à valider.

### 9.2 Cibles tactiles

- Minimum 44 x 44pt pour tout élément interactif (HIG : Targets).
- En mode Courses : minimum 64pt de hauteur de row (US-08).
- AddItemBar : hauteur minimale 56pt (champ) + 16pt padding.

### 9.3 VoiceOver

- Chaque composant a un `accessibilityLabel` et `accessibilityHint` définis (voir specs composants ci-dessus).
- L'ordre de focus VoiceOver suit la logique de lecture : header → items → AddItemBar.
- Les gestes swipe doivent être accessibles via les `accessibilityActions` de swipe.

### 9.4 Reduce Motion

- Toutes les animations peuvent être désactivées via `@Environment(\.accessibilityReduceMotion)`.
- Règle : si reduce motion = true, remplacer les animations de translation/scale par de simples fades.
- L'AIBadge n'est jamais animé si reduce motion est activé.
- Le SyncIndicator rotation est remplacé par un clignotement lent (0.5s fade in/out).

### 9.5 Dynamic Type

- Aucune taille de police n'est fixe.
- Les layouts horizontaux (chips) passent en layout vertical au-delà de `accessibilityMedium`.
- Les CategoryHeaders restent lisibles même à taille maximale (troncature avec ellipsis).

---

## 10. Motion Design

### 10.1 Principes

- Les animations doivent renforcer la compréhension spatiale, jamais la retarder.
- Durée maximale pour une interaction courante : 300ms.
- Toutes les animations utilisent des springs physiques (`spring(response:dampingFraction:)`) plutôt que des courbes temporelles rigides.

### 10.2 Paramètres standards

```
Token                  | Type        | Paramètres                         | Usage
-----------------------|-------------|-------------------------------------|----------------------------------
Motion.qlQuick         | spring      | response: 0.2, damping: 0.8        | Apparition de chip, badge
Motion.qlStandard      | spring      | response: 0.3, damping: 0.75       | Navigation, slide de row
Motion.qlExpressive    | spring      | response: 0.4, damping: 0.65       | Entrée de sheet, mode courses
Motion.qlFade          | easeInOut   | duration: 0.2                      | Toast, AIBadge, SyncIndicator
Motion.qlItemInsert    | spring      | response: 0.35, damping: 0.8       | Apparition d'un item dans la liste
Motion.qlItemDelete    | easeIn      | duration: 0.25                     | Suppression d'item (shrink + fade)
Motion.qlCheckmark     | spring      | response: 0.25, damping: 0.6       | Animation de checkmark (rebond)
```

### 10.3 Reduce Motion

- `Motion.qlQuick` → `.opacity` uniquement (0.2s)
- `Motion.qlStandard` → `.opacity` uniquement (0.2s)
- `Motion.qlExpressive` → `.opacity` uniquement (0.3s)
- Rotations (SyncIndicator) → fade in/out
- Scale → supprimé

---

## 11. Module SPM recommandé

Le design system doit être extrait dans un module Swift Package Manager séparé :

```
QuickListDesignSystem/
├── Sources/
│   └── QuickListDesignSystem/
│       ├── Colors/
│       │   ├── Color+Semantic.swift
│       │   └── Color+Rayons.swift
│       ├── Typography/
│       │   └── Font+QL.swift
│       ├── Spacing/
│       │   └── Spacing+QL.swift
│       ├── Symbols/
│       │   └── Symbol+QL.swift      (enum de constantes SF Symbols)
│       ├── Motion/
│       │   └── Animation+QL.swift
│       ├── Components/
│       │   ├── ListRow.swift
│       │   ├── AddItemBar.swift
│       │   ├── CategoryHeader.swift
│       │   ├── ListCard.swift
│       │   ├── AIBadge.swift
│       │   ├── SyncIndicator.swift
│       │   ├── UndoToast.swift
│       │   └── SuggestionChip.swift
│       └── QuickListDesignSystem.swift  (exports publics)
└── Package.swift
```

---

## 12. Strings localisables

Tous les strings affichés sont des clés localisables. Convention : préfixe `ql.` + chemin sémantique.

```
Clé                                | Valeur FR par défaut
-----------------------------------|-------------------------------------------
ql.addItem.placeholder             | "Ajouter un item…"
ql.undoToast.deleted               | "[titre] supprimé"
ql.undoToast.undo                  | "Annuler"
ql.list.itemCount                  | "%d item" / "%d items"
ql.list.empty.title                | "Liste vide"
ql.list.empty.subtitle             | "Commencez à taper pour ajouter votre premier item."
ql.home.empty.title                | "Aucune liste"
ql.home.empty.subtitle             | "Créez votre première liste en appuyant sur +."
ql.ai.classifying                  | "Classification…"
ql.ai.unavailable                  | "Apple Intelligence non disponible"
ql.sync.syncing                    | "Synchronisation…"
ql.sync.synced                     | "Synchronisé"
ql.sync.error                      | "Erreur de synchronisation"
ql.shopping.section.others         | "Autres"
ql.voice.instruction               | "Dites vos items à voix haute."
ql.voice.processing                | "Analyse en cours…"
ql.receipt.processing              | "Extraction des produits…"
ql.inbox.routing.title             | "Dans quelle liste ?"
ql.share.invite                    | "Inviter à cette liste"
ql.create.list.title               | "Nouvelle liste"
ql.create.list.namePlaceholder     | "Nom de la liste"
ql.delete.list.confirm             | "Supprimer cette liste et tous ses items ?"
ql.delete.list.action              | "Supprimer"
ql.sort.dateAdded                  | "Ordre d'ajout"
ql.sort.alphabetical               | "Alphabétique"
ql.sort.status                     | "Statut"
```

---

---

## 13. Stratégie cross-platform (décision validée le 2026-06-23)

Design commun, adaptations natives par plateforme. Voir `docs/design/cross-platform.md` pour la spécification complète.

Principe : un seul module SPM `QuickListDesignSystem`, une seule identité visuelle (tokens partagés), des conteneurs de navigation natifs distincts par plateforme.

| Plateforme | Navigation | Accès Courses |
|------------|-----------|---------------|
| iPhone | `NavigationStack` + `TabBar` (2 onglets) | Onglet dédié "Courses" |
| iPad | `NavigationSplitView` (sidebar + detail) | Entrée "Courses" en tête de sidebar |
| macOS | Window + sidebar + Menu Bar | Entrée "Courses" en tête de sidebar + `Cmd+Shift+C` |

Les size classes SwiftUI (`.compact` / `.regular`) pilotent automatiquement la densité des composants.

---

*Fin du document design-system.md*
*Version 0.2 — Décisions QO-1 à QO-7 intégrées*
