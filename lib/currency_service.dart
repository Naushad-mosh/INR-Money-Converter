import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  final String baseUrl = 'https://api.exchangerate-api.com/v4/latest/INR';

  Future<Map<String, dynamic>> fetchRates() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch currency rates');
    }
  }
}


