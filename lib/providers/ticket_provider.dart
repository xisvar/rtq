//ticket_provider.dart
import 'package:flutter/material.dart';
import '../models/ticket.dart';

class TicketProvider with ChangeNotifier {
  List<Ticket> _tickets = [];
  bool _isLoading = false;
  String? _error;

  List<Ticket> get tickets => [..._tickets];
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch user tickets
  Future<void> fetchUserTickets() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // In a real app, this would fetch from an API or local storage
      await Future.delayed(Duration(seconds: 1));
      
      // Mock data for demonstration
      _tickets = _generateMockTickets();
      
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _error = 'Failed to fetch tickets. Please try again.';
      notifyListeners();
      rethrow;
    }
  }

  // Purchase a new ticket
  Future<void> purchaseTicket(String routeId, String passengerName, bool isRoundTrip) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // In a real app, this would call an API to purchase a ticket
      await Future.delayed(Duration(seconds: 1));
      
      // Set route details based on routeId
      String routeName, startPoint, endPoint;
      double price;
      
      if (routeId == 'route1') {
        routeName = 'Ikeja - Lekki Route';
        startPoint = 'Ikeja Bus Terminal';
        endPoint = 'Lekki Phase 1';
        price = 500.0;
      } else {
        routeName = 'Oshodi - Ikorodu Route';
        startPoint = 'Oshodi Transport Interchange';
        endPoint = 'Ikorodu Terminal';
        price = 350.0;
      }
      
      // Generate a new ticket
      final newTicket = Ticket(
        id: 'ticket-${DateTime.now().millisecondsSinceEpoch}',
        userId: 'current-user', // Would use actual user ID
        routeId: routeId,
        routeName: routeName,
        startPoint: startPoint,
        endPoint: endPoint,
        price: price,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(Duration(days: 1)),
        isUsed: false,
        passengerName: passengerName,
        isRoundTrip: isRoundTrip,
        type: isRoundTrip ? 'Round Trip' : 'One Way',
        isActive: true,
      );
      
      _tickets.add(newTicket);
      
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _error = 'Failed to purchase ticket. Please try again.';
      notifyListeners();
      rethrow;
    }
  }

  // Mark a ticket as used
  Future<void> useTicket(String ticketId) async {
    final ticketIndex = _tickets.indexWhere((t) => t.id == ticketId);
    if (ticketIndex == -1) return;

    try {
      // In a real app, this would call an API to validate the ticket
      await Future.delayed(Duration(milliseconds: 500));
      
      final ticket = _tickets[ticketIndex];
      
      final updatedTicket = Ticket(
        id: ticket.id,
        userId: ticket.userId,
        routeId: ticket.routeId,
        routeName: ticket.routeName,
        startPoint: ticket.startPoint,
        endPoint: ticket.endPoint,
        price: ticket.price,
        purchaseDate: ticket.purchaseDate,
        expiryDate: ticket.expiryDate,
        isUsed: true,
        passengerName: ticket.passengerName,
        isRoundTrip: ticket.isRoundTrip,
        type: ticket.type,
        isActive: false,  // Mark as inactive once used
      );
      
      _tickets[ticketIndex] = updatedTicket;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  // Generate mock data for demonstration purposes
  List<Ticket> _generateMockTickets() {
    return [
      Ticket(
        id: 'ticket1',
        userId: 'current-user',
        routeId: 'route1',
        routeName: 'Ikeja - Lekki Route',
        startPoint: 'Ikeja Bus Terminal',
        endPoint: 'Lekki Phase 1',
        price: 500.0,
        purchaseDate: DateTime.now().subtract(Duration(days: 1)),
        expiryDate: DateTime.now().add(Duration(days: 1)),
        isUsed: false,
        passengerName: 'John Doe',
        isRoundTrip: false,
        type: 'One Way',
        isActive: true,
      ),
      Ticket(
        id: 'ticket2',
        userId: 'current-user',
        routeId: 'route2',
        routeName: 'Oshodi - Ikorodu Route',
        startPoint: 'Oshodi Transport Interchange',
        endPoint: 'Ikorodu Terminal',
        price: 350.0,
        purchaseDate: DateTime.now().subtract(Duration(days: 2)),
        expiryDate: DateTime.now().subtract(Duration(days: 1)),
        isUsed: true,
        passengerName: 'John Doe',
        isRoundTrip: true,
        type: 'Round Trip',
        isActive: false,
      ),
    ];
  }
}