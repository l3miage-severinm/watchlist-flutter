import 'package:flutter/material.dart';

import '../models/Movie.dart';
import '../viewmodels/FavoriteMoviesViewModel.dart';
import '../widgets/MovieTile.dart';
import '../navigation/routeObserver.dart';

class FavoriteMoviesScreen extends StatefulWidget {
  const FavoriteMoviesScreen({super.key});

  @override
  State<FavoriteMoviesScreen> createState() => _FavoriteMoviesScreenState();
}

class _FavoriteMoviesScreenState extends State<FavoriteMoviesScreen> with RouteAware {
  final viewModel = FavoriteMoviesViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.fetchFavorites();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    viewModel.fetchFavorites();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: viewModel.isLoading,
      builder: (context, loadingSnapshot) {
        final isLoading = loadingSnapshot.data ?? false;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return StreamBuilder<String?>(
          stream: viewModel.error,
          builder: (context, errorSnapshot) {
            final error = errorSnapshot.data;

            if (error != null) {
              return Center(
                child: Text(
                  'Erreur : $error',
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }

            return StreamBuilder<List<Movie>>(
              stream: viewModel.movies,
              builder: (context, movieSnapshot) {
                final movies = movieSnapshot.data ?? [];

                if (movies.isEmpty) {
                  return const Center(
                    child: Text(
                      'Aucun film favori trouvé.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
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
    );
  }
}
