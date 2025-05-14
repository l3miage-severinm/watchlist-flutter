import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Movie.dart';
import '../widgets/CustomSearchBar.dart';
import '../widgets/MovieTile.dart';
import '../viewmodels/MovieListViewModel.dart';
import '../viewmodels/AuthViewModel.dart';

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
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rechercher un film"),
        actions: [
          StreamBuilder<bool>(
            stream: authViewModel.isAuthenticatedStream,
            builder: (context, snapshot) {
              final auth = snapshot.data ?? false;
              return TextButton(
                onPressed: authViewModel.handleAuth,
                child: Text(auth ? "Se déconnecter" : "Se connecter"),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
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
          ),
          StreamBuilder<bool>(
            stream: authViewModel.isAuthenticatingStream,
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return Container(
                  color: Colors.black54,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
