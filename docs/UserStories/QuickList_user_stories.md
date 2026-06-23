# QuickList — User Stories

Format : *En tant que [rôle], je veux [action], afin de [bénéfice].*
Chaque story a des critères d'acceptation (CA) = la définition de « terminé ».
Priorités : **MVP** (Jours 1–7), **IA** (Foundation Models, on-device), **Bonus**.

---

## 1. Ajout ultra-rapide — MVP

**US-01 — Ajouter un item en une frappe**
En tant qu'utilisateur, je veux taper un texte dans un champ et valider avec Entrée, afin d'ajouter un item sans friction.
- [x] CA : un champ d'ajout est toujours visible en bas de l'écran de liste.
- [x] CA : après validation, l'item apparaît immédiatement dans la liste.
- [x] CA : le champ se vide mais garde le focus, pour permettre l'ajout en rafale.
- [x] CA : aucun pop-up ni formulaire intermédiaire n'apparaît.

**US-02 — Annuler un ajout par erreur**
En tant qu'utilisateur, je veux supprimer rapidement un item que je viens d'ajouter, afin de corriger une faute de frappe.
- CA : un balayage (swipe) sur l'item propose « Supprimer ».
- CA : la suppression est réversible (option « Annuler » pendant quelques secondes).

---

## 2. Listes multiples — MVP

**US-03 — Créer une liste**
En tant qu'utilisateur, je veux créer une liste avec un nom et un type (Courses, Tâches, Idées, Projets, Favoris), afin de séparer mes contextes.
- [x] CA : la création se fait en moins de 3 taps.
- [x] CA : le type choisi détermine le comportement par défaut (ex. type Courses → tri par rayon).

**US-04 — Voir toutes mes listes**
En tant qu'utilisateur, je veux voir toutes mes listes sur l'écran d'accueil, afin de naviguer rapidement.
- [x] CA : chaque liste affiche son nom, son icône et le nombre d'items non faits.
- [x] CA : un tap ouvre la liste.

**US-05 — Renommer ou supprimer une liste**
En tant qu'utilisateur, je veux renommer ou supprimer une liste, afin de garder mon espace propre.
- CA : la suppression demande une confirmation et supprime les items rattachés (cascade).
- CA : le renommage est instantané et synchronisé.

---

## 3. Tri intelligent — MVP

**US-06 — Choisir un mode de tri**
En tant qu'utilisateur, je veux trier une liste par ordre d'ajout, alphabétique ou par statut (fait / pas fait), afin de l'organiser selon mon besoin.
- CA : le mode de tri est accessible depuis la liste.
- CA : le tri choisi est mémorisé par liste (champ `sortMode` sur `TaskList`).

**US-07 — Tri par rayon intelligent (Foundation Models)**
En tant qu'utilisateur, je veux qu'une liste de courses regroupe automatiquement les articles par rayon, afin d'optimiser mon parcours en magasin.
- CA : à l'ajout, le rayon est déterminé par le modèle on-device (`@Generable`, voir § Foundation Models).
- CA : si Apple Intelligence est indisponible, repli sur un mapping local (JSON) → voir US-21.
- CA : un article non reconnu va dans une section « Autres ».

---

## 4. Mode Courses — MVP

**US-08 — Interface de courses dédiée**
En tant qu'utilisateur en magasin, je veux une vue avec de gros boutons et une coche rapide, afin de pointer mes articles d'une seule main.
- CA : la zone tappable de chaque article est large (confortable au pouce).
- CA : cocher un article le grise et le déplace en bas (ou le masque, selon réglage).

**US-09 — Corriger une catégorie et la mémoriser**
En tant qu'utilisateur, je veux déplacer un article mal classé vers le bon rayon et que l'app retienne mon choix, afin que le classement s'améliore avec le temps.
- CA : déplacer un article met à jour son `category`.
- CA : la correction est stockée dans `CategoryPreference` et a priorité sur le modèle IA lors des prochains ajouts du même article.

---

## 5. Synchronisation iCloud — MVP

**US-10 — Retrouver mes listes sur tous mes appareils**
En tant qu'utilisateur, je veux que mes listes soient synchronisées entre iPhone et Mac, afin de continuer là où je me suis arrêté.
- CA : une liste créée sur iPhone apparaît sur Mac sans action manuelle (SwiftData + CloudKit).
- CA : le modèle respecte les contraintes CloudKit (voir § Modèle de données).

**US-11 — Voir les modifications à jour**
En tant qu'utilisateur, je veux que cocher/ajouter/supprimer un item se propage automatiquement, afin d'éviter les doublons.
- CA : une modification se reflète sur l'autre appareil en quelques secondes (connexion active).
- CA : en cas de conflit, la version la plus récente est conservée.

---

## 6. Widgets iOS — MVP

**US-12 — Widget « Liste rapide »**
En tant qu'utilisateur, je veux un widget affichant une liste choisie, afin de la consulter sans ouvrir l'app.
- CA : le widget laisse choisir quelle liste afficher.
- CA : il affiche les premiers items non faits.

**US-13 — Cocher depuis le widget**
En tant qu'utilisateur, je veux cocher un item directement depuis le widget, afin de gagner du temps.
- CA : un tap marque l'item comme fait sans ouvrir l'app (widget interactif, App Intents).
- CA : l'état se synchronise avec l'app et iCloud.

**US-14 — Widget « Derniers items »**
En tant qu'utilisateur, je veux un widget montrant mes derniers items ajoutés (toutes listes), afin de garder un œil sur mes captures récentes.
- CA : le widget affiche les N items les plus récents avec leur liste d'origine.

---

## 7. Intelligence on-device — Foundation Models

> Prérequis : iOS 26+ / macOS 26+, appareil compatible Apple Intelligence, Xcode 26+.
> L'entrée image (US-17) nécessite la version 2026 du framework. Tout tourne en local, gratuit, sans connexion.

**US-15 — Capture instantanée, classification en arrière-plan**
En tant qu'utilisateur, je veux que l'ajout reste instantané et que l'IA classe l'item ensuite, afin de ne jamais attendre le modèle.
- CA : l'item est persité et affiché immédiatement, **avant** tout appel au modèle.
- CA : la classification (rayon, liste) se fait en tâche asynchrone et met l'item à jour quand elle aboutit.
- CA : l'app reste fluide même si le modèle est lent ou indisponible.

**US-16 — Import vocal → items structurés (Foundation Models)**
En tant qu'utilisateur, je veux dicter une phrase en vrac et obtenir des items séparés, afin de capturer les mains occupées.
- CA : la dictée (Speech) produit un texte, transmis au modèle.
- CA : le modèle découpe « du lait, des pâtes et appeler le dentiste » en items distincts (`@Generable`).
- CA : chaque item reçoit un rayon/une catégorie proposés.

**US-17 — Scan de ticket → produits (Foundation Models, image)**
En tant qu'utilisateur, je veux photographier un ticket de caisse pour en extraire les produits, afin de reconstruire une liste rapidement.
- CA : la photo est passée au modèle (entrée image / OCRTool).
- CA : les lignes de produits sont extraites en items structurés.
- CA : l'utilisateur valide la liste extraite avant ajout (l'IA propose, ne valide jamais seule).

**US-18 — Auto-routage vers la bonne liste**
En tant qu'utilisateur, je veux que l'app devine dans quelle liste classer une capture (Courses / Tâches / Idées), afin de ne pas choisir manuellement.
- CA : à l'ajout depuis une capture rapide globale, le modèle propose un type de liste.
- CA : si la confiance est faible, l'item reste dans une liste « Inbox » par défaut (jamais caché en silence).

**US-19 — Repli gracieux sans Apple Intelligence**
En tant qu'utilisateur sur un appareil non compatible, je veux que l'app fonctionne quand même, afin de ne pas être bloqué.
- CA : on teste la disponibilité du modèle au lancement (`SystemLanguageModel.availability`).
- CA : si indisponible → tri par mapping JSON local, et les fonctions IA sont masquées proprement.

---

## Bonus

**US-20 — Suggestions automatiques**
En tant qu'utilisateur, je veux des suggestions d'articles courants pendant la saisie, afin d'ajouter encore plus vite.
- CA : les suggestions apparaissent sous le champ ; un tap ajoute l'item.

**US-21 — Listes partagées**
En tant qu'utilisateur, je veux partager une liste, afin de gérer les courses à deux.
- CA : un partage CloudKit invite un collaborateur ; les modifications se synchronisent.

---

## Modèle de données (SwiftData) — corrigé

Deux modèles liés par une relation 1-N, **compatibles CloudKit**.
Corrections clés vs ton brouillon :
1. Suppression de `@Attribute(.unique)` → **interdit avec CloudKit**.
2. Toute propriété a une valeur par défaut, les relations sont optionnelles → **exigé par CloudKit**.
3. `ListItem` appartient à une `TaskList` via une relation inverse (fini le `category: String?` orphelin).
4. Les corrections de catégorie (US-09) vivent dans un modèle dédié `CategoryPreference`.

```swift
import SwiftData

enum ListType: String, Codable, CaseIterable {
    case groceries, tasks, ideas, projects, favorites
}

enum SortMode: String, Codable {
    case dateAdded, alphabetical, status
}

@Model
final class TaskList {
    var id: UUID = UUID()
    var name: String = ""
    var type: ListType = ListType.tasks
    var sortMode: SortMode = SortMode.dateAdded
    var createdAt: Date = Date()

    // Relation 1-N : une liste possède plusieurs items (cascade à la suppression)
    @Relationship(deleteRule: .cascade, inverse: \ListItem.list)
    var items: [ListItem]? = []

    init(name: String, type: ListType = .tasks) {
        self.name = name
        self.type = type
    }
}

@Model
final class ListItem {
    var id: UUID = UUID()
    var title: String = ""
    var isDone: Bool = false
    var category: String?            // rayon, rempli par Foundation Models
    var createdAt: Date = Date()

    // Relation inverse vers la liste parente (optionnelle = requis par CloudKit)
    var list: TaskList?

    init(title: String, category: String? = nil) {
        self.title = title
        self.category = category
    }
}

@Model
final class CategoryPreference {
    var normalizedName: String = ""  // ex. "tofu"
    var category: String = ""        // ex. "Crèmerie"
    var createdAt: Date = Date()

    init(normalizedName: String, category: String) {
        self.normalizedName = normalizedName
        self.category = category
    }
}
```

---

## Foundation Models — classification d'un article (US-07)

Le cœur de l'IA : `@Generable` force le modèle à répondre dans un type Swift valide (pas de parsing de JSON bancal).

```swift
import FoundationModels

@Generable
struct ItemClassification {
    @Guide(description: "Le rayon de magasin le plus adapté à l'article")
    @Guide(.anyOf([
        "Fruits & Légumes", "Boucherie", "Crèmerie", "Épicerie",
        "Surgelés", "Boulangerie", "Boissons", "Hygiène", "Autres"
    ]))
    var rayon: String
}

func classerArticle(_ titre: String) async throws -> String {
    // 1. La correction utilisateur (US-09) a toujours priorité — à vérifier AVANT d'appeler le modèle.
    // 2. Sinon, on interroge le modèle on-device.
    let session = LanguageModelSession()
    let reponse = try await session.respond(
        to: "Classe cet article de courses dans un rayon : \(titre)",
        generating: ItemClassification.self
    )
    return reponse.content.rayon   // garanti d'être une des valeurs autorisées
}
```

Flux recommandé (lié à US-15) : ajouter l'item → l'afficher → appeler `classerArticle` en arrière-plan → mettre à jour `item.category`.
