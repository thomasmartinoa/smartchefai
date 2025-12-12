"""
Database models and Firestore configuration for SmartChef AI
"""
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from datetime import datetime
from typing import Dict, List, Optional
import os

# Initialize Firebase
cred_path = os.getenv('FIREBASE_CREDENTIALS_PATH', './firebase-credentials.json')
if not firebase_admin._apps:
    cred = credentials.Certificate(cred_path)
    firebase_admin.initialize_app(cred)

db = firestore.client()

class RecipeModel:
    """Recipe collection model"""
    
    @staticmethod
    def create(recipe_data: Dict) -> str:
        """Create a new recipe"""
        recipe_ref = db.collection('recipes').document()
        recipe_data['created_at'] = datetime.now()
        recipe_ref.set(recipe_data)
        return recipe_ref.id
    
    @staticmethod
    def get(recipe_id: str) -> Optional[Dict]:
        """Get recipe by ID"""
        doc = db.collection('recipes').document(recipe_id).get()
        if doc.exists:
            data = doc.to_dict()
            data['id'] = doc.id
            return data
        return None
    
    @staticmethod
    def search(query: str, limit: int = 10) -> List[Dict]:
        """Search recipes by name or cuisine"""
        results = []
        
        # Search by name
        docs = db.collection('recipes').where('name', '>=', query).where('name', '<=', query + '\uf8ff').limit(limit).stream()
        for doc in docs:
            data = doc.to_dict()
            data['id'] = doc.id
            results.append(data)
        
        return results
    
    @staticmethod
    def get_all(limit: int = 100) -> List[Dict]:
        """Get all recipes"""
        results = []
        docs = db.collection('recipes').limit(limit).stream()
        for doc in docs:
            data = doc.to_dict()
            data['id'] = doc.id
            results.append(data)
        return results
    
    @staticmethod
    def update(recipe_id: str, update_data: Dict):
        """Update recipe"""
        db.collection('recipes').document(recipe_id).update(update_data)
    
    @staticmethod
    def delete(recipe_id: str):
        """Delete recipe"""
        db.collection('recipes').document(recipe_id).delete()


class UserModel:
    """User collection model"""
    
    @staticmethod
    def create(user_data: Dict) -> str:
        """Create a new user"""
        user_ref = db.collection('users').document()
        user_data['created_at'] = datetime.now()
        user_data['dietary_preferences'] = user_data.get('dietary_preferences', [])
        user_data['allergies'] = user_data.get('allergies', [])
        user_data['favorite_recipes'] = user_data.get('favorite_recipes', [])
        user_data['search_history'] = user_data.get('search_history', [])
        user_ref.set(user_data)
        return user_ref.id
    
    @staticmethod
    def get(user_id: str) -> Optional[Dict]:
        """Get user by ID"""
        doc = db.collection('users').document(user_id).get()
        if doc.exists:
            data = doc.to_dict()
            data['id'] = doc.id
            return data
        return None
    
    @staticmethod
    def update(user_id: str, update_data: Dict):
        """Update user"""
        db.collection('users').document(user_id).update(update_data)
    
    @staticmethod
    def add_favorite(user_id: str, recipe_id: str):
        """Add recipe to favorites"""
        user = UserModel.get(user_id)
        if user:
            favorites = user.get('favorite_recipes', [])
            if recipe_id not in favorites:
                favorites.append(recipe_id)
                UserModel.update(user_id, {'favorite_recipes': favorites})
    
    @staticmethod
    def remove_favorite(user_id: str, recipe_id: str):
        """Remove recipe from favorites"""
        user = UserModel.get(user_id)
        if user:
            favorites = user.get('favorite_recipes', [])
            if recipe_id in favorites:
                favorites.remove(recipe_id)
                UserModel.update(user_id, {'favorite_recipes': favorites})
    
    @staticmethod
    def add_search_history(user_id: str, query: str):
        """Add to search history"""
        user = UserModel.get(user_id)
        if user:
            history = user.get('search_history', [])
            history.append({'query': query, 'timestamp': datetime.now()})
            history = history[-50:]  # Keep last 50
            UserModel.update(user_id, {'search_history': history})


class GroceryListModel:
    """Grocery list collection model"""
    
    @staticmethod
    def create(grocery_list_data: Dict) -> str:
        """Create a new grocery list"""
        list_ref = db.collection('grocery_lists').document()
        grocery_list_data['created_at'] = datetime.now()
        grocery_list_data['status'] = grocery_list_data.get('status', 'active')
        list_ref.set(grocery_list_data)
        return list_ref.id
    
    @staticmethod
    def get(list_id: str) -> Optional[Dict]:
        """Get grocery list by ID"""
        doc = db.collection('grocery_lists').document(list_id).get()
        if doc.exists:
            data = doc.to_dict()
            data['id'] = doc.id
            return data
        return None
    
    @staticmethod
    def get_user_lists(user_id: str) -> List[Dict]:
        """Get all lists for a user"""
        results = []
        docs = db.collection('grocery_lists').where('user_id', '==', user_id).stream()
        for doc in docs:
            data = doc.to_dict()
            data['id'] = doc.id
            results.append(data)
        return results
    
    @staticmethod
    def update(list_id: str, update_data: Dict):
        """Update grocery list"""
        db.collection('grocery_lists').document(list_id).update(update_data)
    
    @staticmethod
    def add_item(list_id: str, item: Dict):
        """Add item to grocery list"""
        grocery_list = GroceryListModel.get(list_id)
        if grocery_list:
            items = grocery_list.get('items', [])
            items.append(item)
            GroceryListModel.update(list_id, {'items': items})
    
    @staticmethod
    def delete(list_id: str):
        """Delete grocery list"""
        db.collection('grocery_lists').document(list_id).delete()


class UserInteractionModel:
    """User interaction tracking for collaborative filtering"""
    
    @staticmethod
    def log_interaction(user_id: str, recipe_id: str, rating: int):
        """Log user-recipe interaction"""
        interaction_ref = db.collection('user_interactions').document()
        interaction_ref.set({
            'user_id': user_id,
            'recipe_id': recipe_id,
            'rating': rating,
            'timestamp': datetime.now()
        })
    
    @staticmethod
    def get_user_interactions(user_id: str) -> List[Dict]:
        """Get all interactions for a user"""
        results = []
        docs = db.collection('user_interactions').where('user_id', '==', user_id).stream()
        for doc in docs:
            data = doc.to_dict()
            data['id'] = doc.id
            results.append(data)
        return results
    
    @staticmethod
    def get_recipe_interactions(recipe_id: str) -> List[Dict]:
        """Get all interactions for a recipe"""
        results = []
        docs = db.collection('user_interactions').where('recipe_id', '==', recipe_id).stream()
        for doc in docs:
            data = doc.to_dict()
            data['id'] = doc.id
            results.append(data)
        return results
