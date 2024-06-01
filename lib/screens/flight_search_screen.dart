import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:midterm/view-models/flight_viewmodel.dart';

class FlightSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FlightViewModel>(
      create: (_) => FlightViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Search Flights"),
          backgroundColor: Colors.blueAccent,
        ),
        body: Consumer<FlightViewModel>(
          builder: (context, model, child) {
            if (model.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (model.destinations.isEmpty) {
              return Center(
                child: Text(
                  "No flights found or check logs for errors.",
                  style: TextStyle(fontSize: 18.0, color: Colors.blue[900]),
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: model.destinations.length,
              itemBuilder: (context, index) {
                var flight = model.destinations[index];
                return Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text(
                      flight.destination,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
                    ),
                    subtitle: Text(
                      "Price: \$${flight.price.toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.blue[700]),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
