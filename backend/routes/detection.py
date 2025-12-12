"""
Flask routes for ingredient detection endpoints
"""
from flask import Blueprint, request, jsonify
from backend.services.ingredient_detector import IngredientDetector
from backend.services.recommendation_engine import RecommendationEngine
from backend.models.database import UserModel
import logging
import os
from werkzeug.utils import secure_filename

detector_bp = Blueprint('detection', __name__, url_prefix='/api/detect')
logger = logging.getLogger(__name__)

# Initialize detector (lazy load)
detector = None

def get_detector():
    global detector
    if detector is None:
        detector = IngredientDetector()
    return detector

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'webp'}
MAX_FILE_SIZE = 10 * 1024 * 1024  # 10MB

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


@detector_bp.route('/ingredients', methods=['POST'])
def detect_ingredients():
    """Detect ingredients from uploaded image"""
    try:
        # Check if image is present
        if 'image' not in request.files:
            return jsonify({'error': 'No image provided'}), 400
        
        image_file = request.files['image']
        
        if image_file.filename == '':
            return jsonify({'error': 'No image selected'}), 400
        
        if not allowed_file(image_file.filename):
            return jsonify({'error': 'Invalid file type. Allowed: PNG, JPG, JPEG, GIF, WebP'}), 400
        
        # Read image bytes
        image_bytes = image_file.read()
        
        if len(image_bytes) > MAX_FILE_SIZE:
            return jsonify({'error': 'File too large. Maximum 10MB'}), 400
        
        # Detect ingredients
        detector = get_detector()
        detections, annotated_image = detector.detect_ingredients(image_bytes=image_bytes)
        
        if not detections:
            return jsonify({'detections': [], 'ingredients': [], 'message': 'No ingredients detected'}), 200
        
        # Extract ingredient list
        ingredients = detector.get_ingredient_list(detections)
        
        # Log to user's search history if user_id provided
        user_id = request.form.get('user_id')
        if user_id:
            try:
                UserModel.add_search_history(user_id, f"Image search: {', '.join(ingredients)}")
            except Exception as e:
                logger.warning(f"Could not log search history: {e}")
        
        return jsonify({
            'detections': detections,
            'ingredients': ingredients,
            'count': len(detections)
        }), 200
    
    except Exception as e:
        logger.error(f"Error detecting ingredients: {e}")
        return jsonify({'error': str(e)}), 500


@detector_bp.route('/ingredients-and-recipes', methods=['POST'])
def detect_and_find_recipes():
    """Detect ingredients and find matching recipes in one call"""
    try:
        if 'image' not in request.files:
            return jsonify({'error': 'No image provided'}), 400
        
        image_file = request.files['image']
        
        if not allowed_file(image_file.filename):
            return jsonify({'error': 'Invalid file type'}), 400
        
        image_bytes = image_file.read()
        
        # Detect ingredients
        detector = get_detector()
        detections, _ = detector.detect_ingredients(image_bytes=image_bytes)
        ingredients = detector.get_ingredient_list(detections)
        
        # Find matching recipes
        engine = RecommendationEngine()
        recipes = engine.search_by_ingredients(ingredients, limit=15)
        
        # Log search
        user_id = request.form.get('user_id')
        if user_id:
            UserModel.add_search_history(user_id, f"Image search: {', '.join(ingredients)}")
        
        return jsonify({
            'detected_ingredients': ingredients,
            'detections_count': len(detections),
            'recipes': recipes,
            'recipes_count': len(recipes)
        }), 200
    
    except Exception as e:
        logger.error(f"Error in detect and find recipes: {e}")
        return jsonify({'error': str(e)}), 500
