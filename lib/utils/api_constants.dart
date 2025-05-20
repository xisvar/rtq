// lib/utils/api_constants.dart

class ApiConstants {
  // Firebase Configuration
  static const String firebaseUrl = 'YOUR_FIREBASE_PROJECT_URL';
  
  // Google Maps API
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  static const String directionsBaseUrl = 'https://maps.googleapis.com/maps/api/directions/json';
  static const String geocodingBaseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
  static const String placesApiBaseUrl = 'https://maps.googleapis.com/maps/api/place';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String busesCollection = 'buses';
  static const String routesCollection = 'routes';
  static const String ticketsCollection = 'tickets';
  static const String transactionsCollection = 'transactions';
  
  // Refresh Intervals (in seconds)
  static const int busLocationRefreshInterval = 5;
  static const int routeRefreshInterval = 60;
  static const int passengerLoadRefreshInterval = 30;
  
  // Feature Flags
  static const bool enableAiRouting = true;
  static const bool enablePassengerLoadMonitoring = true;
  static const bool enablePushNotifications = true;
  
  // Mock Data (for local development)
  static const bool useMockData = true;
  static const String mockDataPath = 'assets/mock_data';
}