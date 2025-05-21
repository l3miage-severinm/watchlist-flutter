import 'package:rxdart/rxdart.dart';
import '../models/Movie.dart';
import '../services/MovieService.dart';

class FavoriteMoviesViewModel {

  final BehaviorSubject<List<Movie>> _movies = BehaviorSubject.seeded([]);
  final BehaviorSubject<bool> _isLoading = BehaviorSubject.seeded(false);
  final BehaviorSubject<String?> _error = BehaviorSubject.seeded(null);

  Stream<List<Movie>> get movies => _movies.stream;
  Stream<bool> get isLoading => _isLoading.stream;
  Stream<String?> get error => _error.stream;

  void fetchFavorites() async {
    _isLoading.add(true);
    _error.add(null);

    try {
      final result = await MovieService.fetchFavoriteMovies();
      _movies.add(result);
    } catch (e) {
      _error.add(e.toString());
      _movies.add([]); // vide en cas d’erreur
    } finally {
      _isLoading.add(false);
    }
  }

  void dispose() {
    _movies.close();
    _isLoading.close();
    _error.close();
  }
}
