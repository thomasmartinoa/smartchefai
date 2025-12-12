import 'package:flutter/foundation.dart';
import 'package:smartchefai/models/models.dart';
import 'package:smartchefai/services/api_service.dart';

/// Grocery List Provider
class GroceryListProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<GroceryList> _lists = [];
  GroceryList? _currentList;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<GroceryList> get lists => _lists;
  GroceryList? get currentList => _currentList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Create new grocery list
  Future<void> createGroceryList(String userId, String name) async {
    _setLoading(true);
    _setError(null);

    try {
      final newList = GroceryList(
        id: DateTime.now().toString(),
        userId: userId,
        name: name,
        items: [],
        createdAt: DateTime.now(),
      );
        final newList = GroceryList(
          id: DateTime.now().toString(),
          userId: userId,
          items: [],
          byCategory: {},
          totalItems: 0,
          recipes: [],
          createdAt: DateTime.now(),
          status: 'active',
        );
      _lists.add(newList);
      notifyListeners();
    } catch (e) {
      _setError('Failed to create list: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Get user's grocery lists
  Future<void> getUserGroceryLists(String userId) async {
    _setLoading(true);
    _setError(null);

    try {
      _lists = await _apiService.getUserGroceryLists(userId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load lists: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Add item to list
  Future<void> addItemToList(String listId, String itemName, String category) async {
    try {
      final list = _lists.firstWhere((l) => l.id == listId);
      final newItem = GroceryItem(
        name: itemName,
        category: category,
        isChecked: false,
      );
      list.items.add(newItem);
      notifyListeners();
    } catch (e) {
      _setError('Failed to add item: $e');
    }
  }

  /// Toggle item checked state
  Future<void> toggleItem(String listId, String itemName) async {
    try {
      final list = _lists.firstWhere((l) => l.id == listId);
      final item = list.items.firstWhere((i) => i.name == itemName);
      item.isChecked = !item.isChecked;
      notifyListeners();
    } catch (e) {
      _setError('Failed to toggle item: $e');
    }
  }

  /// Delete list
  Future<void> deleteList(String listId) async {
    try {
      _lists.removeWhere((l) => l.id == listId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete list: $e');
    }
  }

  // Private helpers
  void _setLoading(bool value) {
    _isLoading = value;
  }

  void _setError(String? error) {
    _error = error;
  }
}
