import 'package:flutter/material.dart';
import 'currency_service.dart';

class CurrencyProvider extends ChangeNotifier {
  final CurrencyService _currencyService = CurrencyService();

  double? usdValue;
  double? eurValue;
  bool isLoading = false;

  Future<void> convertCurrency(double inrAmount) async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await _currencyService.fetchRates();
      final usdRate = data['rates']['USD'];
      final eurRate = data['rates']['EUR'];

      usdValue = inrAmount * usdRate;
      eurValue = inrAmount * eurRate;
    } catch (e) {
      debugPrint('Error: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}
