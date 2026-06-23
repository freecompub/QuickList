# Mockup — Empty States

> US couvertes : US-04, US-01, US-19, US-10
> A VALIDER PAR L'UTILISATEUR AVANT IMPLEMENTATION

---

## Principes des empty states (HIG : Empty States)

Les empty states de QuickList suivent les recommandations HIG :
- Icône grande et expressive (SF Symbol, 56-64pt)
- Titre court et clair
- Sous-titre contextuel et utile (pas générique)
- CTA (Call To Action) quand une action directe est possible
- Jamais d'images illustratives complexes (minimalisme Apple)
- Le vide ne doit pas sembler cassé — il doit sembler prêt

---

## 1. Home — Aucune liste

```
┌─────────────────────────────────────────────┐
│ ████████████████████████████████████████████│
├─────────────────────────────────────────────┤
│                                             │
│  Mes listes                                 │
│                                             │
├─────────────────────────────────────────────┤
│                                             │
│                                             │
│                                             │
│                                             │
│                                             │
│            checklist                        │
│            (56pt)                           │  ← SF Symbol
│            Color.qlSecondaryLabel           │    rendu .hierarchical
│                                             │
│          Aucune liste                        │  ← ql.home.empty.title
│          Font.qlTitle2                      │    .semibold
│          Color.qlPrimaryLabel               │
│          (centré)                           │
│                                             │
│   Créez votre première liste               │  ← ql.home.empty.subtitle
│   en appuyant sur +.                        │    Font.qlBody
│   Color.qlSecondaryLabel                   │    Color.qlSecondaryLabel
│   (centré, max 280pt largeur)              │    multiline centré
│                                             │
│                                             │
│              ┌──────────────┐              │
│              │ + Créer une  │              │  ← CTA inline (optionnel)
│              │     liste    │              │    Radius.qlPill
│              └──────────────┘              │    bg qlAccent, white label
│                                             │    Font.qlBody.semibold
│                                             │
│                                             │
│                                             │
│                              ┌──────────┐  │
│                              │   [+]    │  │  ← FAB (toujours présent)
│                              └──────────┘  │
│ ████████████████████████████████████████████│
└─────────────────────────────────────────────┘
```

---

## 2. Liste vide (items = 0)

```
┌─────────────────────────────────────────────┐
│ ████████████████████████████████████████████│
├─────────────────────────────────────────────┤
│  ◀ Retour         Tâches     [···] [☁]      │
├─────────────────────────────────────────────┤
│                                             │
│                                             │
│                                             │
│                                             │
│             checklist                       │  ← Icône correspondant au type
│             (48pt)                          │    de liste (cart, checklist, etc.)
│             Color.qlSecondaryLabel          │
│                                             │
│           Liste vide                        │  ← ql.list.empty.title
│           Font.qlTitle2                     │
│           Color.qlPrimaryLabel              │
│                                             │
│   Commencez à taper pour ajouter           │  ← ql.list.empty.subtitle
│   votre premier item.                       │    Font.qlBody
│   Color.qlSecondaryLabel (centré)          │    Color.qlSecondaryLabel
│                                             │
│                                             │
│                                             │
├─────────────────────────────────────────────┤
│  ┌──────────────────────────┐               │  ← AddItemBar
│  │  Ajouter un item…   [🎤] │  [+]          │    AVEC focus automatique
│  └──────────────────────────┘               │    cursor visible, clavier ouvert
│  Material.qlBarBackground                   │
│ ████████████████████████████████████████████│
└─────────────────────────────────────────────┘
```

Variante par type de liste :

| Type | Icône | Titre | Sous-titre |
|------|-------|-------|------------|
| Courses | cart.fill | "Liste de courses vide" | "Ajoutez vos premiers articles." |
| Tâches | checklist | "Aucune tâche" | "Ajoutez votre première tâche." |
| Idées | lightbulb.fill | "Aucune idée pour l'instant" | "Capturez vos idées ici." |
| Projets | folder.fill | "Projet vide" | "Commencez par ajouter vos premières actions." |
| Favoris | star.fill | "Aucun favori" | "Ajoutez vos items préférés." |

---

## 3. Apple Intelligence non disponible (US-19)

### 3a. Bandeau informatif dans ListDetail (type Courses)

Affiché discrètement en bas de la liste, avant l'AddItemBar :

```
│  ┌──────────────────────────────────────────┐  │
│  │  sparkles.slash (14pt)                   │  │  ← Bandeau non-bloquant
│  │  qlSecondaryLabel                        │  │    bg qlSecondaryBackground
│  │                                          │  │    border top 1pt qlSeparator
│  │  Le tri par rayon nécessite Apple        │  │    Font.qlCallout
│  │  Intelligence. Les articles sont         │  │    Color.qlSecondaryLabel
│  │  affichés par ordre d'ajout.             │  │    icon 14pt leading
│  │                                          │  │
│  └──────────────────────────────────────────┘  │
```

### 3b. Ecran dédié "Apple Intelligence indisponible" (Settings)

```
┌─────────────────────────────────────────────┐
│                                             │
│                                             │
│           sparkles.slash                    │  ← 48pt, qlSecondaryLabel
│                                             │
│    Apple Intelligence                       │  ← Titre
│    non disponible                           │    Font.qlTitle2
│    Color.qlPrimaryLabel (centré)           │
│                                             │
│  Les fonctionnalités suivantes ne sont      │  ← Sous-titre
│  pas disponibles sur cet appareil :         │    Font.qlBody qlSecondaryLabel
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  sparkles.slash  Tri par rayon IA    │  │  ← Liste des features manquantes
│  ├──────────────────────────────────────┤  │    Chacune avec icon grisé
│  │  sparkles.slash  Import vocal        │  │
│  ├──────────────────────────────────────┤  │
│  │  sparkles.slash  Scan de ticket      │  │
│  ├──────────────────────────────────────┤  │
│  │  sparkles.slash  Auto-routage        │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  L'app reste entièrement fonctionnelle      │  ← Message rassurant
│  pour la gestion de listes et le           │    Font.qlCallout
│  tri manuel.                               │    Color.qlSecondaryLabel
│                                             │
│         ┌──────────────────────────┐       │
│         │  En savoir plus → Apple  │       │  ← Lien optionnel
│         └──────────────────────────┘       │
│                                             │
└─────────────────────────────────────────────┘
```

### 3c. AddItemBar sans features IA

```
│  ┌──────────────────────────┐               │  ← Pas de bouton mic
│  │  Ajouter un item…        │  [+]          │    Pas de bouton scan
│  └──────────────────────────┘               │    Champ plus large
│  Material.qlBarBackground                   │
```

---

## 4. Mode offline (pas de connexion iCloud)

Pas d'empty state bloquant. L'app fonctionne en local. Seul indicateur :

```
│  ◀ Retour         Tâches    [···]           │  ← Pas de SyncIndicator
│                             (absent)         │    On ne montre pas l'état offline
│                                             │    pour éviter l'anxiété
```

Si l'utilisateur tente une action de partage :

```
│  ╔═══════════════════════════════════════╗  │
│  ║                                       ║  │  ← Alert
│  ║  Connexion requise                    ║  │
│  ║                                       ║  │
│  ║  Le partage nécessite une connexion   ║  │
│  ║  Internet. Réessayez plus tard.       ║  │
│  ║                                       ║  │
│  ╠═══════════════════════════════════════╣  │
│  ║  OK                                   ║  │
│  ╚═══════════════════════════════════════╝  │
```

---

## 5. Recherche sans résultat (future feature, prévu)

Design prévu même si la recherche n'est pas dans le MVP :

```
│            magnifyingglass (48pt)           │
│            Color.qlSecondaryLabel           │
│                                             │
│          Aucun résultat                     │
│          Font.qlTitle2                      │
│          Color.qlPrimaryLabel               │
│                                             │
│  Aucun item ne correspond à "laib".         │  ← Reprend le terme recherché
│  Vérifiez l'orthographe ou essayez          │
│  un autre mot.                              │
│  Font.qlBody · qlSecondaryLabel (centré)   │
```

---

## 6. Inbox vide

L'Inbox vide n'a pas d'empty state visible — la card Inbox disparaît de la HomeView. C'est l'état normal : l'Inbox n'existe visuellement que quand elle contient des items.

---

## Tokens communs aux empty states

```
Icône          : 48-56pt selon contexte, Color.qlSecondaryLabel, .hierarchical
Titre          : Font.qlTitle2, Color.qlPrimaryLabel, centré
Sous-titre     : Font.qlBody, Color.qlSecondaryLabel, centré, max 280pt largeur
CTA bouton     : Radius.qlPill, bg qlAccent, Font.qlBody.semibold, Color.white
Spacing icône → titre : Spacing.qlXXL (24pt)
Spacing titre → sous-titre : Spacing.qlM (12pt)
Spacing sous-titre → CTA : Spacing.qlXXXL (32pt)
```
