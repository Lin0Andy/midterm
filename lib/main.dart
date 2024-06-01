import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/currency_converter_screen.dart';
import 'screens/activity_recommendations_screen.dart';
import 'screens/flight_search_screen.dart';
import 'view-models/currency_converter_viewmodel.dart';
import 'package:provider/provider.dart';
import 'view-models/flight_viewmodel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/flight_search_form.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  print("Amadeus Client ID: ${dotenv.env['AMADEUS_CLIENT_ID']}");
  print("Amadeus Client Secret: ${dotenv.env['AMADEUS_CLIENT_SECRET']}");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FlightViewModel()),
      ],
      child: MaterialApp(
        title: 'Travel Companion App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
        routes: {
          '/currency_converter': (context) => CurrencyConverterScreen(
            viewModel: CurrencyConverterViewModel(),
          ),
          '/activity_recommendation': (context) => ActivityRecommendationsScreen(),
          '/flight_search_form': (context) => FlightSearchForm(),
          '/flights_results': (context) => FlightSearchScreen(),
        },
      ),
    );
  }
}
