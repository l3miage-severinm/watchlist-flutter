import 'package:flutter/material.dart';

import '../models/Movie.dart';
import '../services/MovieService.dart';
import '../widgets/MovieTile.dart';

class FavoriteMoviesScreen extends StatelessWidget {
  const FavoriteMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: MovieService.fetchFavoriteMovies(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          final error = snapshot.error.toString();

          if (error.contains("non connecté") || error.contains("401")) {
            return const Center(
              child: Text(
                "Veuillez vous connecter pour voir vos films favoris.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return Center(
            child: Text(
              'Erreur : $error',
              style: const TextStyle(fontSize: 16),
            ),
          );

        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Aucun film favori trouvé.',
              style: TextStyle(fontSize: 16),
            ),
          );

        } else {
          final movies = snapshot.data!;
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) => MovieTile(movie: movies[index]),
          );
        }
      },
    );
  }
}
