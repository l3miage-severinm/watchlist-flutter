import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_flutter/models/CustomList.dart';
import '../services/AuthService.dart';

class ListsService {
  // TODO : centralize constants to avoid redundancy
  static const String _apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzRmOGVlNjUwMWFjMjlkZGFhNmE2OTBlNjJhMmE5NiIsIm5iZiI6MTc0MjM4MzY3MC44ODMwMDAxLCJzdWIiOiI2N2RhYWEzNmU4MzAyNTMzMjA2Y2FlOTgiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.EFzi4KselXU_YFtIW3SyRcGmQLKSHehHS-XIVdSkODs";
  static const String _baseUrl = "https://api.themoviedb.org/4";

  static Future<List<CustomList>> getUserLists() async {

    String? accountId = await AuthService.getAccountId();

    if (accountId == null || accountId.isEmpty)
      throw "account id is not set";

    // TODO : use a middleware to set the headers
    final response = await http.get(
      Uri.parse("$_baseUrl/account/$accountId/lists"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
    );

    if (response.statusCode != 200)
      throw Exception('Échec du chargement des listes');

    final decodedJson = json.decode(response.body);
    final List<dynamic> results = decodedJson['results'];
    return results.map((json) => CustomList.fromJson(json)).toList();
  }
}