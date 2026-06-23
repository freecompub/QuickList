# QuickList — Propositions d'icône d'application

> Version 1.0 — Propositions soumises à validation le 2026-06-23
> Auteur : UI Designer Agent
> Couleur d'accent : bleu système Apple (QO-1 validée)

Cinq directions visuelles proposées. L'utilisateur doit choisir parmi elles avant implémentation.

---

## Proposition 1 — "L'éclair de liste"

### Concept
Un éclair (vitesse, instantanéité) intégré dans une liste minimaliste. La valeur "ultra-rapide" de QuickList traduite visuellement.

### Description visuelle

```
╭─────────────────────────────╮
│                             │
│    ━━━━━━━━━━               │
│         ╲                   │
│    ━━━━━━╲━━━               │
│           ╲                 │
│    ━━━━━━━━╲                │
│                             │
╰─────────────────────────────╯
```

- Fond : dégradé bleu système (qlAccent clair en haut → qlAccent saturé en bas)
- Trois lignes horizontales blanches (lignes d'une liste), chacune interrompue par un éclair blanc en biseau
- L'éclair traverse les trois lignes de gauche à droite, de haut en bas
- Lignes : 3pt de hauteur, arrondie aux extrémités
- Style : épuré, pas d'ombre sur l'éclair
- Fond corner radius : 22% de la taille (standard iOS)

### Représentation ASCII (carré iOS arrondi, 1024pt)

```
  ┌──────────────────────────────────────┐
  │  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  │
  │  ━━━━━━━━━━━━━╲  ·  ·  ·  ·  ·  ·  │
  │  ·  ·  ·  ·  ·╲  ·  ·  ·  ·  ·  ·  │
  │  ━━━━━━━━━━━━━━╲━━━━━━━  ·  ·  ·  · │
  │  ·  ·  ·  ·  ·  ╲  ·  ·  ·  ·  ·  │
  │  ·  ·  ·  ·  ·  ·╲━━━━━━━━━━━━━━━  │
  │  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  │
  └──────────────────────────────────────┘
  Fond : bleu qlAccent (dégradé léger)
```

### Forces
- Représente directement la valeur "ultra-rapide"
- Iconique et mémorable à toutes les tailles
- Le dégradé bleu est cohérent avec qlAccent
- Scalabilité excellente : l'éclair reste lisible en 29pt (notification)

### Faiblesses
- Le concept "éclair" est utilisé par d'autres apps (Instapaper, certaines apps météo)
- Le lien avec "liste" est indirect (il faut comprendre l'abstraction)

### Variante macOS
Fond transparent, icône en bleu qlAccent sur fond blanc avec ombre portée douce (shadow offset y:4, blur:12, opacity:0.2). L'éclair est en bleu, les lignes en gris foncé.

---

## Proposition 2 — "Le checkmark typographique"

### Concept
Un checkmark minimal, stylisé, qui est aussi une lettre "Q" retournée. Jeu typographique subtil entre l'identité de l'app (QuickList) et son action principale (cocher).

### Description visuelle

```
╭─────────────────────────────╮
│                             │
│         ╭────╮              │
│         │    │              │
│         ╰───╱               │
│             ╲               │
│              ╲__            │
│                             │
╰─────────────────────────────╯
```

- Fond blanc pur (ou blanc cassé très léger)
- Un checkmark épais (4-5pt stroke) en bleu qlAccent, centré
- Le checkmark est dessiné avec une légère courbure sur la descente gauche, évoquant un "Q"
- Pas de texte — uniquement le symbole
- Fond corner radius standard iOS

### Représentation ASCII

```
  ┌──────────────────────────────────────┐
  │  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  │
  │  ·  ·  ·  ╭──────╮  ·  ·  ·  ·  · │
  │  ·  ·  ·  │      │  ·  ·  ·  ·  · │
  │  ·  ·  ·  ╰────╮ │  ·  ·  ·  ·  · │
  │  ·  ·  ·  ·  ╲ │  ·  ·  ·  ·  ·  │
  │  ·  ·  ·  ·  ·╲╯  ·  ·  ·  ·  ·  │
  │  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  │
  └──────────────────────────────────────┘
  Fond : blanc, checkmark bleu qlAccent
```

### Forces
- Abstrait et sophistiqué — marque une intention de design forte
- Fond blanc : lisible dans tous les contextes (écran principal, Spotlight, App Store)
- Très scalable : le checkmark reste reconnaissable en 16pt (macOS Dock small)
- Cohérent avec l'action principale de l'app

### Faiblesses
- L'ambiguïté "Q" n'est visible que pour les designers — les utilisateurs voient juste un checkmark
- Le fond blanc peut sembler moins "premium" qu'un fond coloré
- Un checkmark seul peut être confondu avec d'autres apps (Reminders, Things, etc.)

### Variante macOS
Icône identique sur fond transparent. Légère ombre portée (shadow y:3, blur:8, opacity:0.15). Le checkmark est dessiné vectoriellement, il reste net à toutes les tailles.

---

## Proposition 3 — "La liste condensée"

### Concept
Trois lignes de liste, visuellement compressées comme si elles étaient "ultra-rapides" — avec des puces circulaires et un effet de vitesse donné par des longueurs décroissantes.

### Description visuelle

```
╭─────────────────────────────╮
│                             │
│  ●  ━━━━━━━━━━━━━━━━━━━    │
│                             │
│  ●  ━━━━━━━━━━━             │
│                             │
│  ●  ━━━━━━━━━━━━━━━━        │
│                             │
╰─────────────────────────────╯
```

- Fond : bleu qlAccent plein (pas de dégradé — plus moderne et simple)
- Trois rangées de liste : puce circulaire blanche (12pt) + ligne blanche (trait de 3pt hauteur)
- Les lignes ont des longueurs légèrement variables (pas parfaitement alignées à droite) pour donner un sentiment de contenu réel
- Espacements généreux entre les rangées
- Style : identique au design in-app (ListRow), ce qui crée une cohérence méta

### Représentation ASCII

```
  ┌──────────────────────────────────────┐
  │  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  │
  │  ·  ●  ━━━━━━━━━━━━━━━━━━━━━━  ·  │
  │  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  │
  │  ·  ●  ━━━━━━━━━━━━━  ·  ·  ·  ·  │
  │  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  │
  │  ·  ●  ━━━━━━━━━━━━━━━━━━  ·  ·  │
  │  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  │
  └──────────────────────────────────────┘
  Fond : bleu qlAccent plein
```

### Forces
- Immédiatement reconnaissable comme "app de liste"
- La cohérence avec l'UI in-app renforce la mémorisation
- Le fond bleu qlAccent est cohérent avec la couleur d'accent (QO-1)
- Fonctionne très bien en 60pt (App Library) et 120pt (App Store featured)

### Faiblesses
- Moins distinctif — beaucoup d'apps de liste utilisent ce motif (Todoist, TickTick)
- Risque de ressembler générique sans un traitement graphique soigné
- La scalabilité en très petit (16pt) est correcte mais pas excellente

### Variante macOS
Fond bleu qlAccent, lignes et puces blanches. Fond arrondi macOS (sans bords, juste l'icône). Ombre portée légère.

---

## Proposition 4 — "Le Q minimaliste"

### Concept
La lettre "Q" de QuickList, avec la queue du Q stylisée en checkmark. Simple, propriétaire, mémorable.

### Description visuelle

```
╭─────────────────────────────╮
│                             │
│       ╭────────╮            │
│       │        │            │
│       │        │            │
│       ╰────╮──╯             │
│            ╲___             │
│                             │
╰─────────────────────────────╯
```

- Fond : blanc ou bleu qlAccent (deux sub-variantes possibles)
- La lettre "Q" en stroke épais (5-6pt), en bleu qlAccent (sur fond blanc) ou blanc (sur fond bleu)
- La queue traditionnelle du Q est remplacée par un checkmark — le trait diagonal devient la descente d'un tick
- Police de base : SF Pro Rounded Bold, mais la queue est modifiée manuellement
- Pas de fond dégradé — aplat propre

### Représentation ASCII

```
  ┌──────────────────────────────────────┐
  │  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  │
  │  ·  ·  ╭──────────╮  ·  ·  ·  ·  · │
  │  ·  ·  │          │  ·  ·  ·  ·  · │
  │  ·  ·  │          │  ·  ·  ·  ·  · │
  │  ·  ·  ╰────╮─────╯  ·  ·  ·  ·  · │
  │  ·  ·  ·  ·  ╲___  ·  ·  ·  ·  ·  │
  │  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  │
  └──────────────────────────────────────┘
  Sub-variante A : fond blanc, Q bleu qlAccent
  Sub-variante B : fond bleu qlAccent, Q blanc
```

### Forces
- Propriétaire et unique — personne n'a ce Q-checkmark
- Double sens clair : Q de QuickList + checkmark d'item complété
- Excellent en grande taille (App Store screenshots)
- Scalable : le Q reste lisible même en 16pt

### Faiblesses
- Nécessite un vrai travail de lettreur/typographe pour que la queue-checkmark soit élégante
- Sur petit fond (notification 20pt), le Q peut sembler juste un "O" si la queue est trop fine
- La sub-variante fond blanc peut sembler moins distinctive en App Store (beaucoup d'icônes blanches)

### Variante macOS
Sub-variante A préférée pour macOS (fond transparent, Q bleu). Ombre portée douce. Peut être dessiné avec NSBezierPath directement.

---

## Proposition 5 — "L'éclair dans la case"

### Concept
Une case à cocher (checkbox) avec un éclair à l'intérieur au lieu d'un checkmark classique. Fusion des deux concepts centraux de l'app : la liste (checkbox) et la vitesse (éclair).

### Description visuelle

```
╭─────────────────────────────╮
│                             │
│      ┌──────────┐           │
│      │    ╲     │           │
│      │  ━━━╲━━  │           │
│      │      ╲   │           │
│      └──────────┘           │
│                             │
╰─────────────────────────────╯
```

- Fond : bleu qlAccent (dégradé subtil, clair en haut)
- Une case à cocher blanche, coins arrondis (Radius.qlSmall équivalent), stroke 3pt
- À l'intérieur : un éclair blanc (rempli, pas stroke), centré
- Proportion : la case occupe 55-60% de la surface de l'icône, centrée
- Style : moderne, géométrique

### Représentation ASCII

```
  ┌──────────────────────────────────────┐
  │  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  │
  │  ·  ·  ┌─────────────────┐  ·  ·  · │
  │  ·  ·  │  ·  ╲  ·  ·  · │  ·  ·  · │
  │  ·  ·  │  ━━━━╲━━━━  ·  │  ·  ·  · │
  │  ·  ·  │  ·  ·  ╲  ·  · │  ·  ·  · │
  │  ·  ·  └─────────────────┘  ·  ·  · │
  │  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  │
  └──────────────────────────────────────┘
  Fond : bleu qlAccent
```

### Forces
- Représente les deux idées fondamentales de l'app en une seule image
- Original et mémorable — cette combinaison est rare
- Le fond bleu est cohérent avec qlAccent
- Très lisible à toutes les tailles grâce aux formes géométriques simples

### Faiblesses
- L'éclair dans une case est une combinaison qui peut paraître chargée en très petit (20pt)
- Le concept "checkbox + éclair" est fort mais pourrait sembler confus à des non-designers
- Nécessite un soin particulier sur les proportions pour que l'éclair ne se perde pas dans la case

### Variante macOS
Fond bleu avec légère ombre portée (shadow y:4, blur:14, opacity:0.18). La case et l'éclair sont blancs. Le contraste est fort et l'icône reste nette à toutes les densités d'écran (Retina, 5K).

---

## Tableau comparatif

| | P1 Eclair liste | P2 Checkmark-Q | P3 Liste condensée | P4 Q minimaliste | P5 Eclair dans case |
|---|---|---|---|---|---|
| Originalité | Moyenne | Haute | Basse | Haute | Haute |
| Clarté du concept | Moyenne | Haute | Haute | Haute | Haute |
| Scalabilité 16pt | Bonne | Bonne | Correcte | Bonne | Correcte |
| Cohérence qlAccent | Oui | Partielle | Oui | Partielle | Oui |
| Risque de confusion | Faible | Faible | Moyen | Très faible | Faible |
| Complexité de réalisation | Moyenne | Haute | Faible | Haute | Moyenne |

---

## Recommandation du designer

La proposition **P4 — "Le Q minimaliste"** (sub-variante B : fond bleu, Q blanc) offre le meilleur équilibre entre originalité, mémorabilité et scalabilité. C'est l'option la plus distinctive sur l'App Store.

En second choix : **P5 — "L'éclair dans la case"** pour ceux qui préfèrent une icône qui communique immédiatement les deux valeurs de l'app (liste + vitesse).

**Décision attendue de l'utilisateur : choisir une proposition (ou indiquer des ajustements).**

---

*Fin du document app-icon-proposals.md*
*A VALIDER PAR L'UTILISATEUR AVANT TOUTE PRODUCTION GRAPHIQUE*
