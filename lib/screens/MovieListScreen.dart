import 'package:flutter/material.dart';
import '../models/Movie.dart';
import '../widgets/CustomSearchBar.dart';
import '../widgets/MovieTile.dart';
import '../viewmodels/MovieListViewModel.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final viewModel = MovieListViewModel();

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSearchBar(onSearch: viewModel.searchMovies),
        Expanded(
          child: StreamBuilder<bool>(
            stream: viewModel.isLoading,
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return const Center(child: CircularProgressIndicator());
              }
              return StreamBuilder<bool>(
                stream: viewModel.hasSearched,
                builder: (context, hasSearchedSnapshot) {
                  final hasSearched = hasSearchedSnapshot.data ?? false;
                  if (!hasSearched) {
                    return const SizedBox.shrink();
                  }
                  return StreamBuilder<List<Movie>>(
                    stream: viewModel.movies,
                    builder: (context, moviesSnapshot) {
                      final movies = moviesSnapshot.data ?? [];
                      if (movies.isEmpty) {
                        return const Center(child: Text("Aucun film trouvé"));
                      }
                      return ListView.builder(
                        itemCount: movies.length,
                        itemBuilder: (context, index) => MovieTile(movie: movies[index]),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
