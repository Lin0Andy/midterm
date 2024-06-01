import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:midterm/models/flight_destination.dart';
import 'package:midterm/services/amadeus_service.dart';

class FlightViewModel extends ChangeNotifier {
  bool isLoading = false;
  List<FlightDestination> destinations = [];

  Future<void> fetchFlightDestinations(String origin, String destination, String departureDate, {String? returnDate, required int adults}) async {
    isLoading = true;
    notifyListeners();

    try {
      await AmadeusService.ensureToken();
      final url = 'https://test.api.amadeus.com/v2/shopping/flight-offers?originLocationCode=$origin&destinationLocationCode=$destination&departureDate=$departureDate&adults=$adults${returnDate != null ? '&returnDate=$returnDate' : ''}';
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer ${AmadeusService.token}',
      });

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          destinations = (data['data'] as List).map((e) => FlightDestination.fromJson(e)).toList();
        } catch (e) {
          print('Error parsing flight destinations: $e');
        }
      } else {
        print('Error fetching flight destinations: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching flight destinations: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}
