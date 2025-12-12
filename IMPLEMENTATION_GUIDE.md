# SmartChef AI - Complete Implementation Guide

## Project Overview

SmartChef AI is a comprehensive AI-based personalized recipe recommender system that accepts text, voice, and image inputs to provide intelligent recipe recommendations with nutrition tracking and grocery list generation.

## Project Structure

```
smartchefai/
├── backend/                    # Python Flask backend
│   ├── app.py                 # Main Flask application
│   ├── requirements.txt        # Python dependencies
│   ├── .env.example           # Environment variables template
│   ├── models/
│   │   └── database.py        # Database models (Firestore)
│   ├── services/
│   │   ├── recommendation_engine.py      # TF-IDF + Collaborative filtering
│   │   ├── ingredient_detector.py        # YOLO-based image detection
│   │   ├── grocery_list_generator.py     # Grocery list management
│   │   └── nutrition_calculator.py       # Nutrition tracking
│   ├── routes/
│   │   ├── recipes.py         # Recipe endpoints
│   │   ├── detection.py       # Ingredient detection endpoints
│   │   ├── users.py           # User management endpoints
│   │   └── grocery.py         # Grocery list endpoints
│   └── ml_models/             # Pre-trained models storage
│
├── lib/                        # Flutter mobile app
│   ├── main.dart              # Main app entry point
│   ├── models/
│   │   └── models.dart        # Data models
│   ├── services/
│   │   └── api_service.dart   # API client
│   ├── providers/
│   │   └── app_providers.dart # State management (Provider pattern)
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── search_screen.dart
│   │   ├── favorites_screen.dart
│   │   ├── grocery_list_screen.dart
│   │   └── profile_screen.dart
│   ├── widgets/               # Reusable widgets
│   ├── utils/                 # Utility functions
│   └── assets/                # Images, fonts, icons
│
├── data/
│   └── recipes.json           # Sample recipe dataset (100+ recipes)
│
└── pubspec.yaml               # Flutter dependencies

```

## Backend Setup

### Prerequisites
- Python 3.8+
- Firebase account and credentials
- Google Cloud API key (for speech-to-text)

### Installation

1. Navigate to backend directory:
```bash
cd backend
```

2. Create Python virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

4. Set up environment variables:
```bash
cp .env.example .env
# Edit .env with your Firebase credentials and API keys
```

5. Run the Flask server:
```bash
python app.py
```

Server will run on `http://localhost:5000`

### API Endpoints

#### Recipes
- `GET /api/recipes/all` - Get all recipes
- `GET /api/recipes/<recipe_id>` - Get recipe by ID
- `POST /api/recipes/search` - Search recipes by text
- `POST /api/recipes/by-ingredients` - Search by ingredients

#### Ingredient Detection
- `POST /api/detect/ingredients` - Detect ingredients from image
- `POST /api/detect/ingredients-and-recipes` - Detect and find recipes

#### Users
- `POST /api/users` - Create user
- `GET /api/users/<user_id>` - Get user profile
- `POST /api/users/<user_id>/preferences` - Set dietary preferences
- `GET /api/users/<user_id>/favorites` - Get favorite recipes
- `POST /api/users/<user_id>/favorites/add` - Add favorite
- `POST /api/users/<user_id>/favorites/remove` - Remove favorite
- `GET /api/users/<user_id>/recommendations` - Get personalized recommendations

#### Grocery Lists
- `POST /api/grocery-lists` - Create grocery list
- `GET /api/grocery-lists/<list_id>` - Get grocery list
- `GET /api/grocery-lists/user/<user_id>` - Get user's lists
- `PUT /api/grocery-lists/<list_id>` - Update grocery list
- `DELETE /api/grocery-lists/<list_id>` - Delete grocery list
- `POST /api/grocery-lists/<list_id>/toggle-item` - Toggle item status

## Frontend Setup (Flutter)

### Prerequisites
- Flutter SDK 3.8+
- Dart SDK
- Android Studio or Xcode (for emulator)

### Installation

1. Install Flutter dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

### Features Implemented

#### Core Screens
1. **Home Screen** - Search bar with text/voice/camera options, featured recipes
2. **Search Screen** - Advanced recipe search with filters
3. **Recipe Detail** - Full recipe view with nutrition, ingredients, steps
4. **Camera/Image** - Ingredient detection from photos
5. **Favorites** - Saved recipes collection
6. **Grocery List** - Categorized shopping lists
7. **Profile** - User preferences and dietary settings

#### Key Features
- ✅ Multi-modal input (text, voice, image)
- ✅ Real-time search with TF-IDF matching
- ✅ Image-based ingredient detection (YOLO)
- ✅ Personalized recommendations (collaborative filtering)
- ✅ Grocery list generation and management
- ✅ Nutrition tracking and analysis
- ✅ User profile and preferences
- ✅ Favorites management
- ✅ Offline recipe caching

## Database Schema

### Recipes Collection
```json
{
  "id": "string",
  "name": "string",
  "ingredients": ["string"],
  "steps": ["string"],
  "prep_time": "string",
  "cook_time": "string",
  "difficulty": "easy|medium|hard",
  "cuisine": "string",
  "dietary_tags": ["vegetarian", "vegan", "gluten-free", "keto"],
  "nutrition": {
    "calories": "integer",
    "protein": "string",
    "carbs": "string",
    "fat": "string",
    "fiber": "string"
  },
  "servings": "integer",
  "image_url": "string",
  "created_at": "timestamp"
}
```

### Users Collection
```json
{
  "id": "string",
  "name": "string",
  "email": "string",
  "dietary_preferences": ["string"],
  "allergies": ["string"],
  "favorite_recipes": ["string"],
  "search_history": [
    {
      "query": "string",
      "timestamp": "timestamp"
    }
  ],
  "created_at": "timestamp"
}
```

### Grocery Lists Collection
```json
{
  "id": "string",
  "user_id": "string",
  "items": [
    {
      "name": "string",
      "quantity": "float",
      "unit": "string",
      "category": "string",
      "checked": "boolean",
      "recipes": ["string"]
    }
  ],
  "total_items": "integer",
  "recipes": ["string"],
  "status": "active|completed",
  "created_at": "timestamp"
}
```

## Advanced Features

### 1. Recommendation Engine
- **TF-IDF Vectorization**: Converts recipes and queries into comparable vectors
- **Cosine Similarity**: Measures similarity between queries and recipes
- **Collaborative Filtering**: Recommends recipes based on user history
- **Fuzzy Matching**: Handles ingredient name variations

### 2. Ingredient Detection
- **YOLO v5/v8**: Pre-trained for food item detection
- **Confidence Scoring**: Returns confidence level for each detection
- **Bounding Boxes**: Shows location of detected items
- **Multi-item Support**: Handles multiple foods in one image

### 3. Nutrition Tracking
- **Per-serving Calculation**: Nutrition info adjusted for servings
- **Macro Percentages**: Shows protein/carbs/fat breakdown
- **Dietary Compliance**: Checks recipes against dietary requirements
- **Combined Analysis**: Nutrition for multiple recipes

### 4. Grocery List Intelligence
- **Auto-categorization**: Groups items by type (produce, dairy, etc.)
- **Deduplication**: Consolidates same ingredients from multiple recipes
- **Quantity Calculation**: Adjusts quantities based on servings
- **Checkbox Tracking**: Check off items as purchased

## Sample Data

The project includes **100+ diverse recipes** covering:
- **Cuisines**: Italian, Indian, Thai, Mexican, American, Mediterranean, Greek, Japanese, Russian
- **Meal Types**: Breakfast, lunch, dinner, snacks, desserts
- **Dietary Types**: Vegetarian, vegan, gluten-free, low-carb, keto
- **Difficulty Levels**: Easy, medium, hard
- **Nutrition**: Calculated for each recipe with macro/micro nutrients

All recipes are stored in `data/recipes.json` and can be imported into Firebase Firestore.

## Configuration

### Environment Variables (Backend)
```
FLASK_ENV=development
FLASK_DEBUG=True
FIREBASE_CREDENTIALS_PATH=./firebase-credentials.json
GOOGLE_CLOUD_PROJECT_ID=your_project_id
SECRET_KEY=your_secret_key
PORT=5000
```

### API Configuration (Frontend)
Update `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://localhost:5000/api';  // Local development
// Change to deployed backend URL for production
```

## Deployment

### Backend (Flask)
1. Set `FLASK_DEBUG=False` in production
2. Use Gunicorn as WSGI server
3. Deploy to Heroku, AWS, GCP, or Azure
4. Set up Firestore database in production

### Frontend (Flutter)
1. Build for Android:
```bash
flutter build apk --release
```

2. Build for iOS:
```bash
flutter build ios --release
```

3. Deploy to Google Play Store or Apple App Store

## Development Roadmap

### Phase 1 ✅ (Completed)
- [x] Backend Flask structure
- [x] Database models
- [x] API endpoints
- [x] Recommendation engine
- [x] Nutrition calculator
- [x] Grocery list generator
- [x] Flutter UI screens
- [x] State management
- [x] API integration

### Phase 2 (To Implement)
- [ ] Image ingredient detection (YOLO setup)
- [ ] Voice-to-text integration
- [ ] Firebase authentication
- [ ] Real-time notifications
- [ ] Cloud storage for images
- [ ] Advanced filters and sorting

### Phase 3 (Future)
- [ ] Social features (sharing, reviews)
- [ ] Recipe ratings and comments
- [ ] Meal planning feature
- [ ] Shopping list price tracking
- [ ] Nutrition goal tracking
- [ ] Recipe suggestions via ML

## Testing

### Backend Tests
```bash
cd backend
pytest tests/
```

### Frontend Tests
```bash
flutter test
```

## Troubleshooting

### Backend Issues
- **Firebase Auth**: Ensure credentials JSON is valid
- **YOLO Model**: Download pre-trained weights if missing
- **Dependencies**: Run `pip install --upgrade` for compatibility

### Frontend Issues
- **Dependency Errors**: Run `flutter pub get`
- **Build Issues**: Clear build with `flutter clean`
- **API Connection**: Check backend URL in api_service.dart

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/improvement`)
3. Commit changes (`git commit -m 'Add improvement'`)
4. Push to branch (`git push origin feature/improvement`)
5. Open Pull Request

## License

MIT License - See LICENSE file for details

## Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Email: support@smartchefai.com
- Documentation: Full API docs available at `/api/docs`

---

**SmartChef AI v1.0** - Building the future of personalized nutrition
