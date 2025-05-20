import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  
  User? _user;
  bool _isLoading = false;
  String? _error;
  
  User? get currentUser => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  AuthProvider() {
    _initializeUser();
  }
  
  // Initialize user data if a user is already logged in
  Future<void> _initializeUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      _user = User(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? 'Anonymous',
        email: firebaseUser.email ?? '',
        phoneNumber: firebaseUser.phoneNumber ?? '',
        balance: 0.0,
        favoriteRoutes: [],
      );
      notifyListeners();
    }
  }
  
  // Sign up a new user
  Future<void> signUp(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Update display name
      await credential.user!.updateDisplayName(name);
      
      _user = User(
        id: credential.user!.uid,
        name: name,
        email: email,
        phoneNumber: credential.user!.phoneNumber ?? '',
        balance: 0.0,
        favoriteRoutes: [],
      );
      _error = null;
    } on firebase_auth.FirebaseAuthException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Sign in an existing user
  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _user = User(
        id: credential.user!.uid,
        name: credential.user!.displayName ?? 'Anonymous',
        email: email,
        phoneNumber: credential.user!.phoneNumber ?? '',
        balance: 0.0,
        favoriteRoutes: [],
      );
      _error = null;
    } on firebase_auth.FirebaseAuthException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Sign out the current user
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  // Update user profile
  Future<void> updateUserProfile({required String name, required String phone}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        throw Exception('No authenticated user found');
      }
      
      // Update display name in Firebase Auth
      await firebaseUser.updateDisplayName(name);
      
      // Note: Firebase Auth doesn't support updating phone directly
      // In a real app, you would update this in your database
      
      // Update local user model
      if (_user != null) {
        _user = User(
          id: _user!.id,
          name: name,
          email: _user!.email,
          phoneNumber: phone,
          balance: _user!.balance,
          favoriteRoutes: _user!.favoriteRoutes,
        );
      }
      
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}