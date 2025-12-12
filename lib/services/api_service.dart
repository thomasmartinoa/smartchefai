import 'package:dio/dio.dart';
import 'package:smartchefai/models/models.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';
  late Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
      ),
    );
  }

  // Recipe endpoints
  Future<Recipe> getRecipe(String recipeId) async {
    try {
      final response = await _dio.get('/recipes/$recipeId');
      return Recipe.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get recipe: ${e.message}');
    }
  }

  Future<List<Recipe>> searchRecipes(
    String query, {
    int limit = 15,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final response = await _dio.post(
        '/recipes/search',
        data: {
          'query': query,
          'limit': limit,
          'filters': filters ?? {},
        },
      );
      return (response.data['results'] as List)
          .map((r) => Recipe.fromJson(r))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to search recipes: ${e.message}');
    }
  }

  Future<List<Recipe>> searchByIngredients(
    List<String> ingredients, {
    int limit = 15,
  }) async {
    try {
      final response = await _dio.post(
        '/recipes/by-ingredients',
        data: {
          'ingredients': ingredients,
          'limit': limit,
        },
      );
      return (response.data['results'] as List)
          .map((r) => Recipe.fromJson(r))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to search by ingredients: ${e.message}');
    }
  }

  Future<List<Recipe>> getAllRecipes({int limit = 100}) async {
    try {
      final response = await _dio.get('/recipes/all?limit=$limit');
      return (response.data['recipes'] as List)
          .map((r) => Recipe.fromJson(r))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to get recipes: ${e.message}');
    }
  }

  // Ingredient detection endpoints
  Future<List<DetectedIngredient>> detectIngredients(List<int> imageBytes) async {
    try {
      final formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(
          imageBytes,
          filename: 'image.jpg',
        ),
      });

      final response = await _dio.post(
        '/detect/ingredients',
        data: formData,
      );

      return (response.data['detections'] as List)
          .map((d) => DetectedIngredient.fromJson(d))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to detect ingredients: ${e.message}');
    }
  }

  Future<List<Recipe>> detectIngredientsAndFindRecipes(List<int> imageBytes) async {
    try {
      final formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(
          imageBytes,
          filename: 'image.jpg',
        ),
      });

      final response = await _dio.post(
        '/detect/ingredients-and-recipes',
        data: formData,
      );

      return (response.data['recipes'] as List)
          .map((r) => Recipe.fromJson(r))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to detect ingredients and find recipes: ${e.message}');
    }
  }

  // User endpoints
  Future<String> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post('/users', data: userData);
      return response.data['id'];
    } on DioException catch (e) {
      throw Exception('Failed to create user: ${e.message}');
    }
  }

  Future<User> getUser(String userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get user: ${e.message}');
    }
  }

  Future<void> setPreferences(
    String userId,
    List<String> dietaryPreferences,
    List<String> allergies,
  ) async {
    try {
      await _dio.post(
        '/users/$userId/preferences',
        data: {
          'dietary_preferences': dietaryPreferences,
          'allergies': allergies,
        },
      );
    } on DioException catch (e) {
      throw Exception('Failed to set preferences: ${e.message}');
    }
  }

  Future<List<Recipe>> getFavorites(String userId) async {
    try {
      final response = await _dio.get('/users/$userId/favorites');
      return (response.data['favorites'] as List)
          .map((f) => Recipe.fromJson(f))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to get favorites: ${e.message}');
    }
  }

  Future<void> addFavorite(String userId, String recipeId) async {
    try {
      await _dio.post(
        '/users/$userId/favorites/add',
        data: {'recipe_id': recipeId},
      );
    } on DioException catch (e) {
      throw Exception('Failed to add favorite: ${e.message}');
    }
  }

  Future<void> removeFavorite(String userId, String recipeId) async {
    try {
      await _dio.post(
        '/users/$userId/favorites/remove',
        data: {'recipe_id': recipeId},
      );
    } on DioException catch (e) {
      throw Exception('Failed to remove favorite: ${e.message}');
    }
  }

  Future<List<Recipe>> getPersonalizedRecommendations(
    String userId, {
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/users/$userId/recommendations?limit=$limit',
      );
      return (response.data['recommendations'] as List)
          .map((r) => Recipe.fromJson(r))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to get recommendations: ${e.message}');
    }
  }

  // Grocery list endpoints
  Future<String> createGroceryList(
    String userId,
    List<String> recipeIds, {
    Map<String, double>? servingsMultipliers,
  }) async {
    try {
      final response = await _dio.post(
        '/grocery-lists',
        data: {
          'user_id': userId,
          'recipe_ids': recipeIds,
          'servings_multipliers': servingsMultipliers ?? {},
        },
      );
      return response.data['id'];
    } on DioException catch (e) {
      throw Exception('Failed to create grocery list: ${e.message}');
    }
  }

  Future<GroceryList> getGroceryList(String listId) async {
    try {
      final response = await _dio.get('/grocery-lists/$listId');
      return GroceryList.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get grocery list: ${e.message}');
    }
  }

  Future<List<GroceryList>> getUserGroceryLists(String userId) async {
    try {
      final response = await _dio.get('/grocery-lists/user/$userId');
      return (response.data['lists'] as List)
          .map((l) => GroceryList.fromJson(l))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to get grocery lists: ${e.message}');
    }
  }

  Future<void> updateGroceryList(String listId, Map<String, dynamic> updates) async {
    try {
      await _dio.put('/grocery-lists/$listId', data: updates);
    } on DioException catch (e) {
      throw Exception('Failed to update grocery list: ${e.message}');
    }
  }

  Future<void> deleteGroceryList(String listId) async {
    try {
      await _dio.delete('/grocery-lists/$listId');
    } on DioException catch (e) {
      throw Exception('Failed to delete grocery list: ${e.message}');
    }
  }

  Future<void> toggleGroceryItem(String listId, String itemName) async {
    try {
      await _dio.post(
        '/grocery-lists/$listId/toggle-item',
        data: {'item_name': itemName},
      );
    } on DioException catch (e) {
      throw Exception('Failed to toggle item: ${e.message}');
    }
  }

  // Health check
  Future<bool> healthCheck() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } on DioException {
      return false;
    }
  }
}
