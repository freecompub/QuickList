# QuickList — User Flow & Navigation

> Version 0.2 — Décisions QO-1 à QO-7 intégrées le 2026-06-23
> Auteur : UI Designer Agent

---

## 1. Architecture de navigation par plateforme

### 1.1 iPhone (TabBar + NavigationStack)

HIG référence : "Navigation — Tab Bars, NavigationStack"

Décision QO-4 validée : la navigation principale utilise une `TabBar` à deux onglets. L'idée initiale "pas de TabBar" est annulée.

```
App Launch
    │
    ▼
┌─────────────────────────────────────────────────┐
│  TabView (TabBar système iOS)                   │
│                                                 │
│  ┌──────────────────┐  ┌──────────────────┐    │
│  │  Onglet 0        │  │  Onglet 1        │    │
│  │  LISTES          │  │  COURSES         │    │
│  │  (checklist)     │  │  (cart.fill)     │    │
│  └────────┬─────────┘  └────────┬─────────┘    │
│           │                     │              │
│    NavigationStack        ShoppingModeView     │
│           │               (dernière liste      │
│    HomeView (root)         Courses active)     │
│           │                                    │
│    ListDetailView (push)                       │
│                                                │
│  [checklist  Listes]  [cart.fill  Courses]     │  ← TabBar
└─────────────────────────────────────────────────┘
```

Modales (présentées par-dessus la TabView depuis n'importe quel onglet) :
- `CreateListSheet` : `.sheet` (detent .medium puis .large)
- `ListOptionsSheet` : `.sheet` (detent .medium)
- `VoiceImportSheet` : `.sheet` (detent .medium)
- `ReceiptScanView` : `.fullScreenCover`
- `InboxRoutingSheet` : `.sheet` (detent .medium)
- `ShareListSheet` : `.sheet` (detent .large)

Règles TabBar :
- Tap sur l'onglet actif → scroll to top (comportement HIG)
- Badge rouge sur l'onglet Courses si une liste Courses est non vide
- Les Réglages restent accessibles via `gearshape.fill` dans la NavigationBar de HomeView (pas de 3e onglet — voir QO-8)

### 1.2 iPad (NavigationSplitView)

HIG référence : "Split Views — NavigationSplitView"

Pas de TabBar sur iPad. La sidebar intègre l'accès "Courses" en tête.

```
┌──────────────────┬──────────────────────────────────────┐
│  SIDEBAR         │  CONTENT AREA                        │
│                  │                                      │
│  ┌────────────┐  │  ┌──────────────────────────────┐   │
│  │ cart.fill  │  │  │  ShoppingModeView            │   │  ← Courses sélectionnées
│  │ COURSES    │◄─┤  │  (liste Courses active)      │   │
│  └────────────┘  │  └──────────────────────────────┘   │
│  ─────────────   │                                      │
│  ┌────────────┐  │  ┌──────────────────────────────┐   │
│  │ ListCard   │  │  │  ListDetailView (sélectée)   │   │
│  │ ListCard   │◄─┤  │  (items + AddItemBar)         │   │
│  │ ListCard   │  │  └──────────────────────────────┘   │
│  │  ...       │  │                                      │
│  └────────────┘  │                                      │
│                  │                                      │
│  [+ Créer]       │                                      │
└──────────────────┴──────────────────────────────────────┘
```

- L'entrée "Courses" en tête de sidebar avec `cart.fill` est séparée de la liste par un `Divider`
- La sidebar est toujours visible en paysage (style `.sidebar`)
- En portrait iPad : sidebar rétractable (overlay style)
- Le detail pane affiche un empty state si aucune liste sélectionnée
- Les sheets sont présentées en contexte du panneau actif (pas plein écran)

### 1.3 macOS (Window + Sidebar + Menu Bar)

HIG référence : "Mac Idioms — Navigation"

```
┌─────────────────────────────────────────────────────────────┐
│  Menu Bar : Fichier | Edition | Liste | Affichage | Aide    │
├─────────────────┬───────────────────────────────────────────┤
│  SIDEBAR        │  CONTENT                                  │
│                 │                                           │
│  LISTES         │  ┌───────────────────────────────────┐   │
│  ├ Courses      │  │  Items de la liste sélectionnée   │   │
│  ├ Tâches       │  │                                   │   │
│  ├ Idées        │  │  [AddItemBar en bas]              │   │
│  └ + Nouvelle   │  └───────────────────────────────────┘   │
│                 │                                           │
│  PARTAGES       │                                           │
│  └ Ma liste     │                                           │
└─────────────────┴───────────────────────────────────────────┘
```

Raccourcis clavier macOS (Menu Bar) :
- `Cmd+N` : Nouvelle liste
- `Cmd+T` : Nouvel item (focus AddItemBar)
- `Cmd+Delete` : Supprimer item sélectionné
- `Cmd+Z` : Annuler dernière action
- `Cmd+Shift+S` : Partager la liste courante
- `Cmd+Shift+C` : Activer mode Courses (raccourci mis à jour depuis `Cmd+Option+C`)

---

## 2. Diagramme complet des écrans et transitions

```
                    ┌──────────────────┐
                    │   APP LAUNCH     │
                    └────────┬─────────┘
                             │
                             ▼
          ╔══════════════════════════════════════════╗
          ║  TAB BAR — iPhone                        ║
          ║  [checklist Listes]  [cart.fill Courses] ║
          ╚═══════╤══════════════════════╤═══════════╝
                  │                      │
                  ▼                      ▼
    ╔═════════════════════╗  ╔═══════════════════════════╗
    ║ HOME — Toutes       ║  ║ SHOPPING MODE VIEW        ║  [US-08]
    ║ listes  [US-04]     ║  ║ (liste Courses active     ║
    ╚══════╤══════════════╝  ║  ou sélecteur si vide)    ║
           │                 ╚═══════════════════════════╝
     ┌─────┼──────────────────────────┐
     │     │                          │
     │tap  │ tap [+] créer    long press ListCard
     ▼     ▼                          ▼
╔═════════════╗ ╔════════════════╗ ╔═════════════════════╗
║ LIST DETAIL ║ ║ CREATE LIST    ║ ║ LIST OPTIONS SHEET  ║
║ (items)     ║ ║ SHEET [US-03]  ║ ║ [US-05/06/21]       ║
╚══════╤══════╝ ╚════════════════╝ ╚═════════════════════╝
       │
       ├─── swipe item ──────────────────► Confirm Delete
       │                                    │
       │                                    └──► UndoToast [US-02]
       │
       ├─── tap [mic] ──────────────────►  VOICE IMPORT SHEET [US-16]
       │
       ├─── tap [scan] ─────────────────►  RECEIPT SCAN [US-17]
       │
       ├─── IA classifie en BG ─────────►  AIBadge visible → disparaît [US-15]
       │
       └─── [type groceries, ajout item] ► CategoryHeader groupé [US-07]


VOICE IMPORT SHEET [US-16]
       │
       ├── idle → tap mic → recording → stop → processing
       │
       └── review (items parsés) → [Ajouter tout] → list detail [US-18]
                  │
                  └── item ambigu → INBOX ROUTING [US-18]


RECEIPT SCAN [US-17]
       │
       ├── camera → snap → processing (Foundation Models)
       │
       └── review (items extraits) → sélection → [Ajouter] → list detail


INBOX ROUTING [US-18]
       │
       ├── confiance faible → sheet "Dans quelle liste ?"
       │
       └── utilisateur choisit → item routé → confirmation
```

---

## 3. Flows critiques détaillés

### Flow A — "Ajouter un item en rafale"

Couvre : US-01, US-15, US-20

```
ETAPE 1 — Ouverture de la liste
  Ecran : ListDetailView
  Etat : AddItemBar focus automatique au premier lancement (ou via tap)
  Transition : NavigationStack push (slide horizontal)
  Feedback : aucun (immédiat)

ETAPE 2 — Saisie
  Action : l'utilisateur tape "lait"
  Ecran : AddItemBar avec texte "lait"
  Suggestions : SuggestionChips apparaissent sous le champ (Motion.qlQuick)
    - Chip "Lait entier", "Lait demi-écrémé" (si historique existant)
  Feedback : aucun haptique pendant la saisie

ETAPE 3 — Validation (Return ou tap +)
  Action : Return
  Ecran : item "lait" apparaît en haut de liste (ou en section si courses)
    - Animation : Motion.qlItemInsert (slide depuis bas de section)
    - AIBadge visible sur l'item (si Apple Intelligence dispo)
  Champ : se vide immédiatement, garde le focus
  Feedback haptique : UIImpactFeedbackGenerator(.light) à l'apparition de l'item

ETAPE 4 — Classification IA (en arrière-plan)
  Ecran : AIBadge pulse sur l'item "lait"
  Durée : variable selon modèle, typiquement < 1s
  Résultat : item déplacé dans section "Crèmerie", AIBadge disparaît (fade)
  Feedback haptique : aucun (action background, non-intrusive)

ETAPE 5 — Item suivant
  Action : l'utilisateur tape "pâtes"
  Même cycle que étapes 2-4
  Résultat : après 3-4 items, les sections commencent à se former
```

---

### Flow B — "Passage en mode Courses avec tri rayon"

Couvre : US-07, US-08, US-09

```
ETAPE 1 — Accès via TabBar (décision QO-4 validée)
  Action : tap sur l'onglet "Courses" (cart.fill) dans la TabBar
  Transition : switch d'onglet natif TabView (cross-fade système)
  Feedback haptique : UIImpactFeedbackGenerator(.light) (standard TabBar)
  Etat : ShoppingModeView de la dernière liste Courses active

  Alternative : si aucune liste Courses n'existe, empty state dédié
  avec CTA "Créer une liste Courses"

ETAPE 2 — ShoppingModeView
  Ecran : liste d'items groupés par rayon
    - CategoryHeaders colorés (Color.qlRayonXxx)
    - ListRows en variante shoppingMode (hauteur 64pt)
  Etat initial : tous les items en statut "pas fait"

ETAPE 3 — Cocher un item
  Action : tap sur item "lait"
  Effet : checkmark animé (Motion.qlCheckmark), item grisé
  Comportement : l'item glisse en bas de sa section (décision QO-3 validée)
  Animation : spring response 0.35, item existant se déplace vers le bas
  Feedback haptique : UIImpactFeedbackGenerator(.medium)

ETAPE 4 — Corriger un rayon (US-09)
  Action : long press sur item "tofu"
  Menu contextuel : ["Déplacer vers...", liste des rayons]
  Sélection : "Crèmerie"
  Effet : item déplacé, préférence sauvegardée dans CategoryPreference
  Prochaine fois : "tofu" ira directement en Crèmerie sans appel IA

ETAPE 5 — Retourner aux listes
  Action : tap sur l'onglet "Listes" (checklist) dans la TabBar
  Transition : switch d'onglet natif (cross-fade)
  L'état de ShoppingModeView est conservé (items cochés persistent)
```

---

### Flow C — "Import vocal"

Couvre : US-16, US-18

```
ETAPE 1 — Ouvrir la dictée
  Action : tap sur [mic.fill] dans AddItemBar
  Prérequis : Apple Intelligence disponible (sinon bouton absent)
  Transition : sheet montante (.medium detent), Motion.qlExpressive
  Feedback haptique : UIImpactFeedbackGenerator(.light)

ETAPE 2 — Enregistrement
  Ecran : VoiceImportSheet, état "recording"
  Visuel : waveform animée centrée, bouton Stop rouge
  Action : l'utilisateur dit "du lait, des pâtes et appeler le dentiste"
  Transcription : texte transcrit en direct sous la waveform

ETAPE 3 — Stop et traitement
  Action : tap Stop
  Ecran : état "processing", shimmer sur les futurs items
  Foundation Models : découpe la phrase en items distincts
  Résultat attendu : ["Lait", "Pâtes", "Appeler le dentiste"]
    - Chacun avec rayon proposé / liste proposée

ETAPE 4 — Revue
  Ecran : VoiceImportSheet état "review"
  Affichage : liste des items, chacun éditable inline
  "Appeler le dentiste" → proposition de liste : "Tâches" (confiance haute)
  "Lait" → proposition : liste Courses courante (confiance haute)

ETAPE 5 — Validation
  Action : tap "Ajouter [N] items"
  Items routés vers leurs listes respectives
  Sheet dismiss, retour sur ListDetail
  Items visibles immédiatement
  Feedback haptique : UINotificationFeedbackGenerator(.success)

ETAPE 6 — Cas confiance faible (US-18)
  Item "truc à faire" → confiance faible → InboxRoutingSheet
  L'utilisateur choisit la liste, ou laisse en Inbox
```

---

### Flow D — "Scan de ticket"

Couvre : US-17

```
ETAPE 1 — Accès
  Depuis AddItemBar : icône doc.viewfinder (visible selon contexte)
  Depuis ListOptionsSheet : "Scanner un ticket"
  Transition : fullScreenCover (camera nécessite plein écran)

ETAPE 2 — Camera
  Ecran : viewfinder avec rectangle guide centré
  Label : "Cadrez le ticket dans le rectangle"
  Action : tap déclencheur (ou capture automatique si document détecté)

ETAPE 3 — Traitement Foundation Models
  Ecran : overlay semi-transparent avec shimmer
  Label : "Extraction des produits…" (ql.receipt.processing)
  Durée : variable (entrée image, modèle 2026)

ETAPE 4 — Revue des items extraits
  Ecran : liste scrollable, chaque ligne avec checkbox de sélection
  Tous cochés par défaut
  L'utilisateur peut décocher ce qu'il ne veut pas ajouter
  Possibilité d'éditer chaque titre

ETAPE 5 — Validation
  Action : "Ajouter [N] produits"
  Ajout dans la liste active, catégorisation en arrière-plan
  Feedback haptique : UINotificationFeedbackGenerator(.success)
```

---

### Flow E — "Partager une liste"

Couvre : US-21

```
ETAPE 1 — Accès
  Via ListOptionsSheet : "Partager" (person.2.badge.plus)
  Ou via ContextMenu sur ListCard : "Partager"

ETAPE 2 — ShareListSheet
  Présentation : .sheet .large detent
  Affichage : lien de partage + input email / contacts
  Bouton : "Envoyer une invitation" (iCloud CloudKit sharing)

ETAPE 3 — Confirmation
  Invitation envoyée : toast confirmation
  ListCard affiche désormais icon person.2.fill (partagée)
  SyncIndicator sync les modifications en temps réel entre collaborateurs
```

---

## 4. Règles de transition

### Principes généraux

- Les transitions de navigation (push/pop) utilisent la transition système SwiftUI (HIG : Transitions).
- Les sheets montent depuis le bas (.spring avec response 0.4).
- Les fullScreenCovers glissent depuis le bas (system default).
- Les toasts apparaissent depuis le bas par-dessus le contenu (.spring response 0.2).
- La suppression d'item use une combinaison scale + fade + collapse de hauteur.

### Gestes supportés

```
Geste                     | Contexte              | Effet
--------------------------|-----------------------|-----------------------------
Swipe left sur item       | ListDetail            | Action "Supprimer"
Swipe right sur item      | ListDetail            | (réservé, aucune action)
Swipe down sur sheet      | Toutes sheets         | Dismiss
Swipe down sur toast      | UndoToast             | Dismiss manuel
Swipe down en top (list)  | ListDetail            | Pull-to-refresh (sync iCloud)
Long press sur ListCard   | HomeView              | ContextMenu
Long press sur item       | ShoppingModeView      | Menu "Déplacer vers rayon"
Drag & drop item          | ShoppingModeView      | Réordonner dans un rayon
Pinch (iPad)              | HomeView              | Passer grille 2 → 3 colonnes
```

---

## 5. Empty States et états dégradés

### 5.1 Hiérarchie des empty states

```
App sans aucune liste
    → HomeView empty state → CTA "Créer ma première liste"

Liste sans items
    → ListDetail empty state → focus automatique AddItemBar

Apple Intelligence indisponible (US-19)
    → Boutons mic et scan absents
    → Tri manuel seulement (pas de CategoryHeaders IA)
    → Badge "Apple Intelligence requis" dans Settings

Mode offline
    → SyncIndicator masqué (pas de notifications anxiogènes)
    → Les actions locales fonctionnent normalement
    → Sync reprise automatiquement à la reconnexion
```

### 5.2 Inbox (US-18)

L'Inbox est une liste système cachée, visible uniquement quand elle contient des items non routés. Elle apparaît en tête de la HomeView avec une badge orange pour attirer l'attention.

---

*Fin du document workflow.md*
*Version 0.2 — Décisions QO-1 à QO-7 intégrées*
