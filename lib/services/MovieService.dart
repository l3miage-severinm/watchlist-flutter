import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Movie.dart';

class MovieService {
  // TODO : centralize constants to avoid redundancy
  static const String _token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzRmOGVlNjUwMWFjMjlkZGFhNmE2OTBlNjJhMmE5NiIsIm5iZiI6MTc0MjM4MzY3MC44ODMwMDAxLCJzdWIiOiI2N2RhYWEzNmU4MzAyNTMzMjA2Y2FlOTgiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.EFzi4KselXU_YFtIW3SyRcGmQLKSHehHS-XIVdSkODs";
  static const String _baseUrl = "https://api.themoviedb.org";
  static const String _apiVersion = "3";

  static Future<List<Movie>> fetchMovies(String query) async {
    // TODO : use a middleware to set the headers
    final response = await http.get(
      Uri.parse("$_baseUrl/$_apiVersion/search/movie?language=fr-FR&query=$query"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode != 200)
      throw Exception('Échec du chargement des films');

    final decodedJson = json.decode(response.body);
    final List<dynamic> results = decodedJson['results'];
    return results.map((json) => Movie.fromJson(json)).toList();
  }
}
