import 'package:flutter/material.dart';
import 'dart:developer';
import '/services/currency_service.dart';

class CurrencyConverterViewModel extends ChangeNotifier {
  final CurrencyService _currencyService = CurrencyService();
  String fromAmount = '';
  String fromCurrency = '';
  String toCurrency = '';
  String toAmount = '';

  void fromAmountChanged(String value) {
    fromAmount = value;
    notifyListeners();
  }

  void fromCurrencyChanged(String value) {
    fromCurrency = value;
    notifyListeners();
  }

  void toCurrencyChanged(String value) {
    toCurrency = value;
    notifyListeners();
  }

  Future<void> convert() async {
    if (fromAmount.isEmpty || fromCurrency.isEmpty || toCurrency.isEmpty) return;

    try {
      final result = await _currencyService.convertCurrency(double.parse(fromAmount), fromCurrency, toCurrency);
      toAmount = result.toStringAsFixed(2);
      log('data: $toAmount');
      notifyListeners();
    } catch (e) {
      print('Error converting currency: $e');
    }
  }
}
