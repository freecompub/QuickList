# PROGRESS — User Stories

Registre vivant de l'avancement, consommé et mis à jour par le skill
`user-story-loop` à chaque changement d'état.

## Statuts

- `todo` — pas encore commencée
- `in-progress` — en cours de dev sur sa branche
- `awaiting-merge` — PR ouverte, CI verte, review OK, attente du GO explicite
  utilisateur (le `CLAUDE.md` interdit le merge sans autorisation)
- `done` — PR mergée
- `blocked:test` — épuisé le budget de 3 tentatives (voir Note + OPEN-QUESTIONS)
- `blocked:dep` — dépend d'une US non `done` (voir ROADMAP)
- `blocked:needs-human` — ambiguïté, asset manquant, capacité système requise

## Registre

| ID    | Phase    | Statut | Tentatives | PR | Note |
|-------|----------|--------|-----------|----|------|
| US-01 | MVP      | awaiting-merge | 1  | #1 | base: main · review approuvée (B1-B13 corrigés) |
| US-02 | MVP      | todo   | 0         |    | |
| US-03 | MVP      | awaiting-merge | 1  | #3 | base: feat/US-01-ajout-rapide (stacked) · review approuvee · pose QuickListLists |
| US-04 | MVP      | awaiting-merge | 1  | #4 | base: feat/US-03-creer-liste (stacked) · review approuvee · HomeView + ListCard |
| US-05 | MVP      | awaiting-merge | 1  | #5 | base: feat/US-04-home (stacked) · review approuvee · ContextMenu + RenameSheet + alert delete |
| US-06 | MVP      | awaiting-merge | 1  | #6 | base: feat/US-05-rename-delete (stacked) · review approuvee · Menu toolbar de tri |
| US-07 | MVP      | awaiting-merge | 1  | #8 | base: feat/US-19-fallback (stacked) · review approuvee (B5 L10N corrige) · RayonClassificationCoordinator + groceries grouping |
| US-08 | MVP      | awaiting-merge | 1  | #9 | base: feat/US-07-rayon (stacked) · review approuvee (B1-B7 + N1 cross-platform) · TabBar dédiée différée |
| US-09 | MVP      | in-progress | 1     |    | base: feat/US-08-courses (stacked) · CategoryPreference + ContextMenu choix de rayon |
| US-10 | MVP      | todo   | 0         |    | iCloud container à configurer côté Apple Developer |
| US-11 | MVP      | todo   | 0         |    | |
| US-12 | MVP      | todo   | 0         |    | Widget extension à ajouter au project.yml (XcodeGen) |
| US-13 | MVP      | todo   | 0         |    | App Intents pour widget interactif |
| US-14 | MVP      | todo   | 0         |    | |
| US-19 | IA       | awaiting-merge | 1  | #7 | base: feat/US-06-sort (stacked) · review approuvee · QuickListAI + LanguageModelService + fallback JSON |
| US-15 | IA       | todo   | 0         |    | Derrière `LanguageModelService` mocké en CI, vrai modèle uniquement en dev iOS 26 |
| US-16 | IA       | todo   | 0         |    | Speech + Foundation Models via le protocole |
| US-17 | IA       | todo   | 0         |    | Entrée image — version 2026 du framework |
| US-18 | IA       | todo   | 0         |    | Liste « Inbox » par défaut, dépend du protocole posé par US-19 |
| US-20 | Bonus    | todo   | 0         |    | |
| US-21 | Bonus    | todo   | 0         |    | CloudKit Sharing — config compte requise |
