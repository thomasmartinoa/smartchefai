# SmartChef AI - Comprehensive Development Prompt for Claude Code

## Project Overview
Build a complete AI-based personalized recipe recommender system called **SmartChef AI** that accepts text, voice, and image inputs to provide intelligent recipe recommendations with nutrition tracking and grocery list generation.

## Core Requirements

### 1. Backend System (Flask/Django)

**Create a Python backend with the following components:**

#### A. Ingredient Detection Module
- Implement a CNN-based ingredient detection system using YOLO or ResNet
- Accept image uploads and detect ingredients present in the image
- Return a list of detected ingredients with confidence scores
- Store pre-trained model weights or implement transfer learning
- Handle multiple food items in a single image

#### B. Recommendation Engine
- Build a TF-IDF + Cosine Similarity based recommendation system
- Accept inputs: detected ingredients, text queries, or voice-transcribed text
- Match user inputs against a recipe database
- Return top 10-15 most relevant recipes ranked by similarity score
- Implement collaborative filtering for personalized recommendations based on user history

#### C. Recipe Database Schema
Design MongoDB/Firebase collections for:
- **Recipes**: id, name, ingredients[], steps[], prep_time, cook_time, total_time, difficulty, cuisine_type, dietary_tags[], nutrition{calories, protein, carbs, fat, fiber}, image_url, servings
- **Users**: id, name, email, dietary_preferences[], allergies[], favorite_recipes[], search_history[], created_at
- **Grocery Lists**: user_id, items[], created_at, status
- **User Interactions**: user_id, recipe_id, rating, timestamp (for collaborative filtering)

#### D. API Endpoints
Create RESTful APIs:
```
POST /api/detect-ingredients (upload image)
POST /api/search-recipes (text/voice query)
GET /api/recipe/{id}
POST /api/favorites/add
DELETE /api/favorites/remove
GET /api/favorites
POST /api/grocery-list/generate
GET /api/grocery-list
POST /api/user/preferences
GET /api/recommendations/personalized
POST /api/voice-to-text
```

### 2. AI/ML Components

#### A. Image Recognition Model
- Use pre-trained YOLO v5/v8 or ResNet50 for ingredient detection
- Fine-tune on food dataset (Food-101, Recipe1M, or custom dataset)
- Implement data augmentation for training
- Achieve >85% accuracy on test set
- Optimize for mobile deployment (consider TensorFlow Lite)

#### B. Text Processing
- Implement TF-IDF vectorization for recipe descriptions and ingredients
- Use cosine similarity for matching queries to recipes
- Handle synonyms and variations (e.g., "tomatoes" vs "tomato")
- Implement fuzzy matching for ingredient names

#### C. Voice Processing
- Integrate speech-to-text API (Google Speech-to-Text, Whisper, or Web Speech API)
- Handle various accents and background noise
- Convert audio input to text query
- Pass to recommendation engine

### 3. Mobile App (Flutter/React Native)

#### A. Core Screens
1. **Home Screen**: Search bar (text/voice/camera icons), featured recipes, recent searches
2. **Search Results**: Grid/list of recipe cards with images, name, time, difficulty
3. **Recipe Detail**: Full ingredients list, step-by-step instructions, nutrition info, favorite button, add to grocery list button
4. **Camera/Upload**: Take photo or upload from gallery, show detected ingredients, "Find Recipes" button
5. **Favorites**: Saved recipes organized by category or date
6. **Grocery List**: Categorized shopping list with checkbox items
7. **Profile**: Dietary preferences, allergies, nutrition goals, app settings

#### B. Key Features
- Multi-modal input switching (text/voice/image)
- Voice recording with visual feedback
- Image capture and preview
- Real-time search suggestions
- Offline recipe viewing for favorites
- Share recipes via social media
- Filter and sort results (time, difficulty, cuisine, dietary)

#### C. UI/UX Requirements
- Clean, modern design with food-focused imagery
- Intuitive navigation bottom bar
- Quick access to camera and voice search
- Loading states and error handling
- Smooth animations and transitions

### 4. Data Requirements

#### Sample Recipe Dataset
Include at least 100+ recipes covering:
- Various cuisines (Italian, Indian, Chinese, Mexican, American, Mediterranean)
- Dietary types (vegetarian, vegan, gluten-free, keto, low-carb)
- Meal types (breakfast, lunch, dinner, snacks, desserts)
- Difficulty levels (easy, medium, hard)

Format:
```json
{
  "name": "Spaghetti Carbonara",
  "ingredients": ["spaghetti 400g", "eggs 4", "parmesan 100g", "bacon 200g", "black pepper", "salt"],
  "steps": ["1. Boil pasta...", "2. Fry bacon...", "3. Mix eggs and cheese...", "4. Combine..."],
  "prep_time": "10 min",
  "cook_time": "20 min",
  "difficulty": "medium",
  "cuisine": "Italian",
  "dietary_tags": [],
  "nutrition": {"calories": 450, "protein": "18g", "carbs": "55g", "fat": "16g"},
  "servings": 4
}
```

### 5. Advanced Features

#### A. Personalization
- Learn from user's favorite recipes
- Recommend similar recipes based on past interactions
- Adjust recommendations based on dietary preferences
- Time-based suggestions (quick recipes on weekdays)

#### B. Grocery List Intelligence
- Automatically categorize items (produce, dairy, meat, etc.)
- Consolidate duplicate ingredients across multiple recipes
- Suggest quantities based on servings
- Check off items as purchased

#### C. Nutrition Tracking
- Calculate total nutrition per serving
- Show macro breakdown (protein/carbs/fat percentages)
- Highlight healthy/dietary-compliant recipes
- Daily/weekly nutrition summary
