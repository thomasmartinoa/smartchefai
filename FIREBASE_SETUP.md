# Firebase Setup Guide for SmartChef AI

This guide will help you set up Firebase for the SmartChef AI application.

## Prerequisites

- Flutter SDK installed
- Firebase CLI installed (`npm install -g firebase-tools`)
- A Google account

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: `smartchefai` (or your preferred name)
4. Enable/disable Google Analytics as you prefer
5. Click "Create project"

## Step 2: Add Firebase to Flutter App

### Option A: Using FlutterFire CLI (Recommended)

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure --project=YOUR_PROJECT_ID
```

This will automatically:
- Register your app with Firebase
- Generate `firebase_options.dart`
- Configure platform-specific files

### Option B: Manual Setup

#### For Android:

1. In Firebase Console, click "Add app" → Android
2. Package name: `com.smartchef.smartchefai`
3. Download `google-services.json`
4. Place it in `android/app/google-services.json`
5. Update `android/build.gradle.kts`:
   ```kotlin
   plugins {
       id("com.google.gms.google-services") version "4.4.0" apply false
   }
   ```
6. Update `android/app/build.gradle.kts`:
   ```kotlin
   plugins {
       id("com.google.gms.google-services")
   }
   ```

#### For iOS:

1. In Firebase Console, click "Add app" → iOS
2. Bundle ID: `com.smartchef.smartchefai`
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/GoogleService-Info.plist`
5. Open Xcode and add the file to Runner target

#### For Web:

1. In Firebase Console, click "Add app" → Web
2. Copy the configuration object
3. Update `web/index.html` with Firebase SDK scripts

## Step 3: Enable Firebase Services

### Firestore Database

1. Go to Firebase Console → Firestore Database
2. Click "Create database"
3. Choose "Start in test mode" for development
4. Select a Cloud Firestore location near your users

### Authentication

1. Go to Firebase Console → Authentication
2. Click "Get started"
3. Enable "Anonymous" sign-in method (for guest users)
4. Optionally enable "Email/Password" for registered users

### Storage (Optional - for image uploads)

1. Go to Firebase Console → Storage
2. Click "Get started"
3. Start in test mode for development

## Step 4: Firestore Security Rules

For development, use these rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Recipes - publicly readable
    match /recipes/{recipeId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Users - authenticated users only
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Grocery lists - authenticated users only
    match /grocery_lists/{listId} {
      allow read, write: if request.auth != null 
        && resource.data.user_id == request.auth.uid;
      allow create: if request.auth != null;
    }
  }
}
```

For production, use more restrictive rules.

## Step 5: Update main.dart

After running `flutterfire configure`, update your `main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // ... rest of initialization
}
```

## Step 6: Run the App

```bash
flutter pub get
flutter run
```

## Firestore Data Structure

### Collections:

```
recipes/
  {recipeId}/
    - name: string
    - ingredients: array<string>
    - steps: array<string>
    - prep_time: string
    - cook_time: string
    - difficulty: string
    - cuisine: string
    - dietary_tags: array<string>
    - nutrition: map
    - servings: number
    - image_url: string

users/
  {userId}/
    - name: string
    - email: string
    - dietary_preferences: array<string>
    - allergies: array<string>
    - favorite_recipes: array<string>
    - search_history: array<map>
    - created_at: timestamp
    - updated_at: timestamp

grocery_lists/
  {listId}/
    - user_id: string
    - name: string
    - items: array<map>
    - created_at: timestamp
    - updated_at: timestamp
    - status: string
```

## Troubleshooting

### Firebase initialization failed
- Ensure `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) is in the correct location
- Run `flutter clean` and rebuild

### Firestore permission denied
- Check your security rules
- Ensure the user is authenticated

### Network errors
- Check your internet connection
- Ensure Firebase project is not on Spark plan limits

## Cost Considerations

Firebase Spark (Free) plan includes:
- 50K reads/day
- 20K writes/day
- 20K deletes/day
- 1 GiB storage
- 10 GiB bandwidth/month

This is sufficient for development and small user bases.
