import 'package:flutter/material.dart';
import 'package:smartchefai/models/models.dart';
import 'package:smartchefai/services/api_service.dart';

class RecipeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Recipe> _recipes = [];
  List<Recipe> _favorites = [];
  Recipe? _currentRecipe;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Recipe> get recipes => _recipes;
  List<Recipe> get favorites => _favorites;
  Recipe? get currentRecipe => _currentRecipe;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Search recipes
  Future<List<Recipe>> searchRecipes(
    String query, {
    Map<String, dynamic>? filters,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _recipes = await _apiService.searchRecipes(query, filters: filters);
      _isLoading = false;
      notifyListeners();
      return _recipes;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  // Search by ingredients
  Future<List<Recipe>> searchByIngredients(List<String> ingredients) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _recipes = await _apiService.searchByIngredients(ingredients);
      /// Recipe Provider with improved state management
      class RecipeProvider extends ChangeNotifier {
        final ApiService _apiService = ApiService();

        List<Recipe> _recipes = [];
        List<Recipe> _favorites = [];
        Recipe? _currentRecipe;
        bool _isLoading = false;
        String? _error;
        List<String> _searchHistory = [];

        // Getters
        List<Recipe> get recipes => _recipes;
        List<Recipe> get favorites => _favorites;
        Recipe? get currentRecipe => _currentRecipe;
        bool get isLoading => _isLoading;
        String? get error => _error;
        List<String> get searchHistory => _searchHistory;

        /// Search recipes by query
        Future<void> searchRecipes(String query) async {
          if (query.isEmpty) return;
    
          _setLoading(true);
          _setError(null);
          _addToSearchHistory(query);

          try {
            _recipes = await _apiService.searchRecipes(query);
            notifyListeners();
          } catch (e) {
            _setError('Failed to search recipes: $e');
          } finally {
            _setLoading(false);
          }
        }

        /// Search recipes by ingredients
        Future<void> searchByIngredients(List<String> ingredients) async {
          _setLoading(true);
          _setError(null);

          try {
            _recipes = await _apiService.searchByIngredients(ingredients);
            notifyListeners();
          } catch (e) {
            _setError('Failed to search by ingredients: $e');
          } finally {
            _setLoading(false);
          }
        }

        /// Get all recipes
        Future<void> getAllRecipes() async {
          _setLoading(true);
          _setError(null);

          try {
            _recipes = await _apiService.getAllRecipes();
            notifyListeners();
          } catch (e) {
            _setError('Failed to load recipes: $e');
          } finally {
            _setLoading(false);
          }
        }

        /// Get single recipe by ID
        Future<void> getRecipe(String id) async {
          _setLoading(true);
          _setError(null);

          try {
            _currentRecipe = await _apiService.getRecipe(id);
            notifyListeners();
          } catch (e) {
            _setError('Failed to load recipe: $e');
          } finally {
            _setLoading(false);
          }
        }

        /// Add recipe to favorites
        Future<void> addFavorite(String userId, String recipeId) async {
          try {
            final recipe = _recipes.firstWhere((r) => r.id == recipeId);
            if (!_favorites.any((r) => r.id == recipeId)) {
              _favorites.add(recipe);
              notifyListeners();
            }
          } catch (e) {
            _setError('Failed to add favorite: $e');
          }
        }

        /// Remove recipe from favorites
        Future<void> removeFavorite(String recipeId) async {
          try {
            _favorites.removeWhere((r) => r.id == recipeId);
            notifyListeners();
          } catch (e) {
            _setError('Failed to remove favorite: $e');
          }
        }

        /// Check if recipe is favorite
        bool isFavorite(String recipeId) {
          return _favorites.any((r) => r.id == recipeId);
        }

        /// Clear search history
        void clearSearchHistory() {
          _searchHistory.clear();
          notifyListeners();
        }

        // Private helpers
        void _setLoading(bool value) {
          _isLoading = value;
        }

        void _setError(String? error) {
          _error = error;
        }

        void _addToSearchHistory(String query) {
          if (!_searchHistory.contains(query)) {
            _searchHistory.insert(0, query);
            if (_searchHistory.length > 10) {
              _searchHistory.removeLast();
            }
          }
        }
      _isLoading = false;
      notifyListeners();
      return _recipes;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  // Get recipe by ID
  Future<Recipe?> getRecipe(String recipeId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentRecipe = await _apiService.getRecipe(recipeId);
      _isLoading = false;
      notifyListeners();
      return _currentRecipe;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Get all recipes
  Future<List<Recipe>> getAllRecipes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _recipes = await _apiService.getAllRecipes();
      _isLoading = false;
      notifyListeners();
      return _recipes;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  // Get favorites
  Future<void> getFavorites(String userId) async {
    try {
      _favorites = await _apiService.getFavorites(userId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Add favorite
  Future<bool> addFavorite(String userId, String recipeId) async {
    try {
      await _apiService.addFavorite(userId, recipeId);
      if (_currentRecipe != null) {
        _favorites.add(_currentRecipe!);
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Remove favorite
  Future<bool> removeFavorite(String userId, String recipeId) async {
    try {
      await _apiService.removeFavorite(userId, recipeId);
      _favorites.removeWhere((r) => r.id == recipeId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  bool isFavorite(String recipeId) {
    return _favorites.any((r) => r.id == recipeId);
  }
}

class UserProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  // Create user
  Future<bool> createUser(String name, String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userId = await _apiService.createUser({
        'name': name,
        'email': email,
      });
      await getUser(userId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get user
  Future<void> getUser(String userId) async {
    try {
      _currentUser = await _apiService.getUser(userId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Set preferences
  Future<bool> setPreferences(
    List<String> dietaryPreferences,
    List<String> allergies,
  ) async {
    if (_currentUser == null) return false;

    try {
      await _apiService.setPreferences(
        _currentUser!.id,
        dietaryPreferences,
        allergies,
      );
      _currentUser = User(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        dietaryPreferences: dietaryPreferences,
        allergies: allergies,
        favoriteRecipes: _currentUser!.favoriteRecipes,
        searchHistory: _currentUser!.searchHistory,
      );
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}

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

  // Create grocery list
  Future<String?> createGroceryList(
    String userId,
    List<String> recipeIds, {
    Map<String, double>? servingsMultipliers,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final listId = await _apiService.createGroceryList(
        userId,
        recipeIds,
        servingsMultipliers: servingsMultipliers,
      );
      await getGroceryList(listId);
      _isLoading = false;
      notifyListeners();
      return listId;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Get grocery list
  Future<void> getGroceryList(String listId) async {
    try {
      _currentList = await _apiService.getGroceryList(listId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Get user grocery lists
  Future<void> getUserGroceryLists(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _lists = await _apiService.getUserGroceryLists(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle item
  Future<bool> toggleItem(String listId, String itemName) async {
    try {
      await _apiService.toggleGroceryItem(listId, itemName);
      await getGroceryList(listId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete list
  Future<bool> deleteList(String listId) async {
    try {
      await _apiService.deleteGroceryList(listId);
      _lists.removeWhere((l) => l.id == listId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
