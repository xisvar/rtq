// lib/models/ticket.dart
class Ticket {
  final String id;
  final String userId;
  final String routeId;
  final String routeName;
  final String startPoint;
  final String endPoint;
  final double price;  // Changed from fare to match TicketCard
  final DateTime purchaseDate;
  final DateTime expiryDate;
  final bool isUsed;
  final String passengerName;  // Added to match TicketCard
  final bool isRoundTrip;  // Added to match TicketCard
  final String type;  // For example: "One Way", "Return", etc.
  final bool isActive;  // Whether the ticket is still valid/active

  Ticket({
    required this.id,
    required this.userId,
    required this.routeId,
    required this.routeName,
    required this.startPoint,
    required this.endPoint,
    required this.price,
    required this.purchaseDate,
    required this.expiryDate,
    required this.isUsed,
    required this.passengerName,
    required this.isRoundTrip,
    required this.type,
    required this.isActive,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      userId: json['userId'],
      routeId: json['routeId'],
      routeName: json['routeName'],
      startPoint: json['startPoint'],
      endPoint: json['endPoint'],
      price: json['price'].toDouble(),
      purchaseDate: DateTime.parse(json['purchaseDate']),
      expiryDate: DateTime.parse(json['expiryDate']),
      isUsed: json['isUsed'],
      passengerName: json['passengerName'],
      isRoundTrip: json['isRoundTrip'],
      type: json['type'],
      isActive: json['isActive'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'routeId': routeId,
      'routeName': routeName,
      'startPoint': startPoint,
      'endPoint': endPoint,
      'price': price,
      'purchaseDate': purchaseDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'isUsed': isUsed,
      'passengerName': passengerName,
      'isRoundTrip': isRoundTrip,
      'type': type,
      'isActive': isActive,
    };
  }
}