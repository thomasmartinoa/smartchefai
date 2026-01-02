import 'package:flutter/foundation.dart';
import 'package:smartchefai/models/models.dart';
import 'package:smartchefai/services/api_service.dart';
import 'package:smartchefai/services/firebase_service.dart';

/// User Provider for profile management
class UserProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FirebaseService _firebaseService = FirebaseService();

  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  /// Create new user
  Future<void> createUser(String name, String email) async {
    _setLoading(true);
    _setError(null);

    try {
      final userId = await _apiService.createUser({
        'name': name,
        'email': email,
        'dietary_preferences': [],
        'allergies': [],
      });
      _currentUser = User(
        id: userId,
        name: name,
        email: email,
        dietaryPreferences: [],
        allergies: [],
        favoriteRecipes: [],
        searchHistory: [],
      );
      notifyListeners();
    } catch (e) {
      _setError('Failed to create user: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Get user profile
  Future<void> getUser(String userId) async {
    _setLoading(true);
    _setError(null);

    try {
      _currentUser = await _apiService.getUser(userId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load user: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Update user preferences
  Future<void> setPreferences(List<String> dietaryPrefs, List<String> allergies) async {
    if (_currentUser == null) {
      _setError('No user logged in');
      return;
    }

    try {
      _currentUser = User(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        dietaryPreferences: dietaryPrefs,
        allergies: allergies,
        favoriteRecipes: _currentUser!.favoriteRecipes,
        searchHistory: _currentUser!.searchHistory,
      );
      notifyListeners();
    } catch (e) {
      _setError('Failed to update preferences: $e');
    }
  }

  /// Logout
  Future<void> logout() async {
    await _firebaseService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  /// Sign in with email and password
  Future<void> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final userCredential = await _firebaseService.signInWithEmail(email, password);
      if (userCredential.user != null) {
        await _initUser(userCredential.user!.uid);
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign up with email and password
  Future<void> signUpWithEmail(String email, String password, String name) async {
    _setLoading(true);
    _setError(null);

    try {
      final userCredential = await _firebaseService.registerWithEmail(
        email,
        password,
        name,
      );
      if (userCredential.user != null) {
        await _initUser(userCredential.user!.uid);
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    _setLoading(true);
    _setError(null);

    try {
      final userCredential = await _firebaseService.signInWithGoogle();
      if (userCredential.user != null) {
        await _initUser(userCredential.user!.uid);
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Send password reset email
  Future<void> sendPasswordReset(String email) async {
    _setLoading(true);
    _setError(null);

    try {
      await _firebaseService.sendPasswordResetEmail(email);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign in as guest
  Future<void> signInAsGuest() async {
    _currentUser = User(
      id: 'guest',
      name: 'Guest User',
      email: 'guest@smartchefai.com',
      dietaryPreferences: [],
      allergies: [],
      favoriteRecipes: [],
      searchHistory: [],
    );
    notifyListeners();
  }

  /// Initialize user from Firebase
  Future<void> _initUser(String userId) async {
    try {
      // Try to get user from Firestore first
      _currentUser = await _apiService.getUser(userId);
    } catch (e) {
      // If user doesn't exist in Firestore, it might be a new Google sign-in
      // The Firebase service already created the basic profile
      final firebaseUser = _firebaseService.currentUser;
      if (firebaseUser != null) {
        _currentUser = User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'User',
          email: firebaseUser.email ?? '',
          dietaryPreferences: [],
          allergies: [],
          favoriteRecipes: [],
          searchHistory: [],
        );
      }
    }
    notifyListeners();
  }

  // Private helpers
  void _setLoading(bool value) {
    _isLoading = value;
  }

  void _setError(String? error) {
    _error = error;
  }
}
