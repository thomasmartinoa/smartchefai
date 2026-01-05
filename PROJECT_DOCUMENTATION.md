# SmartChef AI - Complete Project Documentation

> **AI-Powered Recipe Recommender with Smart Ingredient Detection**  
> Version: 2.1.0 | Architecture: Firebase + Flutter | Last Updated: January 2026

---

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [Technology Stack](#technology-stack)
3. [Architecture](#architecture)
4. [Project Structure](#project-structure)
5. [Installation & Setup](#installation--setup)
6. [Firebase Configuration](#firebase-configuration)
7. [Features](#features)
8. [Frontend (Flutter)](#frontend-flutter)
   - [Theme System](#theme-system)
   - [Navigation](#navigation)
   - [State Management](#state-management)
   - [Screens](#screens)
   - [Widgets](#widgets)
   - [Models](#models)
9. [Data Layer](#data-layer)
10. [API Integration](#api-integration)
11. [Development Guide](#development-guide)
12. [Best Practices](#best-practices)
13. [Build & Deployment](#build--deployment)
14. [Testing](#testing)
15. [Future Enhancements](#future-enhancements)
16. [Troubleshooting](#troubleshooting)
17. [License](#license)

---

## 🎯 Project Overview

**SmartChef AI** is a comprehensive mobile and web application that revolutionizes the cooking experience by providing personalized recipe recommendations, AI-powered ingredient detection, and smart meal planning capabilities.

### Key Features

- � **User Authentication**: Secure login/signup with email & password, anonymous mode
- 🔍 **Smart Recipe Search**: Text and voice-powered search with instant results
- 📸 **Ingredient Detection**: AI-powered camera scan to identify ingredients
- 💝 **Favorites Management**: Save and organize favorite recipes
- 🛒 **Smart Grocery Lists**: Auto-generate shopping lists from recipes
- 📊 **Nutrition Tracking**: Detailed nutritional information for every recipe
- 👤 **User Profiles**: Personalized experience with dietary preferences
- 🎯 **Dietary Preferences**: Custom filters for allergies and diet types
- 🌙 **Dark Mode**: Full theme customization support
- 🎨 **Modern UI**: Material 3 design with smooth animations
- 🔥 **Firebase Integration**: Serverless backend with real-time sync
- 📴 **Offline Support**: Works without internet via local caching

### Target Platforms

- ✅ Android (Mobile & Tablet)
- ✅ iOS (iPhone & iPad)
- ✅ Web (Chrome, Firefox, Safari, Edge)
- ✅ Windows, macOS, Linux (Desktop)

---

## 🛠 Technology Stack

### Frontend

| Category | Technology | Version | Purpose |
|----------|------------|---------|---------|
| Framework | Flutter | 3.8.1+ | Cross-platform UI framework |
| Language | Dart | 3.0+ | Programming language |
| State Management | Provider | 6.0.0 | Reactive state management |
| Navigation | GoRouter | 10.0.0 | Declarative routing with ShellRoute |
| HTTP Client | Dio | 5.3.0 | Network requests with retry |
| Local Storage | SharedPreferences | 2.2.0 | Key-value storage |
| Image Caching | cached_network_image | 3.3.0 | Image loading & caching |
| Voice Input | speech_to_text | 7.3.0 | On-device speech recognition |
| Image Picker | image_picker | 1.0.0 | Camera & gallery access |
| Animations | flutter_animate | 4.1.0 | Declarative animations |

### Backend (Firebase)

| Service | Purpose |
|---------|---------|
| **Cloud Firestore** | NoSQL database for recipes, users, grocery lists |
| **Firebase Auth** | User authentication (anonymous, email) |
| **Firebase Storage** | Image storage (optional) |
| **Firebase Hosting** | Web app hosting (optional) |

### External APIs

| API | Purpose | Rate Limit |
|-----|---------|------------|
| **TheMealDB** | Recipe data source (backup) | Unlimited (free) |

---

## 🏗 Architecture

### Serverless Firebase Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter App                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │   Screens   │  │  Providers  │  │   Widgets   │     │
│  │  (UI Layer) │  │   (State)   │  │ (Components)│     │
│  └──────┬──────┘  └──────┬──────┘  └─────────────┘     │
│         │                │                              │
│         └────────┬───────┘                              │
│                  ▼                                      │
│         ┌───────────────┐                              │
│         │FirebaseService│ ◄── Singleton Pattern        │
│         │  (Data Layer) │                              │
│         └───────┬───────┘                              │
└─────────────────┼───────────────────────────────────────┘
                  │
        ┌─────────┼─────────┐
        ▼         ▼         ▼
┌──────────┐ ┌──────────┐ ┌──────────┐
│ Firestore│ │  Auth    │ │TheMealDB │
│(Database)│ │ (Users)  │ │(Fallback)│
└──────────┘ └──────────┘ └──────────┘
```

### Design Principles

1. **Serverless**: No backend server to maintain
2. **Offline-First**: Local cache + Firestore persistence
3. **Immutable Models**: Safe state updates with copyWith
4. **Single Responsibility**: Each class has one job
5. **Graceful Degradation**: Fallbacks at every level

---

## 📁 Project Structure

```
smartchefai/
├── lib/
│   ├── main.dart                    # App entry + Firebase init
│   ├── firebase_options.dart        # Firebase configuration
│   │
│   ├── app/                         # App-level configuration
│   │   ├── routes.dart              # GoRouter with ShellRoute
│   │   └── theme/
│   │       ├── theme.dart           # Barrel export
│   │       ├── app_colors.dart      # Color system
│   │       ├── app_typography.dart  # Text styles
│   │       ├── app_spacing.dart     # Spacing constants
│   │       └── app_theme.dart       # ThemeData config
│   │
│   ├── features/                    # Feature-based screens
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   ├── search/
│   │   │   └── search_screen.dart
│   │   ├── recipe_detail/
│   │   │   └── recipe_detail_screen.dart
│   │   ├── favorites/
│   │   │   └── favorites_screen.dart
│   │   ├── grocery/
│   │   │   └── grocery_list_screen.dart
│   │   ├── profile/
│   │   │   └── profile_screen.dart
│   │   ├── scan/
│   │   │   └── scan_screen.dart
│   │   └── onboarding/
│   │       └── onboarding_screen.dart
│   │
│   ├── shared/                      # Shared components
│   │   └── widgets/
│   │       ├── widgets.dart         # Barrel export
│   │       ├── recipe_card.dart
│   │       ├── common_widgets.dart
│   │       ├── ingredient_nutrition_widgets.dart
│   │       └── navigation_widgets.dart
│   │
│   ├── models/
│   │   └── models.dart              # Immutable data models
│   │
│   ├── providers/
│   │   ├── app_providers.dart       # Re-export
│   │   └── firebase_providers.dart  # State management
│   │
│   ├── services/
│   │   └── firebase_service.dart    # Firebase + API client
│   │
│   └── widgets/
│       └── custom_widgets.dart      # Legacy widgets
│
├── data/
│   └── recipes.json                 # Local recipe fallback
│
├── android/                         # Android configuration
├── ios/                             # iOS configuration
├── web/                             # Web configuration
├── windows/                         # Windows configuration
├── macos/                           # macOS configuration
├── linux/                           # Linux configuration
│
├── pubspec.yaml                     # Flutter dependencies
├── analysis_options.yaml            # Lint rules
├── FIREBASE_SETUP.md               # Firebase setup guide
├── claude.md                        # Project documentation
└── README.md                        # Quick start guide
```

---

## 🚀 Installation & Setup

### Prerequisites

- **Flutter SDK**: >= 3.8.1
- **Dart SDK**: >= 3.0
- **Firebase CLI**: `npm install -g firebase-tools`
- **FlutterFire CLI**: `dart pub global activate flutterfire_cli`
- **IDE**: VS Code or Android Studio

### Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/smartchefai.git
cd smartchefai

# 2. Install Flutter dependencies
flutter pub get

# 3. Configure Firebase (see Firebase Configuration section)
flutterfire configure --project=your-project-id

# 4. Run the app
flutter run
```

---

## 🔥 Firebase Configuration

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Create a project"
3. Enter project name: `smartchefai`
4. Disable Google Analytics (optional)
5. Click "Create project"

### Step 2: Enable Services

#### Authentication
1. Go to **Build > Authentication**
2. Click "Get started"
3. Enable the following sign-in methods:
   - **Email/Password**: For standard authentication
   - **Anonymous**: For guest access
   - **Google** (Optional): For social login

#### Cloud Firestore
1. Go to **Build > Firestore Database**
2. Click "Create database"
3. Select region closest to your users
4. Start in **test mode** for development

#### Security Rules (Production)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Recipes are readable by anyone, writable by authenticated users
    match /recipes/{recipeId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Grocery lists belong to users
    match /grocery_lists/{listId} {
      allow read, write: if request.auth != null 
        && resource.data.user_id == request.auth.uid;
    }
  }
}
```

### Step 3: Configure Flutter

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Login to Firebase
firebase login

# Configure your Flutter app
flutterfire configure --project=your-project-id
```

This generates `lib/firebase_options.dart` with your configuration.

---

## ✨ Features

### 1. Authentication Flow
- **Get Started Screen**: Welcome page with app overview and call-to-action
- **Login Screen**: Email/password authentication with "Remember Me" option
- **Signup Screen**: New user registration with email validation
- **Forgot Password**: Password reset via email link
- **Anonymous Mode**: Quick access without account creation
- Firebase Auth integration with secure session management

### 2. Home Screen
- Personalized greeting based on time of day
- Quick category access (Chicken, Beef, Vegetarian, etc.)
- Featured recipes carousel
- Popular recipes grid
- Quick actions: Search, Scan, Grocery

### 3. Smart Search
- Text input with instant results
- Voice search using speech_to_text
- Category filter chips
- Recent searches (stored in Firestore)
- Ingredient-based search

### 4. Ingredient Scanner
- Camera capture for ingredient photos
- Gallery selection
- Mock AI detection (placeholder for ML Kit)
- Recipe suggestions based on detected ingredients

### 5. Recipe Detail
- Hero image with gradient overlay
- Ingredient list with servings adjuster
- Step-by-step instructions
- Nutrition information cards
- Add to favorites
- Add ingredients to grocery list

### 6. Favorites
- Grid view of saved recipes
- Local + Cloud sync
- Offline access to favorites
- Quick remove functionality

### 7. Grocery List
- Manual item entry
- Auto-add from recipes
- Check/uncheck items (immutable pattern)
- Clear completed items
- Category grouping

### 8. Profile & Settings
- User info display (name, email, join date)
- Account management (update profile, change password)
- App settings (dark mode, notifications)
- Logout functionality

### 9. Dietary Preferences
- Dietary restrictions (Vegetarian, Vegan, Gluten-Free, etc.)
- Allergy management (Nuts, Dairy, Shellfish, etc.)
- Cuisine preferences
- Calorie goals and macro tracking
- Recipe filtering based on preferences

---

## 🎨 Theme System

### Colors

```dart
class AppColors {
  // Primary
  static const primaryOrange = Color(0xFFFF6B35);
  static const primaryOrangeDark = Color(0xFFE55B2B);
  
  // Accent
  static const accentGreen = Color(0xFF4CAF50);
  static const accentYellow = Color(0xFFFFB800);
  
  // Background
  static const backgroundLight = Color(0xFFFAFAFA);
  static const backgroundDark = Color(0xFF121212);
  
  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [primaryOrange, primaryOrangeDark],
  );
}
```

### Spacing

```dart
class AppSpacing {
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}
```

### Typography

```dart
class AppTypography {
  static const displayLarge = TextStyle(fontSize: 57, fontWeight: FontWeight.bold);
  static const headlineLarge = TextStyle(fontSize: 32, fontWeight: FontWeight.w600);
  static const titleLarge = TextStyle(fontSize: 22, fontWeight: FontWeight.w600);
  static const bodyLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.normal);
  static const labelLarge = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
}
```

---

## 🧭 Navigation

### GoRouter Configuration

```dart
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Shell route for persistent bottom navigation
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
        GoRoute(path: '/favorites', builder: (_, __) => const FavoritesScreen()),
        GoRoute(path: '/grocery', builder: (_, __) => const GroceryListScreen()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      ],
    ),
    // Routes outside shell (no bottom nav)
    GoRoute(
      path: '/recipe/:id',
      builder: (_, state) => RecipeDetailScreen(
        recipeId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(path: '/scan', builder: (_, __) => const ScanScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
  ],
);
```

### Navigation Helpers

```dart
// Navigate with GoRouter
context.go('/search');
context.go('/recipe/${recipe.id}');
context.push('/scan');

// Pop back
context.pop();
```

---

## 📊 State Management

### Provider Architecture

```dart
// In main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => RecipeProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => GroceryListProvider()),
  ],
  child: MyApp(),
)
```

### RecipeProvider

```dart
class RecipeProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  List<Recipe> _recipes = [];
  Set<String> _favoriteIds = {};
  bool _isLoading = false;
  
  // Getters
  List<Recipe> get recipes => _recipes;
  List<Recipe> get favorites => _recipes.where((r) => _favoriteIds.contains(r.id)).toList();
  bool get isLoading => _isLoading;
  
  // Methods
  Future<void> loadRecipes() async {
    _isLoading = true;
    notifyListeners();
    
    _recipes = await _firebaseService.getAllRecipes();
    
    _isLoading = false;
    notifyListeners();
  }
  
  void toggleFavorite(String recipeId) {
    if (_favoriteIds.contains(recipeId)) {
      _favoriteIds.remove(recipeId);
      _firebaseService.removeFavorite(recipeId);
    } else {
      _favoriteIds.add(recipeId);
      _firebaseService.addFavorite(recipeId);
    }
    notifyListeners();
  }
}
```

### Usage in Widgets

```dart
// Reading state
final recipes = context.watch<RecipeProvider>().recipes;
final isLoading = context.select<RecipeProvider, bool>((p) => p.isLoading);

// Calling methods
context.read<RecipeProvider>().loadRecipes();
context.read<RecipeProvider>().toggleFavorite(recipe.id);
```

---

## 📦 Models

### Recipe Model

```dart
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
  final double? rating;

  const Recipe({
    required this.id,
    required this.name,
    // ...
  });

  // Factory for JSON parsing
  factory Recipe.fromJson(Map<String, dynamic> json);
  
  // Serialize to JSON
  Map<String, dynamic> toJson();
  
  // Immutable copy
  Recipe copyWith({
    String? id,
    String? name,
    // ...
  });
}
```

### All Models

| Model | Fields | Purpose |
|-------|--------|---------|
| `Recipe` | id, name, ingredients, steps, nutrition, etc. | Recipe data |
| `Nutrition` | calories, protein, carbs, fat, fiber | Nutritional info |
| `User` | id, name, email, preferences, allergies | User profile (legacy) |
| `AppUser` | id, name, email, + searchHistory | Firebase user |
| `GroceryList` | id, userId, name, items, status | Shopping list |
| `GroceryItem` | name, quantity, unit, category, checked | List item |
| `DetectedIngredient` | name, confidence, bbox | AI detection |
| `BoundingBox` | x1, y1, x2, y2 | Detection coordinates |

---

## ✅ Best Practices

### 1. Use super.key Parameter

```dart
// ✅ Modern Dart 3.0 syntax
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
}

// ❌ Old syntax
class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);
}
```

### 2. Check mounted Before Using Context

```dart
Future<void> _loadData() async {
  final data = await fetchData();
  
  // ✅ Safe to use context
  if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(...);
}
```

### 3. Use withValues() Instead of withOpacity()

```dart
// ✅ New API (avoids precision loss)
Colors.black.withValues(alpha: 0.5)

// ❌ Deprecated
Colors.black.withOpacity(0.5)
```

### 4. Immutable State Updates

```dart
// ✅ Using copyWith
_items[i] = _items[i].copyWith(checked: true);

// ❌ Direct mutation
_items[i].checked = true;
```

### 5. Const Constructors

```dart
// ✅ Use const where possible
const SizedBox(height: 16)
const Text('Hello')
const EdgeInsets.all(16)

// This enables Flutter optimizations
```

---

## 🏗 Build & Deployment

### Development

```bash
# Run on specific device
flutter run -d chrome
flutter run -d android
flutter run -d ios

# Run with verbose logging
flutter run --verbose
```

### Release Builds

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS (requires macOS)
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release
```

### Deploy Web to Firebase Hosting

```bash
# Build web
flutter build web --release

# Deploy
firebase deploy --only hosting
```

---

## 🧪 Testing

### Run Tests

```bash
# All tests
flutter test

# Specific test file
flutter test test/models_test.dart

# With coverage
flutter test --coverage
```

### Analyze Code

```bash
# Run analyzer
flutter analyze

# Format code
dart format lib/
```

---

## 🔮 Future Enhancements

### Phase 2
- [ ] Real AI ingredient detection with Firebase ML Kit
- [ ] Email/password authentication
- [ ] Social login (Google, Apple Sign-In)
- [ ] Meal planning calendar
- [ ] Recipe sharing with deep links
- [ ] Push notifications for meal reminders

### Phase 3
- [ ] Community recipes
- [ ] In-app cooking timer
- [ ] Shopping list sharing
- [ ] Restaurant recommendations
- [ ] Barcode scanning for packaged ingredients
- [ ] Multi-language support

---

## 🔧 Troubleshooting

### Common Issues

#### Firebase Not Initialized
```
Error: Firebase has not been correctly initialized
```
**Solution**: Run `flutterfire configure` and ensure `Firebase.initializeApp()` is called in `main()`.

#### Firestore Permission Denied
```
Error: [cloud_firestore/permission-denied]
```
**Solution**: Check Firestore security rules and ensure user is authenticated.

#### Android Build Fails
```
Error: Execution failed for task ':app:processDebugGoogleServices'
```
**Solution**: Ensure `google-services.json` is in `android/app/`.

#### iOS Build Fails
```
Error: GoogleService-Info.plist not found
```
**Solution**: Add `GoogleService-Info.plist` to `ios/Runner/` via Xcode.

### Debug Commands

```bash
# Check Flutter environment
flutter doctor -v

# Clean build
flutter clean
flutter pub get

# Rebuild Gradle
cd android && ./gradlew clean
```

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 👥 Contributors

- **SmartChef AI Team**

---

*Documentation Version: 2.1.0 | Last Updated: January 2026*
