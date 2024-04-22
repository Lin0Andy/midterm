import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String apiKey = 'd56a3f6d9bd7ddf617438391';
  static const String apiUrl = 'https://v6.exchangerate-api.com/v6/$apiKey/latest/';

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
