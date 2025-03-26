import 'package:flutter/material.dart';
import '../models/Movie.dart';
import '../screens/MovieDetailsScreen.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;

  const MovieTile({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: movie.posterPath.isNotEmpty
          ? Image.network(
        "https://image.tmdb.org/t/p/w92${movie.posterPath}",
        width: 50,
        height: 75,
        fit: BoxFit.cover,
      )
          : const Icon(Icons.movie),
      title: Text(movie.title),
      subtitle: Text("Note: ${movie.voteAverage}"),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(movie: movie),
          ),
        );
      },
    );
  }
}
