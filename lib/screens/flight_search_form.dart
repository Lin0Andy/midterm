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
      appBar: AppBar(
        title: Text("Search Flights"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(_originController, 'Origin', Icons.flight_takeoff),
            SizedBox(height: 16.0),
            _buildTextField(_destinationController, 'Destination', Icons.flight_land),
            SizedBox(height: 16.0),
            _buildTextField(_departureDateController, 'Departure Date', Icons.date_range),
            SizedBox(height: 16.0),
            _buildTextField(_returnDateController, 'Return Date', Icons.date_range),
            SizedBox(height: 16.0),
            _buildTextField(_adultsController, 'Adults', Icons.person, isNumeric: true),
            SizedBox(height: 32.0),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                textStyle: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isNumeric = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.blue[50],
      ),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
    );
  }
}
