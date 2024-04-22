import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CurrencyService {
  static final String apiKey =  dotenv.env['ER_API_KEY'] as String;
  static final String apiUrl = 'https://v6.exchangerate-api.com/v6/$apiKey/latest/';

  Future<double> convertCurrency(double amount, String fromCurrency, String toCurrency) async {
    try {
      var fromC = fromCurrency.toUpperCase();
      var toC = toCurrency.toUpperCase();
      final response = await http.get(Uri.parse('$apiUrl$fromC'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final conversionRate = data['conversion_rates'][toC];
        var final_amount = amount * conversionRate;
        log('conversion: $final_amount');
        return final_amount;
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      throw Exception('Error converting currency: $e');
    }
  }
}
