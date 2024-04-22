import 'package:flutter/material.dart';
import '/screens/booking/hotel_recommendations_screen.dart';
import '/screens/booking/hotel_search_screen.dart';
import '/screens/booking/hotel_details_screen.dart';
import 'package:provider/provider.dart';
import '/screens/home_screen.dart';
import '/screens/currency_converter_screen.dart';
import '/viewmodels/currency_converter_viewmodel.dart';
import '/screens/activity_recomendations_screen.dart';
import '/viewmodels/activity_recommendations_viewmodel.dart';
import '/viewmodels/hotel_viewmodel.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Companion App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Set HomeScreen as the initial route
      initialRoute: '/',
      home: Container(
        color: Colors.red,
        child: HomeScreen(),
      ),
      routes: {
        '/currency_converter': (context) => CurrencyConverterScreen(
          viewModel: CurrencyConverterViewModel(),
        ),
        '/activity_recommendation': (context) => ActivityRecommendationsScreen(),
      },
    );
  }
}
