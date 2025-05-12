import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthService {
  static const String _apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYzRmOGVlNjUwMWFjMjlkZGFhNmE2OTBlNjJhMmE5NiIsIm5iZiI6MTc0MjM4MzY3MC44ODMwMDAxLCJzdWIiOiI2N2RhYWEzNmU4MzAyNTMzMjA2Y2FlOTgiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.EFzi4KselXU_YFtIW3SyRcGmQLKSHehHS-XIVdSkODs";
  static const String _accessTokenUrl = "https://api.themoviedb.org/4/auth/access_token";
  static const String _requestTokenUrl = "https://api.themoviedb.org/4/auth/request_token";

  static Future<bool> isAuthenticated() async {
    return localStorage.getItem('access_token') != null;
  }

  static Future<String?> getAccessToken() async {
    return localStorage.getItem('access_token');
  }

  static Future<void> authenticate() async {
    final response = await http.post(
      Uri.parse(_requestTokenUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
    );

    if (response.statusCode == 200) {
      final requestToken = json.decode(response.body)['request_token'];
      final authUrl = "https://www.themoviedb.org/auth/access?request_token=$requestToken";

      try {
        await launchUrl(Uri.parse(authUrl));
      } catch (e) {
        throw "Impossible d'ouvrir l'URL d'authentification.";
      }

      http.Response? accessTokenResponse;
      do {
        await Future.delayed(Duration(seconds: 5));
        try {
          accessTokenResponse = await http.post(
            Uri.parse(_accessTokenUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_apiKey',
            },
            body: json.encode({'request_token': requestToken}),
          );
        }
        catch(e) {
          print(e);
        }
      } while (accessTokenResponse?.statusCode != 200);

      localStorage.setItem('access_token', jsonDecode(accessTokenResponse!.body)['access_token']);

    } else {
      throw "Erreur lors de la demande du request token.";
    }
  }

  static Future<void> logout() async {
    localStorage.removeItem('access_token');
  }
}
