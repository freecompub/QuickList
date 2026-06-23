## Description courte

QuickList est une application de listes ultra‑rapide pensée pour aller droit au but.  
L’ajout d’un item se fait en une seconde, sans menus ni friction.  
Les listes sont simples, propres et synchronisées via iCloud entre iPhone, iPad et Mac.  
Le mode Courses trie automatiquement les produits par rayon pour gagner du temps.  
L’interface minimaliste, inspirée d’Apple, rend l’app agréable et instantanée.  
L’utilisateur peut créer autant de listes qu’il veut : tâches, idées, projets, courses.  
Chaque action est fluide : taper, valider, cocher, archiver.  
QuickList privilégie la vitesse, la simplicité et l’efficacité au quotidien.

---

## Stack technique

- Swift 6  
- SwiftData  
- Compatibilité : iOS 17 / iPadOS 17 / macOS 14  
- XcodeGen pour la configuration du projet  
- SwiftLog pour la journalisation  

---

## Architecture

- Architecture MVVM  
- Architecture modulaire et découplée  
- Approche protocol‑oriented  
- Séparation stricte : `core`, `services`, `api`, `ui`, `tests`  
- Aucun fichier ne doit dépasser 300 lignes sans justification  
- Tout code réutilisable doit être placé dans un module SPM  

---

## Naming

- Noms explicites, jamais d’abréviations obscures  
- Fonctions : verbes  
- Modules : concepts métier  
- Pas de suffixes génériques (`Manager`, `Helper`) sauf nécessité claire  

---

## Conventions de documentation

Claude doit produire systématiquement :

- Un README par module expliquant son rôle  
- Des commentaires clairs pour les fonctions complexes  
- Un fichier `architecture.md` décrivant les choix structurants  
- Un fichier `decisions.md` listant les décisions techniques importantes  
- Une documentation API (DocC ou équivalent)  

---

## Workflow de développement d’une User Story

1. Lire l’US  
2. Déterminer le module concerné (nouveau ou existant)  
3. Générer le code  
4. Générer les tests unitaires  
5. Générer la documentation (DocC, README, etc.)  
6. S’assurer que tous les tests passent  
7. Vérifier qu’il n’y a aucune erreur ni warning SwiftLint  
8. Mettre à jour la ROADMAP et l’US avant chaque PR  
9. S’assurer que le Design System est correctement utilisé  

---

## Tâches obligatoires

- Créer un module générique pour l’analytics  
- Logger toutes les erreurs  
- Utiliser le module analytics pour tracer les choix de l’utilisateur  
- Maintenir à jour la liste des tags analytics dans `docs/TagManager.md` 

---

## Interdictions explicites

Claude ne doit jamais :

- Pousser sur la branche `main`  
- Pousser sans s’assurer que les applications buildent  
- Modifier l’architecture  
- Créer plusieurs classes ou structures dans un même fichier  
- Ignorer les conventions définies dans ce document  
- Uploader des fichiers sur le disque sans autorisation  
- Committer des secrets, clés ou mots de passe  
- Créer des migrations destructives sans confirmation explicite  
- Hardcoder des couleurs ou des strings directement dans le code  
- Supprimer une feature sans consentement explicite de l’utilisateur  

### Règles strictes de Pull Request

- Interdiction absolue de merger une PR sans autorisation explicite de l’utilisateur  
  - “ci ok”, “tests verts”, “review ok” ne sont pas des autorisations  
  - Chaque PR nécessite un GO explicite : “oui merge”, “tu peux merge”, “merge-la”  
  - L’autorisation ne se reporte jamais sur la PR suivante  
- Interdiction de merger si la CI contient la moindre erreur  
- Interdiction absolue de pousser directement sur `main`, même pour la documentation  
  - Toute modification passe par : branche → PR → CI verte → autorisation → merge  

---

## Roadmap & backlog

- Roadmap User Stories : `docs/ROADMAP.md`  
- User Stories : `docs/UserStories/`  
- Décisions architecturales : `docs/architecture/` + ADR  