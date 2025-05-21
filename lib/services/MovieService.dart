import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Movie.dart';
import 'AuthService.dart';

class MovieService {

  static const String _token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzRmOGVlNjUwMWFjMjlkZGFhNmE2OTBlNjJhMmE5NiIsIm5iZiI6MTc0MjM4MzY3MC44ODMwMDAxLCJzdWIiOiI2N2RhYWEzNmU4MzAyNTMzMjA2Y2FlOTgiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.EFzi4KselXU_YFtIW3SyRcGmQLKSHehHS-XIVdSkODs";
  static const String _baseUrl = "https://api.themoviedb.org/3";

  static Future<List<Movie>> fetchMovies(String query) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/search/movie?language=fr-FR&query=$query"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      final List<dynamic> results = decodedJson['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des films');
    }
  }

  static Future<List<Movie>> fetchFavoriteMovies() async {

    final accountId = AuthService.getAccountId();
    final response = await http.get(
      Uri.parse("$_baseUrl/account/$accountId/favorite/movies?language=fr-FR"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      final List<dynamic> results = decodedJson['results'];
      return results.map((json) => Movie.fromJson(json)).toList();

    } else {
      throw Exception('Erreur lors du chargement des favoris : ${response.statusCode}');
    }
  }

  static Future<void> addMovieToFavorites(int movieId) async {
    final response = await _callFavoriteAPI(true, movieId);
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception("Échec de l'ajout en favori (${response.statusCode})");
    }
  }

  static Future<void> removeMovieFromFavorites(int movieId) async {
    final response = await _callFavoriteAPI(false, movieId);
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception("Échec de la suppression des favoris (${response.statusCode})");
    }
  }

  static Future<bool> isFavorite(int movieId) async {
    final List<Movie> moviesList = await fetchFavoriteMovies();
    for (Movie movie in moviesList) {
      if (movie.id == movieId) {
        return true;
      }
    }
    return false;
  }

  static Future<http.Response> _callFavoriteAPI(bool addToFavorites, int movieId) async {
    final accountId = AuthService.getAccountId();
    return await http.post(
      Uri.parse("$_baseUrl/account/$accountId/favorite"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token'
      },
      body: json.encode({
        'media_type': 'movie',
        'media_id': movieId,
        'favorite': addToFavorites
      }),
    );
  }
}
