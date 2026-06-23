# Mockup — Partage CloudKit d'une liste

> US couvertes : US-21, US-10, US-11
> A VALIDER PAR L'UTILISATEUR AVANT IMPLEMENTATION

---

## Accès

Via ListOptionsSheet > "Partager" (person.2.badge.plus)
Via ContextMenu sur ListCard > "Partager"

---

## ShareListSheet — Etat initial (liste non partagée)

```
┌─────────────────────────────────────────────┐
│  (contenu derrière, assombri)                │
│                                             │
├─────────────────────────────────────────────┤
│            ════                             │  ← Grabber
│                                             │
│  Annuler           Partager         [Inviter]│  ← Bouton "Inviter" = partage iCloud
│  qlAccent          Font.qlTitle3    qlAccent│    Font.qlBody.semibold
│                    qlPrimaryLabel.semibold  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  [cart.fill 24pt]  Courses           │  │  ← Aperçu de la liste partagée
│  │  Font.qlHeadline   qlPrimaryLabel   │  │    bg qlSurface, Radius.qlMedium
│  │  5 items                             │  │    padding qlL
│  └──────────────────────────────────────┘  │
│                                             │
│  PARTAGER AVEC                              │  ← Section header
│  Font.qlCaption1.uppercased qlSecondaryLabel│
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  person.badge.plus   Inviter         │  │  ← Row CTA pour CloudKit share
│  │  qlAccent            Font.qlBody    │  │    Déclenche le système natif iOS
│  │                      qlAccent        │  │    (UICloudSharingController)
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  link       Copier le lien           │  │  ← Alternative : copie du lien
│  │  qlPrimaryLabel Font.qlBody          │  │    pour envoi manuel
│  └──────────────────────────────────────┘  │
│                                             │
│  AUTORISATION                               │  ← Section permissions
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  Collaborateurs      [Lire et écrire]│  │  ← Picker de permissions
│  │  Font.qlBody         Font.qlCallout  │  │    "Lire et écrire" / "Lecture seule"
│  │                      qlAccent        │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  Les collaborateurs verront toutes les      │  ← Note explicative
│  modifications en temps réel.               │    Font.qlFootnote qlSecondaryLabel
│                                             │
│ ████████████████████████████████████████████│
└─────────────────────────────────────────────┘
```

---

## ShareListSheet — Etat : liste déjà partagée (collaborateurs actifs)

```
├─────────────────────────────────────────────┤
│            ════                             │
│                                             │
│  Fermer            Partage actif    [Gérer] │  ← "Gérer" : UICloudSharingController
│  qlAccent                           qlAccent│
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  [cart.fill 24pt]  Courses           │  │
│  │  5 items    person.2.fill (badge)    │  │  ← Badge "partagée"
│  └──────────────────────────────────────┘  │
│                                             │
│  COLLABORATEURS (2)                         │  ← Section avec count
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  [Avatar initiales "SM"]             │  │  ← Avatar généré depuis le prénom
│  │  Samir Alili (vous)      Propriétaire│  │    bg qlAccent, white initiales
│  │  Font.qlBody              qlSecLbl   │  │    24pt cercle
│  ├──────────────────────────────────────┤  │
│  │  [Avatar "MA"]                       │  │  ← Collaborateur #1
│  │  Marie A.                Lire/Écrire │  │
│  │  Font.qlBody              qlSecLbl   │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  person.badge.plus   Inviter d'autres│  │
│  │  qlAccent            Font.qlBody     │  │
│  │                      qlAccent        │  │
│  └──────────────────────────────────────┘  │
│                                             │
│  DANGER ZONE                               │  ← Section séparée visuellement
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │  person.2.slash  Arrêter le partage  │  │  ← Action destructive (confirmation)
│  │  qlDanger        Font.qlBody.qlDanger│  │
│  └──────────────────────────────────────┘  │
│                                             │
│ ████████████████████████████████████████████│
└─────────────────────────────────────────────┘
```

---

## Comportement d'invitation (UICloudSharingController)

Tap "Inviter" déclenche `UICloudSharingController` (natif iOS) :

```
┌─────────────────────────────────────────────┐
│                                             │
│  [UICloudSharingController — natif iOS]     │  ← Système Apple
│                                             │    Design 100% Apple, on ne customise pas
│  "Inviter des personnes à                   │
│   afficher ou modifier                      │
│   'Courses'"                                │
│                                             │
│  [Qui peut accéder ?]                       │
│  ○ Seulement les personnes invitées         │
│  ○ Toute personne avec le lien              │
│                                             │
│  [Autorisation ?]                           │
│  ○ Lire et écrire                           │
│  ○ Lecture seule                            │
│                                             │
│  [Partager via...]  [Copier le lien]        │
│                                             │
└─────────────────────────────────────────────┘
```

---

## Indicateurs de synchronisation en collaboration (US-11)

Quand un collaborateur modifie la liste :

1. Les items modifiés reçoivent une légère animation flash (background bref en qlAccent opacity 0.2)
2. Si les changements arrivent pendant que l'utilisateur est sur la liste : insertion silencieuse (Motion.qlItemInsert discret)
3. Si conflit : la version la plus récente gagne (CloudKit last-write-wins)
4. Pas d'indication "Modifié par [prénom]" pour rester minimal (à valider)

---

## ListCard — Etat partagée

```
┌───────────────────────┐
│  cart.fill  [5] ●     │  ← Badge count
│    person.2.fill      │  ← Icône en overlay top-right
│    (14pt, qlAccent)   │    "Partagée avec d'autres"
│                       │
│  Courses              │
│  5 items · ☁          │
└───────────────────────┘
```

VoiceOver ListCard partagée : "Courses, 5 items, partagée avec 1 collaborateur"

---

## Etat : offline (partage non disponible)

```
│  ╔══════════════════════════════════════╗  │
│  ║                                      ║  │  ← Alert système
│  ║  Connexion requise                   ║  │
│  ║                                      ║  │
│  ║  Le partage de listes nécessite      ║  │
│  ║  une connexion Internet.             ║  │
│  ║                                      ║  │
│  ╠══════════════════════════════════════╣  │
│  ║  OK                                  ║  │
│  ╚══════════════════════════════════════╝  │
```

---

## Interactions

| Action | Geste | Feedback |
|--------|-------|----------|
| Ouvrir ShareSheet | Tap "Partager" | UIImpactFeedbackGenerator(.light) |
| Inviter | Tap "Inviter" | System UICloudSharingController |
| Copier lien | Tap "Copier le lien" | Toast "Lien copié" + UINotificationFeedbackGenerator(.success) |
| Arrêter partage | Tap "Arrêter le partage" | Alert de confirmation |

---

## Adaptations iPad / macOS

iPad : la ShareSheet est un `.formSheet`. UICloudSharingController est présenté en `.formSheet` également.

macOS : UICloudSharingController n'existe pas directement. On utilise NSSharingService et les APIs CloudKit macOS. Le design du panneau est adapté à la présentation NSPanel ou sheet native macOS.
