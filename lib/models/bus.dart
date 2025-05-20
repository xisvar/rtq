// lib/models/bus.dart
class Bus {
  final String id;
  final String routeId;
  final String routeName;
  final String startPoint;
  final String endPoint;
  final double latitude;
  final double longitude;
  final int passengerCount;
  final int capacity;
  final String busNumber;
  final String estimatedArrival;
  final double speed;
  final bool isActive;

  Bus({
    required this.id,
    required this.routeId,
    required this.routeName,
    required this.startPoint,
    required this.endPoint,
    required this.latitude,
    required this.longitude,
    required this.passengerCount,
    required this.capacity,
    required this.busNumber,
    required this.estimatedArrival,
    required this.speed,
    required this.isActive,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'],
      routeId: json['routeId'],
      routeName: json['routeName'],
      startPoint: json['startPoint'],
      endPoint: json['endPoint'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      passengerCount: json['passengerCount'],
      capacity: json['capacity'],
      busNumber: json['busNumber'],
      estimatedArrival: json['estimatedArrival'],
      speed: json['speed'].toDouble(),
      isActive: json['isActive'],
    );
  }

    /// Computed: What percentage of seats are taken
    double get loadPercentage {
      if (capacity == 0) return 0;
      return (passengerCount / capacity) * 100;
    }

    /// Computed: Human-readable load status
    String get loadStatus {
      final load = loadPercentage;
      if (load < 50) return 'Low';
      if (load < 80) return 'Medium';
      return 'High';
    }

    /// Computed: Available seats
    int get availableSeats => capacity - passengerCount;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routeId': routeId,
      'routeName': routeName,
      'startPoint': startPoint,
      'endPoint': endPoint,
      'latitude': latitude,
      'longitude': longitude,
      'passengerCount': passengerCount,
      'capacity': capacity,
      'busNumber': busNumber,
      'estimatedArrival': estimatedArrival,
      'speed': speed,
      'isActive': isActive,
    };
  }
}