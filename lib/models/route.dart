
// lib/models/route.dart
import 'coordinate.dart';

class BusRoute {
  final String id;
  final String name;
  final String startPoint;
  final String endPoint;
  final List<Coordinate> coordinates;
  final int estimatedTime;
  final double fare;
  final List<String> stops;

  BusRoute({
    required this.id,
    required this.name,
    required this.startPoint,
    required this.endPoint,
    required this.coordinates,
    required this.estimatedTime,
    required this.fare,
    required this.stops,
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) {
    return BusRoute(
      id: json['id'],
      name: json['name'],
      startPoint: json['startPoint'],
      endPoint: json['endPoint'],
      coordinates: (json['coordinates'] as List)
          .map((coord) => Coordinate.fromJson(coord))
          .toList(),
      estimatedTime: json['estimatedTime'],
      fare: json['fare'].toDouble(),
      stops: List<String>.from(json['stops']),
    );
  }
}
