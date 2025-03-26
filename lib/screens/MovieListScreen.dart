import 'package:flutter/material.dart';
import '../models/Movie.dart';
import '../services/MovieService.dart';
import '../widgets/MovieTile.dart';
import '../widgets/CustomSearchBar.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  List<Movie> movies = [];
  bool isLoading = false;

  void searchMovies(String query) async {
    setState(() => isLoading = true);

    try {
      final results = await MovieService.fetchMovies(query);
      setState(() {
        movies = results;
        isLoading = false;
      });
    } catch (error) {
      setState(() => isLoading = false);
      print("Erreur lors du chargement des films : $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rechercher un film")),
      body: Column(
        children: [
          CustomSearchBar(onSearch: searchMovies), // Utilisation de la SearchBar
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : movies.isEmpty
                ? const Center(child: Text("Aucun film trouvé"))
                : ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return MovieTile(movie: movies[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
