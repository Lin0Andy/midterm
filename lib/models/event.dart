class Event {
  final String title;
  final DateTime date;
  final String location;
  final String notes;

  Event({
    required this.title,
    required this.date,
    required this.location,
    this.notes = '',
  });
}
