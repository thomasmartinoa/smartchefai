"""
Flask routes for grocery list endpoints
"""
from flask import Blueprint, request, jsonify
from backend.models.database import GroceryListModel, RecipeModel, UserModel
from backend.services.grocery_list_generator import GroceryListGenerator
import logging

grocery_bp = Blueprint('grocery', __name__, url_prefix='/api/grocery-lists')
logger = logging.getLogger(__name__)


@grocery_bp.route('', methods=['POST'])
def create_grocery_list():
    """Create a new grocery list from recipes"""
    try:
        data = request.get_json()
        user_id = data.get('user_id')
        recipe_ids = data.get('recipe_ids', [])
        servings_multipliers = data.get('servings_multipliers', {})
        
        if not user_id:
            return jsonify({'error': 'user_id is required'}), 400
        
        user = UserModel.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        # Get recipes
        recipes = []
        for recipe_id in recipe_ids:
            recipe = RecipeModel.get(recipe_id)
            if recipe:
                recipes.append(recipe)
        
        if not recipes:
            return jsonify({'error': 'No valid recipes provided'}), 400
        
        # Generate grocery list
        grocery_list_data = GroceryListGenerator.generate_from_recipes(recipes, servings_multipliers)
        grocery_list_data['user_id'] = user_id
        
        # Save to database
        list_id = GroceryListModel.create(grocery_list_data)
        
        grocery_list = GroceryListModel.get(list_id)
        return jsonify({'grocery_list': grocery_list, 'id': list_id}), 201
    except Exception as e:
        logger.error(f"Error creating grocery list: {e}")
        return jsonify({'error': str(e)}), 500


@grocery_bp.route('/<list_id>', methods=['GET'])
def get_grocery_list(list_id):
    """Get grocery list by ID"""
    try:
        grocery_list = GroceryListModel.get(list_id)
        if not grocery_list:
            return jsonify({'error': 'Grocery list not found'}), 404
        
        return jsonify(grocery_list), 200
    except Exception as e:
        logger.error(f"Error getting grocery list: {e}")
        return jsonify({'error': str(e)}), 500


@grocery_bp.route('/user/<user_id>', methods=['GET'])
def get_user_lists(user_id):
    """Get all grocery lists for a user"""
    try:
        user = UserModel.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        lists = GroceryListModel.get_user_lists(user_id)
        return jsonify({'lists': lists, 'count': len(lists)}), 200
    except Exception as e:
        logger.error(f"Error getting user lists: {e}")
        return jsonify({'error': str(e)}), 500


@grocery_bp.route('/<list_id>', methods=['PUT'])
def update_grocery_list(list_id):
    """Update grocery list"""
    try:
        data = request.get_json()
        
        grocery_list = GroceryListModel.get(list_id)
        if not grocery_list:
            return jsonify({'error': 'Grocery list not found'}), 404
        
        GroceryListModel.update(list_id, data)
        
        updated_list = GroceryListModel.get(list_id)
        return jsonify(updated_list), 200
    except Exception as e:
        logger.error(f"Error updating grocery list: {e}")
        return jsonify({'error': str(e)}), 500


@grocery_bp.route('/<list_id>', methods=['DELETE'])
def delete_grocery_list(list_id):
    """Delete grocery list"""
    try:
        grocery_list = GroceryListModel.get(list_id)
        if not grocery_list:
            return jsonify({'error': 'Grocery list not found'}), 404
        
        GroceryListModel.delete(list_id)
        return jsonify({'message': 'Grocery list deleted'}), 200
    except Exception as e:
        logger.error(f"Error deleting grocery list: {e}")
        return jsonify({'error': str(e)}), 500


@grocery_bp.route('/<list_id>/toggle-item', methods=['POST'])
def toggle_item(list_id):
    """Toggle item checked status"""
    try:
        data = request.get_json()
        item_name = data.get('item_name')
        
        grocery_list = GroceryListModel.get(list_id)
        if not grocery_list:
            return jsonify({'error': 'Grocery list not found'}), 404
        
        items = grocery_list.get('items', [])
        for item in items:
            if item.get('name') == item_name:
                item['checked'] = not item.get('checked', False)
                break
        
        GroceryListModel.update(list_id, {'items': items})
        
        updated_list = GroceryListModel.get(list_id)
        return jsonify(updated_list), 200
    except Exception as e:
        logger.error(f"Error toggling item: {e}")
        return jsonify({'error': str(e)}), 500
