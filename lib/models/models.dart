/// Data models for SmartChef AI
library;

class Recipe {
  final String id;
  final String name;
  final List<String> ingredients;
  final List<String> steps;
  final String prepTime;
  final String cookTime;
  final String difficulty;
  final String cuisine;
  final List<String> dietaryTags;
  final Nutrition nutrition;
  final int servings;
  final String imageUrl;
  final double? similarityScore;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.steps,
    required this.prepTime,
    required this.cookTime,
    required this.difficulty,
    required this.cuisine,
    required this.dietaryTags,
    required this.nutrition,
    required this.servings,
    required this.imageUrl,
    this.similarityScore,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      steps: List<String>.from(json['steps'] ?? []),
      prepTime: json['prep_time'] ?? '',
      cookTime: json['cook_time'] ?? '',
      difficulty: json['difficulty'] ?? 'medium',
      cuisine: json['cuisine'] ?? '',
      dietaryTags: List<String>.from(json['dietary_tags'] ?? []),
      nutrition: Nutrition.fromJson(json['nutrition'] ?? {}),
      servings: json['servings'] ?? 1,
      imageUrl: json['image_url'] ?? '',
      similarityScore: (json['similarity_score'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'ingredients': ingredients,
    'steps': steps,
    'prep_time': prepTime,
    'cook_time': cookTime,
    'difficulty': difficulty,
    'cuisine': cuisine,
    'dietary_tags': dietaryTags,
    'nutrition': nutrition.toJson(),
    'servings': servings,
    'image_url': imageUrl,
  };
}

class Nutrition {
  final int calories;
  final String protein;
  final String carbs;
  final String fat;
  final String fiber;

  Nutrition({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
  });

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      calories: json['calories'] is int ? json['calories'] : int.tryParse(json['calories'].toString()) ?? 0,
      protein: json['protein']?.toString() ?? '0g',
      carbs: json['carbs']?.toString() ?? '0g',
      fat: json['fat']?.toString() ?? '0g',
      fiber: json['fiber']?.toString() ?? '0g',
    );
  }

  Map<String, dynamic> toJson() => {
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
    'fiber': fiber,
  };
}

class User {
  final String id;
  final String name;
  final String email;
  final List<String> dietaryPreferences;
  final List<String> allergies;
  final List<String> favoriteRecipes;
  final List<Map<String, dynamic>> searchHistory;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.dietaryPreferences,
    required this.allergies,
    required this.favoriteRecipes,
    required this.searchHistory,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      dietaryPreferences: List<String>.from(json['dietary_preferences'] ?? []),
      allergies: List<String>.from(json['allergies'] ?? []),
      favoriteRecipes: List<String>.from(json['favorite_recipes'] ?? []),
      searchHistory: List<Map<String, dynamic>>.from(json['search_history'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'dietary_preferences': dietaryPreferences,
    'allergies': allergies,
    'favorite_recipes': favoriteRecipes,
  };
}

class SearchHistory {
  final String query;
  final DateTime timestamp;

  SearchHistory({required this.query, required this.timestamp});

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
      query: json['query'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now(),
    );
  }
}

class GroceryList {
  final String id;
  final String userId;
  final List<GroceryItem> items;
  final Map<String, List<GroceryItem>> byCategory;
  final int totalItems;
  final List<String> recipes;
  final DateTime createdAt;
  final String status;

  GroceryList({
    required this.id,
    required this.userId,
    required this.items,
    required this.byCategory,
    required this.totalItems,
    required this.recipes,
    required this.createdAt,
    required this.status,
  });

  factory GroceryList.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] as List?)?.map((e) => GroceryItem.fromJson(e)).toList() ?? [];
    final byCategory = <String, List<GroceryItem>>{};
    for (var item in itemsList) {
      byCategory.putIfAbsent(item.category, () => []).add(item);
    }

    return GroceryList(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      items: itemsList,
      byCategory: byCategory,
      totalItems: json['total_items'] ?? itemsList.length,
      recipes: List<String>.from(json['recipes'] ?? []),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'items': items.map((e) => e.toJson()).toList(),
    'total_items': totalItems,
    'recipes': recipes,
    'status': status,
  };
}

class GroceryItem {
  final String name;
  final double quantity;
  final String unit;
  final String category;
  bool checked;
  final List<String> recipes;

  GroceryItem({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.category,
    this.checked = false,
    required this.recipes,
  });

  factory GroceryItem.fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      name: json['name'] ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1.0,
      unit: json['unit'] ?? '',
      category: json['category'] ?? 'other',
      checked: json['checked'] ?? false,
      recipes: List<String>.from(json['recipes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
    'unit': unit,
    'category': category,
    'checked': checked,
    'recipes': recipes,
  };
}

class DetectedIngredient {
  final String name;
  final double confidence;
  final BoundingBox bbox;

  DetectedIngredient({
    required this.name,
    required this.confidence,
    required this.bbox,
  });

  factory DetectedIngredient.fromJson(Map<String, dynamic> json) {
    return DetectedIngredient(
      name: json['name'] ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      bbox: BoundingBox.fromJson(json['bbox'] ?? {}),
    );
  }
}

class BoundingBox {
  final double x1;
  final double y1;
  final double x2;
  final double y2;

  BoundingBox({required this.x1, required this.y1, required this.x2, required this.y2});

  factory BoundingBox.fromJson(Map<String, dynamic> json) {
    return BoundingBox(
      x1: (json['x1'] as num?)?.toDouble() ?? 0.0,
      y1: (json['y1'] as num?)?.toDouble() ?? 0.0,
      x2: (json['x2'] as num?)?.toDouble() ?? 0.0,
      y2: (json['y2'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
