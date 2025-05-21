import 'package:rxdart/rxdart.dart';
import '../services/MovieService.dart';

class MovieDetailsViewModel {
  final BehaviorSubject<bool> _isAdding = BehaviorSubject.seeded(false);
  final BehaviorSubject<String?> _error = BehaviorSubject.seeded(null);
  final BehaviorSubject<bool> _added = BehaviorSubject.seeded(false);

  Stream<bool> get isAdding => _isAdding.stream;
  Stream<String?> get error => _error.stream;
  Stream<bool> get added => _added.stream;

  Future<void> addToFavorites(int movieId) async {
    _isAdding.add(true);
    _error.add(null);

    try {
      await MovieService.addMovieToFavorites(movieId);
      _added.add(true);
    } catch (e) {
      _error.add(e.toString());
    } finally {
      _isAdding.add(false);
    }
  }

  void dispose() {
    _isAdding.close();
    _error.close();
    _added.close();
  }
}
