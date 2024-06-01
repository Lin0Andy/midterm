import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:midterm/view-models/flight_viewmodel.dart';

class FlightSearchForm extends StatefulWidget {
  @override
  _FlightSearchFormState createState() => _FlightSearchFormState();
}

class _FlightSearchFormState extends State<FlightSearchForm> {
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _departureDateController = TextEditingController();
  final _returnDateController = TextEditingController();
  final _adultsController = TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Flights")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _originController,
              decoration: InputDecoration(labelText: 'Origin'),
            ),
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(labelText: 'Destination'),
            ),
            TextField(
              controller: _departureDateController,
              decoration: InputDecoration(labelText: 'Departure Date'),
            ),
            TextField(
              controller: _returnDateController,
              decoration: InputDecoration(labelText: 'Return Date'),
            ),
            TextField(
              controller: _adultsController,
              decoration: InputDecoration(labelText: 'Adults'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final origin = _originController.text;
                final destination = _destinationController.text;
                final departureDate = _departureDateController.text;
                final returnDate = _returnDateController.text;
                final adults = int.tryParse(_adultsController.text) ?? 1;

                Provider.of<FlightViewModel>(context, listen: false).fetchFlightDestinations(
                  origin,
                  destination,
                  departureDate,
                  returnDate: returnDate.isNotEmpty ? returnDate : null,
                  adults: adults,
                );

                Navigator.pushNamed(context, '/flights_results');
              },
              child: Text('Search Flights'),
            ),
          ],
        ),
      ),
    );
  }
}
