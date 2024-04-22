import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ActivityService {
  static final String _apiKey = dotenv.env['AMADEUS_API_KEY'] as String;
  static final String _apiSecret = dotenv.env['AMADEUS_API_SECRET'] as String;
  static const String _baseUrl = 'https://test.api.amadeus.com/v1/';
  static String? _accessToken;

  Future<void> _fetchAccessToken() async {
    const String url = 'https://test.api.amadeus.com/v1/security/oauth2/token';
    final String basicAuth =
        'Basic ${base64Encode(utf8.encode('$_apiKey:$_apiSecret'))}';

    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': basicAuth,
        },
        body: {
          'grant_type': 'client_credentials',
        });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _accessToken = responseData['access_token'];
    } else {
      throw Exception('Failed to fetch access token');
    }
  }

  Future<List<Map<String, dynamic>>> getActivityRecommendations(double latitude, double longitude) async {
    await _fetchAccessToken();

    final String poiUrl = '${_baseUrl}reference-data/locations/pois?latitude=$latitude&longitude=$longitude&radius=1';
    final String activitiesUrl = '${_baseUrl}shopping/activities?latitude=$latitude&longitude=$longitude&radius=1';

    log('coord: $latitude');
    log('coord: $longitude');

    final List<http.Response> responses = await Future.wait([
      http.get(Uri.parse(poiUrl), headers: {
        'Authorization': 'Bearer $_accessToken',
      }),
      http.get(Uri.parse(activitiesUrl), headers: {
        'Authorization': 'Bearer $_accessToken',
      }),
    ]);

    List<Map<String, dynamic>> recommendations = [];

    for (var response in responses) {
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'];
        for (var dataR in responseData){
          recommendations.add(dataR);
        }
      } else {
        throw Exception('Failed to load activity recommendations');
      }
    }

    return recommendations;
  }
}
