
// lib/models/user.dart
class User {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final double balance;
  final List<String> favoriteRoutes;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.balance,
    required this.favoriteRoutes,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      balance: json['balance'].toDouble(),
      favoriteRoutes: List<String>.from(json['favoriteRoutes']),
    );
  }
}
