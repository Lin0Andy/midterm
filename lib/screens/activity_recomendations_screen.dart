import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '/viewmodels/activity_recommendations_viewmodel.dart';

class ActivityRecommendationsScreen extends StatefulWidget {
  @override
  _ActivityRecommendationsScreenState createState() => _ActivityRecommendationsScreenState();
}

class _ActivityRecommendationsScreenState extends State<ActivityRecommendationsScreen> {
  final ActivityRecommendationsViewModel _viewModel = ActivityRecommendationsViewModel();
  List<Map<String, dynamic>> _activityRecommendations = [];
  bool _isLoading = true;
  TextEditingController _latitudeController = TextEditingController();
  TextEditingController _longitudeController = TextEditingController();
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _checkLocationPermissionAndLoad();
  }

  Future<void> _checkLocationPermissionAndLoad() async {
    LocationPermission permission = await Geolocator.checkPermission();
    log('permission: $permission');
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      _loadActivityRecommendations();
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        log('data: $position');
        _currentPosition = position;
        _latitudeController.text = position.latitude.toString();
        _longitudeController.text = position.longitude.toString();
        _isLoading = false;
      });
      _loadActivityRecommendations();
    } catch (e) {
      print('Error getting current location: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadActivityRecommendations() async {
    try {
      final latitude = _currentPosition?.latitude ?? double.tryParse(_latitudeController.text) ?? 0.0;
      final longitude = _currentPosition?.longitude ?? double.tryParse(_longitudeController.text) ?? 0.0;
      final recommendations = await _viewModel.getActivityRecommendations(latitude, longitude);

      final activities = recommendations.where((recommendation) => recommendation['type'] == 'activity').toList();
      final pointsOfInterest = recommendations.where((recommendation) => recommendation['type'] == 'location').toList();

      setState(() {
        _activityRecommendations = [...activities, ...pointsOfInterest];
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading activity recommendations: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Recommendations'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _currentPosition != null || (_latitudeController.text.isNotEmpty && _longitudeController.text.isNotEmpty)
          ? Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _activityRecommendations.length + 1, // +1 for the header row
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Header row
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Text('Description/Category', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Text('Rank/Price', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                }

                final recommendation = _activityRecommendations[index - 1];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Text(recommendation['name']),
                      ),
                      Expanded(
                        child: Text(recommendation['type'] == 'activity' ? recommendation['description'] : recommendation['category']),
                      ),
                      Expanded(
                        child: Text(recommendation['type'] == 'activity' ? '${recommendation['price']['amount']} ${recommendation['price']['currencyCode']}' : 'Rank: ${recommendation['rank']}'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      )
          : Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _latitudeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Latitude'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _longitudeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Longitude'),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              _loadActivityRecommendations();
            },
            child: Text('Load Recommendations'),
          ),
        ],
      ),
    );
  }
}
