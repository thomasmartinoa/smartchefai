"""
Flask routes for user and favorites endpoints
"""
from flask import Blueprint, request, jsonify
from backend.models.database import UserModel, RecipeModel
from backend.services.recommendation_engine import RecommendationEngine
import logging

user_bp = Blueprint('users', __name__, url_prefix='/api/users')
logger = logging.getLogger(__name__)


@user_bp.route('', methods=['POST'])
def create_user():
    """Create a new user"""
    try:
        data = request.get_json()
        
        user_id = UserModel.create(data)
        user = UserModel.get(user_id)
        
        return jsonify({'user': user, 'id': user_id}), 201
    except Exception as e:
        logger.error(f"Error creating user: {e}")
        return jsonify({'error': str(e)}), 500


@user_bp.route('/<user_id>', methods=['GET'])
def get_user(user_id):
    """Get user profile"""
    try:
        user = UserModel.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        return jsonify(user), 200
    except Exception as e:
        logger.error(f"Error getting user: {e}")
        return jsonify({'error': str(e)}), 500


@user_bp.route('/<user_id>/preferences', methods=['POST'])
def set_preferences(user_id):
    """Set user dietary preferences"""
    try:
        data = request.get_json()
        
        user = UserModel.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        UserModel.update(user_id, {
            'dietary_preferences': data.get('dietary_preferences', []),
            'allergies': data.get('allergies', [])
        })
        
        updated_user = UserModel.get(user_id)
        return jsonify(updated_user), 200
    except Exception as e:
        logger.error(f"Error setting preferences: {e}")
        return jsonify({'error': str(e)}), 500


@user_bp.route('/<user_id>/favorites', methods=['GET'])
def get_favorites(user_id):
    """Get user's favorite recipes"""
    try:
        user = UserModel.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        favorite_ids = user.get('favorite_recipes', [])
        favorites = []
        
        for recipe_id in favorite_ids:
            recipe = RecipeModel.get(recipe_id)
            if recipe:
                favorites.append(recipe)
        
        return jsonify({'favorites': favorites, 'count': len(favorites)}), 200
    except Exception as e:
        logger.error(f"Error getting favorites: {e}")
        return jsonify({'error': str(e)}), 500


@user_bp.route('/<user_id>/favorites/add', methods=['POST'])
def add_favorite(user_id):
    """Add recipe to favorites"""
    try:
        data = request.get_json()
        recipe_id = data.get('recipe_id')
        
        if not recipe_id:
            return jsonify({'error': 'recipe_id is required'}), 400
        
        user = UserModel.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        recipe = RecipeModel.get(recipe_id)
        if not recipe:
            return jsonify({'error': 'Recipe not found'}), 404
        
        UserModel.add_favorite(user_id, recipe_id)
        
        return jsonify({'message': 'Recipe added to favorites'}), 200
    except Exception as e:
        logger.error(f"Error adding favorite: {e}")
        return jsonify({'error': str(e)}), 500


@user_bp.route('/<user_id>/favorites/remove', methods=['POST'])
def remove_favorite(user_id):
    """Remove recipe from favorites"""
    try:
        data = request.get_json()
        recipe_id = data.get('recipe_id')
        
        if not recipe_id:
            return jsonify({'error': 'recipe_id is required'}), 400
        
        user = UserModel.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        UserModel.remove_favorite(user_id, recipe_id)
        
        return jsonify({'message': 'Recipe removed from favorites'}), 200
    except Exception as e:
        logger.error(f"Error removing favorite: {e}")
        return jsonify({'error': str(e)}), 500


@user_bp.route('/<user_id>/recommendations', methods=['GET'])
def get_personalized_recommendations(user_id):
    """Get personalized recipe recommendations"""
    try:
        user = UserModel.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        limit = request.args.get('limit', 10, type=int)
        
        engine = RecommendationEngine()
        recommendations = engine.get_personalized_recommendations(user_id, limit)
        
        return jsonify({
            'recommendations': recommendations,
            'count': len(recommendations)
        }), 200
    except Exception as e:
        logger.error(f"Error getting recommendations: {e}")
        return jsonify({'error': str(e)}), 500
