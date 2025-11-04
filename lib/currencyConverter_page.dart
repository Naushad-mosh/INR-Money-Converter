import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'currency_provider.dart';

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final TextEditingController _inrController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text(
          "Currency Converter",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        elevation: 8,
        backgroundColor: Colors.blueAccent.shade200,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF283593), Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 500 : double.infinity,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 40 : 20,
                  vertical: isTablet ? 30 : 20,
                ),
                child: Container(
                  padding: EdgeInsets.all(isTablet ? 30 : 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Convert INR to USD & EUR",
                        style: TextStyle(
                          fontSize: isTablet ? 24 : 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isTablet ? 25 : 20),
                      TextField(
                        controller: _inrController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Enter Amount in INR',
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          prefixIcon: const Icon(
                            Icons.currency_rupee,
                            color: Colors.white70,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.white24,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 30 : 25),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blueAccent.shade700,
                          minimumSize: Size(double.infinity, isTablet ? 60 : 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                        ),
                        onPressed: currencyProvider.isLoading
                            ? null
                            : () {
                          final inrAmount =
                          double.tryParse(_inrController.text);
                          if (inrAmount != null && inrAmount > 0) {
                            currencyProvider.convertCurrency(inrAmount);

                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                Text('Please enter a valid amount'),
                              ),
                            );
                          }
                        },
                        child: currencyProvider.isLoading
                            ? const SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: Colors.blueAccent,
                            strokeWidth: 3,
                          ),
                        )
                            : Text(
                          'Convert',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet ? 20 : 17,
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 40 : 30),
                      if (currencyProvider.usdValue != null &&
                          currencyProvider.eurValue != null)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.all(isTablet ? 25 : 15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Column(
                            children: [
                              _buildCurrencyTile(
                                  "USD", currencyProvider.usdValue!, isTablet),
                              const Divider(color: Colors.white24, thickness: 1),
                              _buildCurrencyTile(
                                  "EUR", currencyProvider.eurValue!, isTablet),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyTile(String currency, double value, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          currency,
          style: TextStyle(
            fontSize: isTablet ? 24 : 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(
            fontSize: isTablet ? 24 : 20,
            color: Colors.greenAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
