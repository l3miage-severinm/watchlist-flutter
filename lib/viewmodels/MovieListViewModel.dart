import 'package:rxdart/rxdart.dart';
import '../models/Movie.dart';
import '../services/MovieService.dart';

class MovieListViewModel {
  final BehaviorSubject<List<Movie>> movies = BehaviorSubject.seeded([]);
  final BehaviorSubject<bool> isLoading = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> hasSearched = BehaviorSubject.seeded(false);

  void searchMovies(String query) async {
    isLoading.add(true);
    hasSearched.add(true);
    try {
      final results = await MovieService.fetchMovies(query);
      movies.add(results);
    } catch (e) {
      print("Erreur : $e");
    } finally {
      isLoading.add(false);
    }
  }

  void dispose() {
    movies.close();
    isLoading.close();
    hasSearched.close();
  }
}
