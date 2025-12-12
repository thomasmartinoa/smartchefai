# SmartChef AI - API Examples & Testing Guide

## 🧪 Testing with cURL

### Recipe Endpoints

#### Get All Recipes
```bash
curl "http://localhost:5000/api/recipes/all?limit=20"
```

#### Get Recipe by ID
```bash
curl "http://localhost:5000/api/recipes/Spaghetti%20Carbonara"
```

#### Search Recipes by Text
```bash
curl -X POST "http://localhost:5000/api/recipes/search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "pasta",
    "limit": 10,
    "filters": {
      "cuisine": "Italian"
    }
  }'
```

#### Search by Ingredients
```bash
curl -X POST "http://localhost:5000/api/recipes/by-ingredients" \
  -H "Content-Type: application/json" \
  -d '{
    "ingredients": ["chicken", "tomato", "garlic"],
    "limit": 15
  }'
```

### Ingredient Detection Endpoints

#### Detect Ingredients from Image
```bash
curl -X POST "http://localhost:5000/api/detect/ingredients" \
  -F "image=@path/to/image.jpg"
```

#### Detect Ingredients and Find Recipes
```bash
curl -X POST "http://localhost:5000/api/detect/ingredients-and-recipes" \
  -F "image=@path/to/image.jpg" \
  -F "user_id=user123"
```

### User Endpoints

#### Create User
```bash
curl -X POST "http://localhost:5000/api/users" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "dietary_preferences": ["vegetarian"],
    "allergies": ["peanuts"]
  }'
```

#### Get User Profile
```bash
curl "http://localhost:5000/api/users/user123"
```

#### Set Dietary Preferences
```bash
curl -X POST "http://localhost:5000/api/users/user123/preferences" \
  -H "Content-Type: application/json" \
  -d '{
    "dietary_preferences": ["vegan", "gluten-free"],
    "allergies": ["shellfish", "dairy"]
  }'
```

#### Get Favorites
```bash
curl "http://localhost:5000/api/users/user123/favorites"
```

#### Add Favorite
```bash
curl -X POST "http://localhost:5000/api/users/user123/favorites/add" \
  -H "Content-Type: application/json" \
  -d '{"recipe_id": "Spaghetti Carbonara"}'
```

#### Remove Favorite
```bash
curl -X POST "http://localhost:5000/api/users/user123/favorites/remove" \
  -H "Content-Type: application/json" \
  -d '{"recipe_id": "Spaghetti Carbonara"}'
```

#### Get Personalized Recommendations
```bash
curl "http://localhost:5000/api/users/user123/recommendations?limit=10"
```

### Grocery List Endpoints

#### Create Grocery List
```bash
curl -X POST "http://localhost:5000/api/grocery-lists" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "user123",
    "recipe_ids": ["Butter Chicken", "Pad Thai"],
    "servings_multipliers": {
      "Butter Chicken": 2,
      "Pad Thai": 1.5
    }
  }'
```

#### Get Grocery List
```bash
curl "http://localhost:5000/api/grocery-lists/list123"
```

#### Get User's Lists
```bash
curl "http://localhost:5000/api/grocery-lists/user/user123"
```

#### Update Grocery List
```bash
curl -X PUT "http://localhost:5000/api/grocery-lists/list123" \
  -H "Content-Type: application/json" \
  -d '{"status": "completed"}'
```

#### Toggle Item Checked
```bash
curl -X POST "http://localhost:5000/api/grocery-lists/list123/toggle-item" \
  -H "Content-Type: application/json" \
  -d '{"item_name": "chicken 600g"}'
```

#### Delete Grocery List
```bash
curl -X DELETE "http://localhost:5000/api/grocery-lists/list123"
```

### Health Check
```bash
curl "http://localhost:5000/api/health"
```

## 📮 Postman Collection

You can import this into Postman as a JSON collection:

```json
{
  "info": {
    "name": "SmartChef AI API",
    "version": "1.0.0"
  },
  "item": [
    {
      "name": "Recipes",
      "item": [
        {
          "name": "Get All Recipes",
          "request": {
            "method": "GET",
            "url": "http://localhost:5000/api/recipes/all?limit=20"
          }
        },
        {
          "name": "Search Recipes",
          "request": {
            "method": "POST",
            "url": "http://localhost:5000/api/recipes/search",
            "body": {
              "mode": "raw",
              "raw": "{\"query\": \"pasta\", \"limit\": 10}"
            }
          }
        }
      ]
    }
  ]
}
```

## 🎯 Common Test Scenarios

### Scenario 1: Search for Easy Italian Recipes
```bash
curl -X POST "http://localhost:5000/api/recipes/search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "italian",
    "limit": 15,
    "filters": {
      "difficulty": "easy"
    }
  }'
```

### Scenario 2: Create User and Get Recommendations
```bash
# 1. Create user
USER_ID=$(curl -s -X POST "http://localhost:5000/api/users" \
  -H "Content-Type: application/json" \
  -d '{"name": "Alice", "email": "alice@example.com"}' | jq -r '.id')

# 2. Get recommendations
curl "http://localhost:5000/api/users/$USER_ID/recommendations?limit=10"
```

### Scenario 3: Generate Grocery List
```bash
# 1. Create user
USER_ID=$(curl -s -X POST "http://localhost:5000/api/users" \
  -H "Content-Type: application/json" \
  -d '{"name": "Bob", "email": "bob@example.com"}' | jq -r '.id')

# 2. Create grocery list
LIST_ID=$(curl -s -X POST "http://localhost:5000/api/grocery-lists" \
  -H "Content-Type: application/json" \
  -d "{
    \"user_id\": \"$USER_ID\",
    \"recipe_ids\": [\"Spaghetti Carbonara\", \"Caesar Salad\"],
    \"servings_multipliers\": {
      \"Spaghetti Carbonara\": 4
    }
  }" | jq -r '.id')

# 3. Get the list
curl "http://localhost:5000/api/grocery-lists/$LIST_ID"
```

### Scenario 4: Search by Ingredients
```bash
curl -X POST "http://localhost:5000/api/recipes/by-ingredients" \
  -H "Content-Type: application/json" \
  -d '{
    "ingredients": ["eggs", "bacon", "parmesan"],
    "limit": 10
  }'
```

## 🧪 Python Testing Script

```python
import requests
import json

BASE_URL = "http://localhost:5000/api"

class SmartChefAPI:
    def __init__(self, base_url=BASE_URL):
        self.base_url = base_url
    
    def search_recipes(self, query, limit=10):
        """Search recipes"""
        response = requests.post(
            f"{self.base_url}/recipes/search",
            json={"query": query, "limit": limit}
        )
        return response.json()
    
    def search_by_ingredients(self, ingredients, limit=10):
        """Search by ingredients"""
        response = requests.post(
            f"{self.base_url}/recipes/by-ingredients",
            json={"ingredients": ingredients, "limit": limit}
        )
        return response.json()
    
    def get_all_recipes(self, limit=100):
        """Get all recipes"""
        response = requests.get(f"{self.base_url}/recipes/all?limit={limit}")
        return response.json()
    
    def create_user(self, name, email):
        """Create a user"""
        response = requests.post(
            f"{self.base_url}/users",
            json={"name": name, "email": email}
        )
        return response.json()
    
    def get_user(self, user_id):
        """Get user profile"""
        response = requests.get(f"{self.base_url}/users/{user_id}")
        return response.json()
    
    def create_grocery_list(self, user_id, recipe_ids):
        """Create grocery list"""
        response = requests.post(
            f"{self.base_url}/grocery-lists",
            json={
                "user_id": user_id,
                "recipe_ids": recipe_ids
            }
        )
        return response.json()

# Usage
api = SmartChefAPI()

# Search recipes
print("=== Searching for Italian recipes ===")
results = api.search_recipes("italian", limit=5)
print(json.dumps(results, indent=2))

# Search by ingredients
print("\n=== Searching by ingredients ===")
results = api.search_by_ingredients(["chicken", "tomato"], limit=5)
print(json.dumps(results, indent=2))

# Create user
print("\n=== Creating user ===")
user = api.create_user("Test User", "test@example.com")
print(json.dumps(user, indent=2))

# Get all recipes
print("\n=== Getting all recipes ===")
recipes = api.get_all_recipes(limit=3)
print(f"Total recipes: {recipes.get('count')}")
for recipe in recipes.get('recipes', [])[:3]:
    print(f"  - {recipe['name']}")
```

## 📊 Response Examples

### Successful Recipe Search
```json
{
  "results": [
    {
      "id": "recipe123",
      "name": "Spaghetti Carbonara",
      "cuisine": "Italian",
      "difficulty": "medium",
      "prep_time": "10 min",
      "cook_time": "20 min",
      "servings": 4,
      "ingredients": ["spaghetti 400g", "eggs 4", "parmesan 100g", ...],
      "similarity_score": 0.95,
      "nutrition_info": {
        "per_serving": {
          "calories": 450,
          "protein_g": 18,
          "carbs_g": 55,
          "fat_g": 16,
          "fiber_g": 2
        }
      }
    }
  ],
  "count": 1
}
```

### Grocery List Response
```json
{
  "id": "list123",
  "user_id": "user123",
  "items": [
    {
      "name": "spaghetti",
      "quantity": 400,
      "unit": "g",
      "category": "grains",
      "checked": false,
      "recipes": ["recipe123"]
    },
    {
      "name": "eggs",
      "quantity": 4,
      "unit": "",
      "category": "dairy",
      "checked": false,
      "recipes": ["recipe123"]
    }
  ],
  "by_category": {
    "grains": [...],
    "dairy": [...]
  },
  "total_items": 6,
  "status": "active"
}
```

## ✅ Validation Checklist

- [ ] Backend server is running on port 5000
- [ ] All endpoints return 200 status codes
- [ ] Recipe search works with various queries
- [ ] Ingredient-based search returns relevant results
- [ ] User creation and retrieval works
- [ ] Grocery list generation consolidates ingredients
- [ ] Favorites can be added and removed
- [ ] Personalized recommendations return recipes
- [ ] API handles errors gracefully

## 🚀 Performance Tips

1. **Cache Results**: Store frequently accessed recipes
2. **Pagination**: Use limit parameter for large datasets
3. **Filters**: Use filters to narrow down results
4. **Batch Operations**: Create multiple items at once
5. **Connection Pooling**: Reuse HTTP connections

## 📝 Rate Limiting

For production, consider adding:
- Request rate limits
- API key authentication
- Response caching
- Database indexing

---

All endpoints are ready to test! Start with the health check to verify the server is running.
