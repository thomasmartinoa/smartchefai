"""
Flask routes for recipe and recommendation endpoints
"""
from flask import Blueprint, request, jsonify
import json
from pathlib import Path
from backend.models.database import RecipeModel, UserModel
from backend.services.recommendation_engine import RecommendationEngine
from backend.services.nutrition_calculator import NutritionCalculator
import logging
import os

recipe_bp = Blueprint('recipes', __name__, url_prefix='/api/recipes')
logger = logging.getLogger(__name__)

# Load sample recipes
def load_sample_recipes():
    """Load recipes from JSON file"""
    try:
        recipe_file = Path(__file__).parent.parent.parent / 'data' / 'recipes.json'
        if recipe_file.exists():
            with open(recipe_file, 'r') as f:
                return json.load(f)
    except Exception as e:
        logger.error(f"Error loading recipes: {e}")
    return []

_sample_recipes = load_sample_recipes()
_recommendation_engine = None

def get_engine():
    global _recommendation_engine
    if _recommendation_engine is None:
        _recommendation_engine = RecommendationEngine(_sample_recipes)
    return _recommendation_engine

@recipe_bp.route('/<recipe_id>', methods=['GET'])
def get_recipe(recipe_id):
    """Get recipe by ID"""
    try:
        # Search in sample recipes
        recipe = next((r for r in _sample_recipes if r.get('id') == recipe_id), None)
        if not recipe:
            recipe = next((r for r in _sample_recipes if r.get('name').lower() == recipe_id.lower()), None)
        
        if not recipe:
            return jsonify({'error': 'Recipe not found'}), 404
        
        # Calculate nutrition
        recipe['nutrition_info'] = NutritionCalculator.calculate_recipe_nutrition(recipe)
        
        return jsonify(recipe), 200
    except Exception as e:
        logger.error(f"Error getting recipe: {e}")
        return jsonify({'error': str(e)}), 500


@recipe_bp.route('/search', methods=['POST'])
def search_recipes():
    """Search recipes with optional filters"""
    try:
        data = request.get_json()
        query = data.get('query', '')
        limit = data.get('limit', 15)
        filters = data.get('filters', {})
        
        if not query:
            return jsonify({'error': 'Query is required'}), 400
        
        # Initialize recommendation engine
        engine = get_engine()
        results = engine.search_recipes(query, limit, filters)
        
        # Add nutrition info to each result
        for recipe in results:
            recipe['nutrition_info'] = NutritionCalculator.calculate_recipe_nutrition(recipe)
        
        return jsonify({'results': results, 'count': len(results)}), 200
    except Exception as e:
        logger.error(f"Error searching recipes: {e}")
        return jsonify({'error': str(e)}), 500


@recipe_bp.route('/by-ingredients', methods=['POST'])
def search_by_ingredients():
    """Search recipes by available ingredients"""
    try:
        data = request.get_json()
        ingredients = data.get('ingredients', [])
        limit = data.get('limit', 15)
        
        if not ingredients:
            return jsonify({'error': 'Ingredients list is required'}), 400
        
        engine = get_engine()
        results = engine.search_by_ingredients(ingredients, limit)
        
        for recipe in results:
            recipe['nutrition_info'] = NutritionCalculator.calculate_recipe_nutrition(recipe)
        
        return jsonify({'results': results, 'count': len(results)}), 200
    except Exception as e:
        logger.error(f"Error searching by ingredients: {e}")
        return jsonify({'error': str(e)}), 500


@recipe_bp.route('/all', methods=['GET'])
def get_all_recipes():
    """Get all recipes (paginated)"""
    try:
        limit = request.args.get('limit', 100, type=int)
        recipes = _sample_recipes[:limit]
        
        for recipe in recipes:
            recipe['nutrition_info'] = NutritionCalculator.calculate_recipe_nutrition(recipe)
        
        return jsonify({'recipes': recipes, 'count': len(recipes)}), 200
    except Exception as e:
        logger.error(f"Error getting recipes: {e}")
        return jsonify({'error': str(e)}), 500
