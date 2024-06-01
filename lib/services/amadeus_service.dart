import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AmadeusService {
  static String? token;
  static DateTime? tokenExpiry;

  static Future<void> generateAccessToken() async {
    try {
      var clientId = dotenv.env['AMADEUS_CLIENT_ID'];
      var clientSecret = dotenv.env['AMADEUS_CLIENT_SECRET'];

      if (clientId == null || clientSecret == null) {
        throw Exception('Client ID or Client Secret is not available.');
      }

      var response = await http.post(
          Uri.parse("https://test.api.amadeus.com/v1/security/oauth2/token"),
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: "grant_type=client_credentials&client_id=$clientId&client_secret=$clientSecret"
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        token = data['access_token'];
        int expiresIn = data['expires_in'];
        tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));
      } else {
        throw Exception('Failed to obtain access token');
      }
    } catch (e) {
      throw Exception('Error in generating access token: $e');
    }
  }

  static bool isTokenExpired() {
    if (tokenExpiry == null) {
      return true;
    }
    return DateTime.now().isAfter(tokenExpiry!);
  }

  static Future<void> ensureToken() async {
    if (token == null || isTokenExpired()) {
      await generateAccessToken();
    }
  }
}
