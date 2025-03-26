import 'package:flutter/material.dart';
import '../models/Movie.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: movie.posterPath.isNotEmpty
                  ? Image.network(
                "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                height: 300,
                fit: BoxFit.cover,
              )
                  : const Icon(Icons.movie, size: 100),
            ),
            const SizedBox(height: 16),
            Text(
              "Titre: ${movie.title}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Sortie: ${movie.releaseDate}"),
            const SizedBox(height: 8),
            Text("Note: ${movie.voteAverage}/10"),
            const SizedBox(height: 16),
            const Text(
              "Synopsis:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(movie.overview, textAlign: TextAlign.justify),
          ],
        ),
      ),
    );
  }
}
