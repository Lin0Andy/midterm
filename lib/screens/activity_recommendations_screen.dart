import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '/view-models/activity_recommendations_viewmodel.dart';

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
  int _backgroundImageIndex = 0;
  List<String> _backgroundImages = [
    'assets/bg_img1.jpg',
    'assets/bg_img2.jpg',
    'assets/bg_img3.jpg',
  ];


  @override
  void initState() {
    super.initState();
    _checkLocationPermissionAndLoad();
    Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        _backgroundImageIndex =
            (_backgroundImageIndex + 1) % _backgroundImages.length;
      });
    });
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
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              _backgroundImages[_backgroundImageIndex],
              fit: BoxFit.cover,
            ),
          ),
          // Content
          _isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.purple))
              : _currentPosition != null ||
              (_latitudeController.text.isNotEmpty &&
                  _longitudeController.text.isNotEmpty)
              ? Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount:
                  _activityRecommendations.length + 1, // +1 for the header row
                  itemBuilder: (context, index) {
                    // Remaining code for list view items
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
                      style: TextStyle(color: Colors.purple), // Set text color
                      decoration: InputDecoration(
                        labelText: 'Latitude',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.purple), // Set border color
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _longitudeController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.purple), // Set text color
                      decoration: InputDecoration(
                        labelText: 'Longitude',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.purple), // Set border color
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _loadActivityRecommendations();
                },                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue, // Blue color for the button
                ),
                child: Text(
                  'Load Recommendations',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
