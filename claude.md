# SmartChef AI - Project Documentation

> **AI-Powered Recipe Recommender with Smart Ingredient Detection**
> 
> **Architecture**: Firebase + Flutter | **Version**: 2.0 | **Updated**: 2025

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Project Structure](#project-structure)
4. [Firebase Integration](#firebase-integration)
5. [Theme System](#theme-system)
6. [Navigation](#navigation)
7. [State Management](#state-management)
8. [Data Layer](#data-layer)
9. [Features](#features)
10. [Screens](#screens)
11. [Widgets](#widgets)
12. [Models](#models)
13. [Best Practices](#best-practices)
14. [Quick Start](#quick-start)
15. [Future Enhancements](#future-enhancements)

---

## 🎯 Project Overview

SmartChef AI is a personalized recipe recommendation application that uses AI-powered features to help users discover, plan, and cook meals. The app supports:

- **Text Search**: Traditional recipe search by name, ingredient, or cuisine
- **Voice Input**: Hands-free recipe search using speech recognition
- **Camera Scan**: AI-powered ingredient detection from photos
- **Smart Recommendations**: Personalized suggestions based on preferences
- **Grocery Management**: Auto-generate shopping lists from recipes
- **Nutrition Tracking**: Calorie and macro information for recipes

### Tech Stack

| Category | Technology |
|----------|------------|
| Framework | Flutter 3.x (Dart) |
| Backend | **Firebase** (Firestore, Auth, Storage) |
| State Management | Provider + ChangeNotifier |
| Navigation | GoRouter with ShellRoute |
| Recipe API | TheMealDB (Free, backup source) |
| Local Storage | SharedPreferences |
| Voice Input | speech_to_text (On-device) |
| Image Handling | image_picker + cached_network_image |
| Animations | flutter_animate |
| HTTP Client | Dio |

---

## 🏗 Architecture

### Firebase-First Architecture

```
┌─────────────────────────────────────┐
│          Presentation Layer         │
│  (Screens, Widgets, Providers)      │
├─────────────────────────────────────┤
│           Domain Layer              │
│   (Models with copyWith methods)    │
├─────────────────────────────────────┤
│            Data Layer               │
│   (FirebaseService - Singleton)     │
│   - Firestore (Recipes, Users)      │
│   - Firebase Auth (Authentication)  │
│   - TheMealDB API (Recipe Fallback) │
│   - Local Cache (Offline-first)     │
└─────────────────────────────────────┘
```

### Key Design Principles

1. **Serverless Architecture**: No backend server needed - Firebase handles everything
2. **Offline-First**: Local cache with SharedPreferences + Firestore persistence
3. **Immutable Models**: All models have `copyWith` methods for safe state updates
4. **Singleton Service**: FirebaseService as single source of truth
5. **Fallback Strategy**: TheMealDB API as backup when Firestore is empty

---

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry + Firebase init
├── firebase_options.dart        # Firebase configuration
├── app/
│   ├── routes.dart              # GoRouter with ShellRoute
│   └── theme/
│       ├── theme.dart           # Barrel export
│       ├── app_colors.dart      # Color system
│       ├── app_typography.dart  # Text styles
│       ├── app_spacing.dart     # Spacing constants
│       └── app_theme.dart       # ThemeData config
├── features/
│   ├── home/
│   │   └── home_screen.dart
│   ├── search/
│   │   └── search_screen.dart
│   ├── recipe_detail/
│   │   └── recipe_detail_screen.dart
│   ├── favorites/
│   │   └── favorites_screen.dart
│   ├── grocery/
│   │   └── grocery_list_screen.dart
│   ├── profile/
│   │   └── profile_screen.dart
│   ├── scan/
│   │   └── scan_screen.dart
│   └── onboarding/
│       └── onboarding_screen.dart
├── shared/
│   └── widgets/
│       ├── widgets.dart         # Barrel export
│       ├── recipe_card.dart     # Recipe cards
│       ├── common_widgets.dart  # Buttons, search bar
│       ├── ingredient_nutrition_widgets.dart
│       └── navigation_widgets.dart
├── models/
│   └── models.dart              # Immutable data models
├── providers/
│   ├── app_providers.dart       # Re-export
│   └── firebase_providers.dart  # State management
├── services/
│   └── firebase_service.dart    # Firebase + API integration
└── widgets/
    └── custom_widgets.dart      # Legacy shared widgets
```

---

## 🔥 Firebase Integration

### Services (firebase_service.dart)

```dart
class FirebaseService {
  // Singleton pattern
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  
  // Firebase instances
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  
  // Features
  Future<List<Recipe>> getAllRecipes({bool forceRefresh = false});
  Future<Recipe?> getRecipe(String id);
  Future<List<Recipe>> searchRecipes(String query);
  Future<List<Recipe>> searchByIngredients(List<String> ingredients);
  
  // User management
  Future<firebase_auth.UserCredential> signInAnonymously();
  Future<AppUser?> getUserProfile();
  Future<void> createUserProfile({...});
  
  // Favorites
  Future<List<String>> getFavoriteIds();
  Future<void> addFavorite(String recipeId);
  Future<void> removeFavorite(String recipeId);
  
  // Grocery lists
  Future<String> createGroceryList({...});
  Future<List<GroceryList>> getGroceryLists();
}
```

### Firestore Collections

```
firestore/
├── recipes/
│   └── {recipeId}
│       ├── name: string
│       ├── ingredients: string[]
│       ├── steps: string[]
│       ├── cuisine: string
│       ├── nutrition: map
│       └── ...
├── users/
│   └── {userId}
│       ├── name: string
│       ├── email: string
│       ├── dietary_preferences: string[]
│       ├── allergies: string[]
│       ├── favorite_recipes: string[]
│       └── search_history: map[]
└── grocery_lists/
    └── {listId}
        ├── user_id: string
        ├── name: string
        ├── items: map[]
        └── status: string
```

### Caching Strategy

```dart
// Cache with expiration (30 minutes)
List<Recipe> _cachedRecipes = [];
DateTime? _cacheTimestamp;
static const Duration _cacheExpiration = Duration(minutes: 30);

bool get _isCacheValid {
  if (_cachedRecipes.isEmpty || _cacheTimestamp == null) return false;
  return DateTime.now().difference(_cacheTimestamp!) < _cacheExpiration;
}
```

---

## 🎨 Theme System

### Color Palette

```dart
// Primary Colors
primaryOrange: Color(0xFFFF6B35)    // Main accent
primaryOrangeDark: Color(0xFFE55B2B) // Dark variant

// Accent Colors  
accentGreen: Color(0xFF4CAF50)      // Success, nutrition
accentYellow: Color(0xFFFFB800)     // Ratings, warnings

// Use withValues() instead of deprecated withOpacity()
Colors.black.withValues(alpha: 0.1)  // ✅ Correct
Colors.black.withOpacity(0.1)        // ❌ Deprecated
```

### Spacing System

```dart
xxs: 4.0    // Micro spacing
xs: 8.0     // Small spacing
sm: 12.0    // Component padding
md: 16.0    // Section spacing
lg: 24.0    // Large gaps
xl: 32.0    // Section dividers
xxl: 48.0   // Page padding
xxxl: 64.0  // Hero spacing
```

---

## 🧭 Navigation

### GoRouter with ShellRoute

```dart
final GoRouter appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (_, __) => HomeScreen()),
        GoRoute(path: '/search', builder: (_, __) => SearchScreen()),
        GoRoute(path: '/favorites', builder: (_, __) => FavoritesScreen()),
        GoRoute(path: '/grocery', builder: (_, __) => GroceryListScreen()),
        GoRoute(path: '/profile', builder: (_, __) => ProfileScreen()),
      ],
    ),
    GoRoute(path: '/recipe/:id', builder: (_, state) => RecipeDetailScreen()),
    GoRoute(path: '/scan', builder: (_, __) => ScanScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => OnboardingScreen()),
  ],
);
```

### MainShell with Persistent Navigation

```dart
class MainShell extends StatelessWidget {
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: SmartChefBottomNav(
        currentIndex: _calculateIndex(context),
        onTap: (index) => _navigateTo(context, index),
      ),
    );
  }
}
```

---

## 📊 State Management

### Provider Structure

#### RecipeProvider
- Manages recipes list and favorites
- Local + Firebase sync for favorites
- Cache management

```dart
class RecipeProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];
  Set<String> _favoriteIds = {};
  
  Future<void> loadRecipes() async {
    _recipes = await _firebaseService.getAllRecipes();
    notifyListeners();
  }
  
  void toggleFavorite(String recipeId) {
    // Local update first, then sync to Firebase
    if (_favoriteIds.contains(recipeId)) {
      _favoriteIds.remove(recipeId);
    } else {
      _favoriteIds.add(recipeId);
    }
    notifyListeners();
    _syncToFirebase(recipeId);
  }
}
```

#### UserProvider
- Authentication state
- User profile management
- Theme preferences

#### GroceryListProvider
- Local grocery items
- Firebase grocery lists sync
- Item toggle with immutable pattern

---

## 📦 Models

### Immutable Pattern

All models use `const` constructors and `copyWith` methods:

```dart
class Recipe {
  final String id;
  final String name;
  final List<String> ingredients;
  // ...
  
  const Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    // ...
  });
  
  Recipe copyWith({
    String? id,
    String? name,
    List<String>? ingredients,
    // ...
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
      // ...
    );
  }
}
```

### Available Models

| Model | Description |
|-------|-------------|
| Recipe | Recipe with ingredients, steps, nutrition |
| Nutrition | Calorie and macro information |
| User | User profile for compatibility |
| AppUser | Firebase user with Firestore data |
| GroceryList | List with items and categories |
| GroceryItem | Individual grocery item (immutable) |
| DetectedIngredient | AI detection result |
| BoundingBox | Image detection coordinates |

---

## ✅ Best Practices

### Flutter Best Practices Used

1. **super.key parameter**
   ```dart
   // ✅ Correct
   const MyWidget({super.key});
   
   // ❌ Old way
   const MyWidget({Key? key}) : super(key: key);
   ```

2. **BuildContext async safety**
   ```dart
   Future<void> _doSomething() async {
     await someAsyncOperation();
     if (!mounted) return;  // ✅ Check before using context
     ScaffoldMessenger.of(context).showSnackBar(...);
   }
   ```

3. **Immutable state updates**
   ```dart
   // ✅ Using copyWith
   _items[index] = _items[index].copyWith(checked: !_items[index].checked);
   
   // ❌ Direct mutation
   _items[index].checked = !_items[index].checked;
   ```

4. **Proper error handling**
   ```dart
   try {
     final recipes = await _firebaseService.getAllRecipes();
   } catch (e) {
     debugPrint('Error: $e');
     // Fallback to cached/local data
   }
   ```

---

## 🚀 Quick Start

### Prerequisites

- Flutter SDK >= 3.8.1
- Dart >= 3.0
- Firebase CLI (`npm install -g firebase-tools`)
- FlutterFire CLI (`dart pub global activate flutterfire_cli`)

### Firebase Setup

```bash
# 1. Login to Firebase
firebase login

# 2. Create project in Firebase Console
# https://console.firebase.google.com

# 3. Configure FlutterFire
flutterfire configure --project=YOUR_PROJECT_ID

# 4. Enable services in Firebase Console:
# - Authentication (Anonymous)
# - Cloud Firestore
# - Firebase Storage (optional)
```

### Installation

```bash
# Clone repository
git clone https://github.com/yourusername/smartchefai.git
cd smartchefai

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build Commands

```bash
# Development
flutter run -d chrome        # Web
flutter run -d android       # Android
flutter run -d ios           # iOS

# Release
flutter build apk --release  # Android APK
flutter build appbundle      # Android App Bundle
flutter build ios --release  # iOS
flutter build web --release  # Web
```

---

## 🔮 Future Enhancements

### Phase 2 Features
- [ ] Real AI ingredient detection with Firebase ML Kit
- [ ] Email/password authentication
- [ ] Social login (Google, Apple)
- [ ] Meal planning calendar
- [ ] Recipe sharing with deep links

### Phase 3 Features
- [ ] Community recipes
- [ ] In-app cooking timer with notifications
- [ ] Shopping list sharing via cloud
- [ ] Restaurant recommendations
- [ ] Barcode scanning for packaged ingredients

---

## 📄 License

This project is licensed under the MIT License.

---

## 👥 Contributors

- **SmartChef AI Team**

---

*Last updated: 2025 | Architecture: Firebase + Flutter*
