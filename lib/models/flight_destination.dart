class FlightDestination {
  final String id;
  final bool instantTicketingRequired;
  final bool nonHomogeneous;
  final bool oneWay;
  final String lastTicketingDate;
  final int numberOfBookableSeats;
  final List<Itinerary> itineraries;
  final double price;

  FlightDestination({
    required this.id,
    required this.instantTicketingRequired,
    required this.nonHomogeneous,
    required this.oneWay,
    required this.lastTicketingDate,
    required this.numberOfBookableSeats,
    required this.itineraries,
    required this.price,
  });

  factory FlightDestination.fromJson(Map<String, dynamic> json) {
    return FlightDestination(
      id: json['id'] ?? '',
      instantTicketingRequired: json['instantTicketingRequired'] ?? false,
      nonHomogeneous: json['nonHomogeneous'] ?? false,
      oneWay: json['oneWay'] ?? false,
      lastTicketingDate: json['lastTicketingDate'] ?? '',
      numberOfBookableSeats: json['numberOfBookableSeats'] ?? 0,
      itineraries: (json['itineraries'] as List<dynamic>?)
          ?.map((itinerary) => Itinerary.fromJson(itinerary))
          .toList() ??
          [],
      price: json['price'] != null ? double.tryParse(json['price']['total'].toString()) ?? 0.0 : 0.0,
    );
  }

  // Add a method to get the formatted destination
  String get destination {
    if (itineraries.isNotEmpty && itineraries[0].segments.isNotEmpty) {
      return itineraries[0].segments.last.arrival.iataCode;
    }
    return '';
  }
}

class Itinerary {
  final String duration;
  final List<Segment> segments;

  Itinerary({
    required this.duration,
    required this.segments,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      duration: json['duration'] ?? '',
      segments: (json['segments'] as List<dynamic>?)
          ?.map((segment) => Segment.fromJson(segment))
          .toList() ??
          [],
    );
  }
}

class Segment {
  final Departure departure;
  final Arrival arrival;
  final String carrierCode;
  final String number;
  final Aircraft aircraft;
  final Operating operating;
  final String duration;
  final int numberOfStops;
  final bool blacklistedInEU;

  Segment({
    required this.departure,
    required this.arrival,
    required this.carrierCode,
    required this.number,
    required this.aircraft,
    required this.operating,
    required this.duration,
    required this.numberOfStops,
    required this.blacklistedInEU,
  });

  factory Segment.fromJson(Map<String, dynamic> json) {
    return Segment(
      departure: Departure.fromJson(json['departure'] ?? {}),
      arrival: Arrival.fromJson(json['arrival'] ?? {}),
      carrierCode: json['carrierCode'] ?? '',
      number: json['number'] ?? '',
      aircraft: Aircraft.fromJson(json['aircraft'] ?? {}),
      operating: Operating.fromJson(json['operating'] ?? {}),
      duration: json['duration'] ?? '',
      numberOfStops: json['numberOfStops'] ?? 0,
      blacklistedInEU: json['blacklistedInEU'] ?? false,
    );
  }
}

class Departure {
  final String iataCode;
  final String at;

  Departure({
    required this.iataCode,
    required this.at,
  });

  factory Departure.fromJson(Map<String, dynamic> json) {
    return Departure(
      iataCode: json['iataCode'] ?? '',
      at: json['at'] ?? '',
    );
  }
}

class Arrival {
  final String iataCode;
  final String at;

  Arrival({
    required this.iataCode,
    required this.at,
  });

  factory Arrival.fromJson(Map<String, dynamic> json) {
    return Arrival(
      iataCode: json['iataCode'] ?? '',
      at: json['at'] ?? '',
    );
  }
}

class Aircraft {
  final String code;

  Aircraft({required this.code});

  factory Aircraft.fromJson(Map<String, dynamic> json) {
    return Aircraft(code: json['code'] ?? '');
  }
}

class Operating {
  final String carrierCode;

  Operating({required this.carrierCode});

  factory Operating.fromJson(Map<String, dynamic> json) {
    return Operating(carrierCode: json['carrierCode'] ?? '');
  }
}
