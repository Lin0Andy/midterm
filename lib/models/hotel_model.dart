class Hotel {
  final String name;
  final String description;
  final double price;
  final String currency;

  Hotel({required this.name, required this.description, required this.price, required this.currency});

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      name: json['hotel']['name'],
      description: json['hotel']['description']['text'],
      price: json['offers'][0]['price']['total'],
      currency: json['offers'][0]['price']['currency'],
    );
  }
}
