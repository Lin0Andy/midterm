import '/services/activity_service.dart';

class ActivityRecommendationsViewModel {
  final ActivityService _activityService = ActivityService();

  Future<Iterable<Map<String, dynamic>>> getActivityRecommendations(double latitude, double longitude) async {
    try {
      return await _activityService.getActivityRecommendations(latitude, longitude);
    } catch (e) {
      // Handle error
      print('Error fetching activity recommendations: $e');
      return [];
    }
  }
}
