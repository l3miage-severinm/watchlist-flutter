# Watchlist

## Généralités

Application de recherche et gestion de films
Communique avec TMDB via API
Fonctionnalités :
- Rechercher un film
- Accéder aux détails de ce film
- Ajouter un film aux favoris
- Supprimer un film des favoris

Les fonctionnalités 3 - 4 - 5 demandent d’être connecté
  
## Architecture

### Séparation des vues et des vuesModels
Intelligence dans le vueModel, de manière similaire à Angular.
Utilisation de rxdart pour plus de réactivité (et facilité de développement)

### Streambuilders
Consomme les données envoyées par un stream présent dans un viewModel
Permet d’éviter de devoir mettre à jour un widget manuellement
On retrouve une logique similaire aux observables de rxjs

## Ce qu'il reste à faire

### Listes
- Ajouter un film à une liste
- Supprimer un film d’une liste
- Créer/Supprimer une liste

### Notation
- Ajouter/modifier une note à un film
- Visualiser la moyenne et répartition des notes d’un film

### Commentaires
- Ajouter/Modifier/Supprimer

