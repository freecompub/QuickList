# QuickList — Roadmap

Ordre d'implémentation des user stories. Source de vérité de la priorisation
consommée par le skill `user-story-loop`. Les détails (CA, modèle de données,
prompts Foundation Models) sont dans `docs/UserStories/QuickList_user_stories.md`.

Légende : `→` dépend de.

---

## Phase 1 — MVP (J1 – J7)

### 1.1 Ajout ultra-rapide
- **US-01** — Ajouter un item en une frappe — *en revue*
- **US-02** — Annuler un ajout par erreur (swipe + undo) → US-01

### 1.2 Listes multiples
- **US-03** — Créer une liste (nom + type) — *en revue*
- **US-04** — Voir toutes mes listes (accueil) → US-03
- **US-05** — Renommer / supprimer une liste (inline, cascade) → US-03

### 1.3 Tri intelligent
- **US-06** — Choisir un mode de tri (par liste, persisté) → US-03
- **US-07** — Tri par rayon (Foundation Models + fallback JSON) → US-03

### 1.4 Mode Courses
- **US-08** — Interface de courses dédiée (TabBar) → US-03, US-07
- **US-09** — Corriger une catégorie et la mémoriser
  (`CategoryPreference`) → US-08

### 1.5 Synchronisation iCloud
- **US-10** — Retrouver mes listes sur tous mes appareils (CloudKit) → US-03
- **US-11** — Voir les modifications à jour (résolution de conflit) → US-10

### 1.6 Widgets iOS
- **US-12** — Widget « Liste rapide » → US-03
- **US-13** — Cocher depuis le widget (App Intents) → US-12
- **US-14** — Widget « Derniers items » (cross-listes) → US-03

---

## Phase 2 — Intelligence on-device (Foundation Models)

> Pré-requis : iOS 26+ / macOS 26+, Xcode 26+, appareil Apple Intelligence
> pour exécuter le vrai modèle. **Stratégie validée 2026-06-23** (cf.
> `OPEN-QUESTIONS.md` § ENV-IA) :
> - US-19 (fallback) est implémentée **en premier** pour livrer une UX
>   dégradée fonctionnelle dès le départ.
> - Tout le code IA passe obligatoirement par un protocole
>   `LanguageModelService` injectable.
> - La CI tourne sous iOS 17 avec un mock complet du protocole. Le vrai
>   code Foundation Models n'est exécuté qu'en dev local sur machine
>   iOS 26+.

- **US-19** — Repli gracieux sans Apple Intelligence
  (`SystemLanguageModel.availability` + mapping JSON local) → US-07
  *(fait avant les autres pour poser le protocole et le fallback)*
- **US-15** — Capture instantanée, classification en arrière-plan → US-19
- **US-16** — Import vocal → items structurés (Speech + `@Generable`) → US-15
- **US-17** — Scan de ticket → produits (entrée image) → US-15
- **US-18** — Auto-routage vers la bonne liste (Inbox de repli) → US-15

---

## Phase 3 — Bonus

- **US-20** — Suggestions automatiques pendant la saisie → US-01
- **US-21** — Listes partagées (CloudKit Sharing) → US-10, US-11

---

## Règles d'ordre

1. Ne jamais commencer une phase tant que la précédente n'est pas
   intégralement `done` ou explicitement reportée par décision utilisateur.
2. À l'intérieur d'une phase, respecter les dépendances `→` ci-dessus.
3. Une US bloquée ne bloque que ses dépendantes — la boucle contourne et
   passe à la suivante éligible.
4. La phase 2 peut être déclarée non éligible si l'environnement de build
   n'est pas iOS 26+ ; dans ce cas, sauter vers la phase 3 après accord
   utilisateur.
