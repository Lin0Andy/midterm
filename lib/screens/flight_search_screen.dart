import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:midterm/view-models/flight_viewmodel.dart';

class FlightSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FlightViewModel>(
      create: (_) => FlightViewModel(),
      child: Scaffold(
        appBar: AppBar(title: Text("Search Flights")),
        body: Consumer<FlightViewModel>(
          builder: (context, model, child) {
            if (model.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (model.destinations.isEmpty) {
              return Center(child: Text("No flights found or check logs for errors."));
            }
            return ListView.builder(
              itemCount: model.destinations.length,
              itemBuilder: (context, index) {
                var flight = model.destinations[index];
                return ListTile(
                  title: Text(flight.destination),
                  subtitle: Text("Price: \$${flight.price.toStringAsFixed(2)}"),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
