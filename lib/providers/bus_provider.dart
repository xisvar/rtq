import 'package:flutter/material.dart';
import '../models/bus.dart';
import '../models/route.dart';
import '../models/coordinate.dart';

class BusProvider with ChangeNotifier {
  List<Bus> _buses = [];
  List<BusRoute> _routes = [];
  bool _isLoading = false;
  String? _error;

  List<Bus> get buses => [..._buses];
  List<BusRoute> get routes => [..._routes];
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch buses near user's location
  Future<void> fetchNearbyBuses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // In a real app, you'd have an actual API endpoint
      // This is mocked for demonstration purposes
      await Future.delayed(Duration(seconds: 1));
      
      // Mock data for demonstration
      _buses = _generateMockBuses();
      _routes = _generateMockRoutes();
      
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _error = 'Failed to fetch bus data. Please try again.';
      notifyListeners();
    }
  }

  // For a specific route
  Future<void> fetchBusesOnRoute(String routeId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // In a real app, you'd hit an actual API endpoint
      await Future.delayed(Duration(seconds: 1));
      
      // Filter buses to only show those on the selected route
      _buses = _generateMockBuses().where((bus) => bus.routeId == routeId).toList();
      
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _error = 'Failed to fetch buses for this route. Please try again.';
      notifyListeners();
    }
  }

  // Estimate arrival time for a specific bus at user's location
  Future<String> estimateArrivalTime(String busId, double userLatitude, double userLongitude) async {
    // In a real app, this would calculate based on distance, traffic, etc.
    final bus = _buses.firstWhere((b) => b.id == busId);
    
    // For a realistic app, you might implement a calculation here
    // using the bus location and user location to determine an actual estimate
    // For example:
    // final distance = calculateDistance(
    //   bus.latitude, bus.longitude, userLatitude, userLongitude);
    // final estimatedMinutes = (distance / bus.speed) * 60;
    
    return bus.estimatedArrival;
  }

  // Generate mock data for demonstration purposes
  List<Bus> _generateMockBuses() {
    return [
      Bus(
        id: 'bus1',
        routeId: 'route1',
        routeName: 'Ikeja - Lekki Route',
        startPoint: 'Ikeja Bus Terminal',
        endPoint: 'Lekki Phase 1',
        latitude: 6.5244,
        longitude: 3.3792,
        passengerCount: 35,
        capacity: 60,
        busNumber: 'BRT-2501',
        estimatedArrival: '5 mins',
        speed: 40.5,
        isActive: true,
      ),
      Bus(
        id: 'bus2',
        routeId: 'route1',
        routeName: 'Ikeja - Lekki Route',
        startPoint: 'Ikeja Bus Terminal',
        endPoint: 'Lekki Phase 1',
        latitude: 6.5350,
        longitude: 3.3450,
        passengerCount: 50,
        capacity: 60,
        busNumber: 'BRT-1803',
        estimatedArrival: '12 mins',
        speed: 35.2,
        isActive: true,
      ),
      Bus(
        id: 'bus3',
        routeId: 'route2',
        routeName: 'Oshodi - Ikorodu Route',
        startPoint: 'Oshodi Transport Interchange',
        endPoint: 'Ikorodu Terminal',
        latitude: 6.5444,
        longitude: 3.3622,
        passengerCount: 28,
        capacity: 60,
        busNumber: 'BRT-1204',
        estimatedArrival: '8 mins',
        speed: 38.7,
        isActive: true,
      ),
    ];
  }

  List<BusRoute> _generateMockRoutes() {
    return [
      BusRoute(
        id: 'route1',
        name: 'Ikeja - Lekki Route',
        startPoint: 'Ikeja Bus Terminal',
        endPoint: 'Lekki Phase 1',
        coordinates: [
          Coordinate(latitude: 6.5244, longitude: 3.3792),
          Coordinate(latitude: 6.5350, longitude: 3.3450),
          Coordinate(latitude: 6.5450, longitude: 3.3550),
          Coordinate(latitude: 6.4590, longitude: 3.4642),
        ],
        estimatedTime: 45,
        fare: 500.0, // Changed price back to fare to match the BusRoute model
        stops: ['Ikeja', 'Maryland', 'Ilupeju', 'Gbagada', 'Oworonsoki', 'Lekki'],
      ),
      BusRoute(
        id: 'route2',
        name: 'Oshodi - Ikorodu Route',
        startPoint: 'Oshodi Transport Interchange',
        endPoint: 'Ikorodu Terminal',
        coordinates: [
          Coordinate(latitude: 6.5444, longitude: 3.3622),
          Coordinate(latitude: 6.5550, longitude: 3.3750),
          Coordinate(latitude: 6.6033, longitude: 3.3919),
          Coordinate(latitude: 6.6190, longitude: 3.5065),
        ],
        estimatedTime: 55,
        fare: 350.0, // Changed price back to fare to match the BusRoute model
        stops: ['Oshodi', 'Kosofe', 'Mile 12', 'Ketu', 'Majidun', 'Ikorodu'],
      ),
    ];
  }
}