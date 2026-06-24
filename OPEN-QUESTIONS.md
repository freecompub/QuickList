# OPEN-QUESTIONS — Décisions en attente

Journal des points qui bloquent ou requièrent un arbitrage humain. Le skill
`user-story-loop` y consigne chaque US passée en `blocked:*` avec la nature
du blocage, les options envisagées, et la décision attendue. Une question
résolue est déplacée vers la section « Résolues ».

## Format d'une entrée

```
### <ID-ou-tag> — <intitulé court>
- **Origine** : US concernée ou phase de design.
- **Nature** : contrainte technique / arbitrage produit / asset manquant.
- **Options** :
  - A) ...
  - B) ...
- **Recommandation** : (optionnelle, justifiée).
- **Décision attendue de** : utilisateur / équipe / Apple Developer config.
- **Statut** : ouverte | tranchée le YYYY-MM-DD.
```

---

## Ouvertes

### COMPAT-IOS17 — Vérification SwiftData sur device iOS 17.5 réel
- **Origine** : US-01 (ADR-002 dans `docs/decisions.md`).
- **Nature** : risque de compatibilité runtime résiduel.
- **Détail** : deployment target porté à iOS 17.5 (vs iOS 17.0 initialement)
  pour disposer des symboles SwiftData référencés par le binaire compilé
  avec le SDK iOS 26. Les tests s'exécutent sur le simulateur iOS 26.1.
- **Action attendue** : avant la première release TestFlight, exécuter
  l'app sur un device physique iOS 17.5 ou supérieur et valider le flux
  d'ajout sans crash. Si un nouveau symbole manque, soit bumper davantage
  le deployment target, soit refactoriser le call site fautif.
- **Statut** : ouverte.

### SYNC-UNDO — Résolution de conflit pour undo CloudKit (US-10/US-11)
- **Origine** : US-02 (ADR-003 dans `docs/decisions.md`).
- **Nature** : sémantique de sync.
- **Détail** : la stratégie "snapshot / restore" recrée un nouvel item
  (`persistentModelID` différent) lors de l'undo. Si un autre device
  supprime le même item entre `delete` local et `restore` local, CloudKit
  verra deux `delete` puis un `create` côté device A — pas un conflit
  classique. À implémenter lors de US-10/US-11 : soit accepter le doublon
  (cas le plus simple), soit déduire par titre + createdAt pour merger.
- **Action attendue** : décision technique avant US-10. Pas de blocage
  pour US-02 (mono-device).
- **Statut** : ouverte.

### CK-CONTAINER — Configuration du container iCloud
- **Origine** : US-10 / US-21.
- **Nature** : asset / config Apple Developer.
- **Détail** : la synchro CloudKit exige qu'un container iCloud soit déclaré
  côté compte développeur Apple, et que les entitlements soient configurés
  côté XcodeGen (`project.yml`).
- **Décision attendue de** : utilisateur (config compte) + ajout entitlements.
- **Statut** : ouverte.

---

## Résolues

### QO-8 — Troisième onglet de la TabBar
- **Origine** : phase de design v0.2 (`docs/design/README.md`).
- **Décision** : **Option A** — TabBar à 2 onglets (Listes / Courses).
  Réglages accessibles via `gearshape.fill` dans la NavigationBar de la
  HomeView. Cohérent avec l'esprit ultra-minimaliste de QuickList.
- **Tranchée le** : 2026-06-23 par l'utilisateur.
- **Impact** : aucun changement par rapport à l'état design v0.2 (l'Option A
  était déjà l'état par défaut). La design system, le workflow et les
  mockups restent inchangés. Pas de troisième onglet conditionnel à
  implémenter.

### ENV-IA — Disponibilité de l'environnement Foundation Models
- **Origine** : phase IA (US-15 → US-19).
- **Décision** : **Options B + C combinées** — livrer **US-19 d'abord**
  (fallback gracieux sans Apple Intelligence) ; isoler tout le code IA
  (US-15 à US-18) derrière un protocole `LanguageModelService` ;
  **mocker totalement** ce protocole dans les tests pour que la CI tourne
  sur iOS 17. Le vrai code Foundation Models n'est exécuté qu'en dev local
  sur machine iOS 26+. Les US-15 à US-18 sont implémentables tant que la
  machine de dev est compatible.
- **Tranchée le** : 2026-06-23 par l'utilisateur.
- **Impact** :
  - `docs/ROADMAP.md` : phase IA ré-ordonnée pour mettre **US-19 en premier**.
  - Tout nouvel accès au modèle on-device passe obligatoirement par le
    protocole `LanguageModelService` (injectable, mockable).
  - À documenter dans `docs/decisions.md` (ADR) lors de la première US IA.
