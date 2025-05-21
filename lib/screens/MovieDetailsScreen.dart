import 'package:flutter/material.dart';
import '../models/Movie.dart';
import '../viewmodels/MovieDetailsViewModel.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late final MovieDetailsViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = MovieDetailsViewModel();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  void _handleAddToFavorites() async {
    await viewModel.addToFavorites(widget.movie.id);

    final error = await viewModel.error.first;
    final added = await viewModel.added.first;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $error")),
      );
    } else if (added) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ajouté aux favoris !")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        actions: [
          StreamBuilder<bool>(
            stream: viewModel.isAdding,
            builder: (context, snapshot) {
              final isLoading = snapshot.data ?? false;
              return IconButton(
                icon: isLoading
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Icon(Icons.favorite_border),
                tooltip: "Ajouter aux favoris",
                onPressed: isLoading ? null : _handleAddToFavorites,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: widget.movie.posterPath.isNotEmpty
                  ? Image.network(
                "https://image.tmdb.org/t/p/w500${widget.movie.posterPath}",
                height: 300,
                fit: BoxFit.cover,
              )
                  : const Icon(Icons.movie, size: 100),
            ),
            const SizedBox(height: 16),
            Text(
              "Titre: ${widget.movie.title}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Sortie: ${widget.movie.releaseDate}"),
            const SizedBox(height: 8),
            Text("Note: ${widget.movie.voteAverage}/10"),
            const SizedBox(height: 16),
            const Text(
              "Synopsis:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.movie.overview, textAlign: TextAlign.justify),
          ],
        ),
      ),
    );
  }
}
