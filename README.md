# SmartChef AI 🍳

An AI-powered recipe recommendation app built with Flutter and Firebase. Get personalized recipe suggestions, detect ingredients from photos, and manage your grocery lists - all in one beautiful app.

## ✨ Features

- **🔍 Smart Recipe Search** - Search by name, cuisine, or ingredients
- **📸 Ingredient Detection** - Take a photo of your ingredients and get recipe suggestions
- **❤️ Favorites** - Save your favorite recipes for quick access
- **🛒 Grocery Lists** - Generate shopping lists from recipes
- **👤 User Profiles** - Personalized recommendations based on dietary preferences
- **🌙 Dark Mode** - Beautiful light and dark themes
- **🎤 Voice Search** - Search recipes using voice commands

## 🏗️ Architecture

### Tech Stack

- **Frontend**: Flutter 3.8+ with Material Design 3
- **Backend**: Firebase (Firestore, Authentication)
- **Recipe Data**: TheMealDB API + Local JSON cache
- **State Management**: Provider pattern
- **Navigation**: GoRouter with ShellRoute

### Project Structure

```
lib/
├── app/                    # App configuration
│   ├── routes.dart         # GoRouter configuration
│   └── theme/              # Theme definitions
├── features/               # Feature modules
│   ├── home/               # Home screen
│   ├── search/             # Search functionality
│   ├── favorites/          # Favorites management
│   ├── grocery/            # Grocery lists
│   ├── profile/            # User profile
│   ├── scan/               # Ingredient detection
│   └── recipe_detail/      # Recipe details
├── models/                 # Data models
├── providers/              # State management
├── services/               # Firebase & API services
│   └── firebase_service.dart
└── shared/                 # Shared widgets
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.8.1 or higher
- Firebase CLI
- Android Studio / Xcode

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/smartchefai.git
   cd smartchefai
   ```

2. **Set up Firebase**
   
   Follow the detailed guide in [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
   
   Quick setup:
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase
   flutterfire configure --project=YOUR_PROJECT_ID
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔥 Firebase Configuration

This app uses Firebase for:
- **Firestore** - Recipe caching, user profiles, grocery lists
- **Authentication** - Anonymous sign-in for guests, email/password for registered users
- **Storage** - (Optional) Image uploads

See [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for complete setup instructions.

## 📱 Screenshots

| Home | Search | Recipe Detail | Favorites |
|------|--------|---------------|-----------|
| ![Home](screenshots/home.png) | ![Search](screenshots/search.png) | ![Detail](screenshots/detail.png) | ![Favorites](screenshots/favorites.png) |

## 🔌 API Sources

- **TheMealDB** - Free recipe database with 300+ recipes
- **Local JSON** - Additional curated recipes in `data/recipes.json`

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| firebase_core | Firebase initialization |
| cloud_firestore | Database |
| firebase_auth | Authentication |
| provider | State management |
| go_router | Navigation |
| dio | HTTP client |
| cached_network_image | Image caching |
| speech_to_text | Voice search |
| image_picker | Photo capture |
| flutter_animate | Animations |

## 🛠️ Development

### Running Tests
```bash
flutter test
```

### Building for Release
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📧 Contact

Your Name - [@yourtwitter](https://twitter.com/yourtwitter)

Project Link: [https://github.com/yourusername/smartchefai](https://github.com/yourusername/smartchefai)