import 'package:rxdart/rxdart.dart';
import '../services/MovieService.dart';

class MovieDetailsViewModel {
  final BehaviorSubject<bool> _isAdding = BehaviorSubject.seeded(false);
  final BehaviorSubject<String?> _error = BehaviorSubject.seeded(null);
  final BehaviorSubject<bool> _added = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> _isFavorite = BehaviorSubject.seeded(false);

  Stream<bool> get isAdding => _isAdding.stream;
  Stream<String?> get error => _error.stream;
  Stream<bool> get added => _added.stream;
  Stream<bool> get isFavorite => _isFavorite.stream;

  Future<void> toggleFavoriteStatus(int movieId) async {
    _isAdding.add(true);
    _error.add(null);

    try {
      final currentlyFavorite = _isFavorite.value;

      if (currentlyFavorite) {
        await MovieService.removeMovieFromFavorites(movieId);
        _isFavorite.add(false);
      } else {
        await MovieService.addMovieToFavorites(movieId);
        _isFavorite.add(true);
      }
    } catch (e) {
      _error.add(e.toString());
    } finally {
      _isAdding.add(false);
    }
  }

  Future<void> loadFavoriteStatus(int movieId) async {
    try {
      final result = await MovieService.isFavorite(movieId);
      _isFavorite.add(result);
    } catch (e) {
      _error.add(e.toString());
    }
  }

  void dispose() {
    _isAdding.close();
    _error.close();
    _added.close();
    _isFavorite.close();
  }
}
