# SmartChef AI - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### 1. Backend Setup (Python/Flask)

```bash
# Navigate to backend directory
cd backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Set up environment file
cp .env.example .env

# Update .env with your Firebase credentials (if using Firebase)
# For now, you can skip Firebase for local development

# Run the Flask server
python app.py
```

Server will start on `http://localhost:5000`

### Test the Backend

```bash
# In another terminal, test the API:

# Get all recipes
curl http://localhost:5000/api/recipes/all

# Search recipes
curl -X POST http://localhost:5000/api/recipes/search \
  -H "Content-Type: application/json" \
  -d '{"query": "pasta", "limit": 10}'

# Search by ingredients
curl -X POST http://localhost:5000/api/recipes/by-ingredients \
  -H "Content-Type: application/json" \
  -d '{"ingredients": ["tomato", "basil"], "limit": 10}'

# Health check
curl http://localhost:5000/api/health
```

### 2. Frontend Setup (Flutter)

```bash
# Navigate to project root
cd ..

# Install Flutter dependencies
flutter pub get

# Run the app
flutter run

# For web (if enabled):
flutter run -d chrome

# For Android:
flutter run -d android-device

# For iOS:
flutter run -d ios-device
```

## 📋 What's Included

### Backend Features ✅

- **API Endpoints**: 15+ RESTful endpoints
- **Recipe Management**: Search, filter, detailed recipes
- **Recommendation Engine**: TF-IDF + Cosine Similarity
- **Ingredient Detection**: YOLO-ready structure
- **Nutrition Tracking**: Per-serving and per-recipe calculations
- **Grocery Lists**: Auto-categorization and consolidation
- **User Management**: Preferences, favorites, history

### Frontend Features ✅

- **Home Screen**: Featured recipes and quick search
- **Search**: Advanced recipe filtering
- **Recipe Details**: Full information and nutrition
- **Favorites**: Save and manage favorites
- **Grocery Lists**: Create and manage shopping lists
- **Profile**: User settings and preferences
- **State Management**: Provider pattern
- **API Integration**: Dio HTTP client

### Data ✅

- **100+ Recipes**: Diverse cuisines and dietary types
- **Rich Metadata**: Nutrition, difficulty, prep time
- **Image URLs**: Placeholder images for all recipes

## 🔄 API Examples

### Search Recipes
```bash
POST /api/recipes/search
{
  "query": "pasta carbonara",
  "limit": 15,
  "filters": {
    "cuisine": "Italian",
    "difficulty": "medium"
  }
}
```

### Detect Ingredients
```bash
POST /api/detect/ingredients
(multipart form with 'image' file)
```

### Get Personalized Recommendations
```bash
GET /api/users/{userId}/recommendations?limit=10
```

### Create Grocery List
```bash
POST /api/grocery-lists
{
  "user_id": "user123",
  "recipe_ids": ["recipe1", "recipe2"],
  "servings_multipliers": {"recipe1": 2}
}
```

## 🎨 Key Components

### Backend Components
1. **RecipeModel** - Recipe CRUD operations
2. **RecommendationEngine** - Search and recommendations
3. **IngredientDetector** - Image ingredient detection (YOLO)
4. **GroceryListGenerator** - List generation and categorization
5. **NutritionCalculator** - Nutrition analysis

### Frontend Components
1. **RecipeProvider** - Recipe state management
2. **UserProvider** - User authentication & preferences
3. **GroceryListProvider** - Grocery list management
4. **ApiService** - HTTP client
5. **MainScaffold** - Navigation bar

## 📦 Dependencies

### Python (Backend)
- Flask 2.3+ - Web framework
- Firebase Admin SDK - Database
- scikit-learn - ML algorithms
- torch/torchvision - ML models
- OpenCV - Image processing
- Pillow - Image handling

### Dart (Frontend)
- Provider - State management
- Dio - HTTP client
- Firebase - Backend services
- Image picker - Photo selection
- Speech to text - Voice input
- FL Chart - Data visualization

## 🔧 Configuration

### Backend (.env)
```env
FLASK_ENV=development
FLASK_DEBUG=True
FIREBASE_CREDENTIALS_PATH=./firebase-credentials.json
GOOGLE_CLOUD_PROJECT_ID=your_project_id
SECRET_KEY=your_secret_key
PORT=5000
```

### Frontend (lib/services/api_service.dart)
```dart
static const String baseUrl = 'http://localhost:5000/api';
```

For production, change to your deployed backend URL.

## 🧪 Testing

### Test Backend Endpoints
```python
# In backend directory
pytest tests/

# Or manually with curl commands above
```

### Test Frontend
```bash
flutter test
```

## 📝 Sample Recipes

The project includes recipes from:
- **Italian**: Carbonara, Margherita Pizza, Pasta Primavera
- **Indian**: Butter Chicken, Chicken Tikka Masala, Vegetable Curry
- **Thai**: Pad Thai
- **Mexican**: Tacos al Pastor, Beef Tacos
- **Mediterranean**: Grilled Salmon, Buddha Bowl, Caprese
- **And more...**

Each recipe includes:
- Ingredients with quantities
- Step-by-step instructions
- Nutrition info (calories, protein, carbs, fat, fiber)
- Prep and cook times
- Difficulty level
- Dietary tags
- Cuisine type

## 🎯 Next Steps

1. **Set up Firebase** (optional for production)
   - Create Firebase project
   - Download credentials JSON
   - Update .env file

2. **Add Image Recognition**
   - Download YOLO v5 weights
   - Place in `backend/ml_models/`
   - Update `ingredient_detector.py`

3. **Deploy Backend**
   - Use Gunicorn for production
   - Deploy to Heroku/AWS/GCP
   - Update API_SERVICE base URL in Flutter

4. **Build Mobile Apps**
   - Configure signing for Android
   - Set up Apple Developer account for iOS
   - Build and publish to stores

## 🐛 Troubleshooting

### Backend Issues
- **Port already in use**: Change PORT in .env
- **Module not found**: Run `pip install -r requirements.txt`
- **Firebase error**: Check credentials file path

### Frontend Issues
- **Dependencies not found**: Run `flutter pub get`
- **Build fails**: Try `flutter clean && flutter pub get`
- **API connection fails**: Check backend URL and ensure server is running

## 📚 Documentation

- Full API documentation: See `IMPLEMENTATION_GUIDE.md`
- Project structure: See README.md
- Flutter docs: https://flutter.dev
- Flask docs: https://flask.palletsprojects.com

## 💡 Tips

- Use `flutter run --verbose` for debugging
- Use `flutter devtools` for performance analysis
- Set `FLASK_DEBUG=True` for auto-reload
- Use Postman for API testing

## ✨ Features Ready to Use

- ✅ Complete recipe database with 20+ recipes
- ✅ TF-IDF search and recommendations
- ✅ Nutrition calculations
- ✅ Grocery list generation
- ✅ User preferences and favorites
- ✅ Full Flutter UI with 5 screens
- ✅ State management with Provider
- ✅ API integration ready

## 🚀 You're All Set!

Your SmartChef AI application is now set up and ready to use. Start the backend, run the Flutter app, and begin exploring recipes!

---

**Need help?** Check the IMPLEMENTATION_GUIDE.md for detailed information.
