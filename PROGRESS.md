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
| US-01 | MVP      | done | 1  | #1 | merged 2026-06-24 |
| US-02 | MVP      | done | 1  | #11 | merged 2026-06-24 |
| US-03 | MVP      | done | 1  | #12 | merged 2026-06-24 |
| US-04 | MVP      | done | 1  | #13 | merged 2026-06-24 |
| US-05 | MVP      | awaiting-merge | 1  | #5 | base: main (rebased) · ContextMenu + RenameSheet + alert delete |
| US-06 | MVP      | todo   | 0         |    | |
| US-07 | MVP      | todo   | 0         |    | Foundation Models — prévoir fallback US-19 |
| US-08 | MVP      | todo   | 0         |    | Mode Courses = vue racine d'onglet (cf. design v0.2) |
| US-09 | MVP      | todo   | 0         |    | |
| US-10 | MVP      | todo   | 0         |    | iCloud container à configurer côté Apple Developer |
| US-11 | MVP      | todo   | 0         |    | |
| US-12 | MVP      | todo   | 0         |    | Widget extension à ajouter au project.yml (XcodeGen) |
| US-13 | MVP      | todo   | 0         |    | App Intents pour widget interactif |
| US-14 | MVP      | todo   | 0         |    | |
| US-19 | IA       | todo   | 0         |    | **À faire EN PREMIER** dans la phase IA (pose le protocole `LanguageModelService` et le mapping JSON) |
| US-15 | IA       | todo   | 0         |    | Derrière `LanguageModelService` mocké en CI, vrai modèle uniquement en dev iOS 26 |
| US-16 | IA       | todo   | 0         |    | Speech + Foundation Models via le protocole |
| US-17 | IA       | todo   | 0         |    | Entrée image — version 2026 du framework |
| US-18 | IA       | todo   | 0         |    | Liste « Inbox » par défaut, dépend du protocole posé par US-19 |
| US-20 | Bonus    | todo   | 0         |    | |
| US-21 | Bonus    | todo   | 0         |    | CloudKit Sharing — config compte requise |
