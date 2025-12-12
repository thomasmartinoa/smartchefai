"""
Grocery list generation and management
"""
from typing import List, Dict
from collections import defaultdict
import logging

logger = logging.getLogger(__name__)

class GroceryListGenerator:
    """Generate and manage grocery lists from recipes"""
    
    # Ingredient categories
    CATEGORIES = {
        'produce': ['apple', 'banana', 'orange', 'tomato', 'lettuce', 'spinach', 'carrot', 
                   'onion', 'garlic', 'potato', 'broccoli', 'peppers', 'cucumber', 'mushroom',
                   'potato', 'avocado', 'lemon', 'lime', 'ginger'],
        'dairy': ['milk', 'cheese', 'butter', 'eggs', 'yogurt', 'cream', 'parmesan',
                 'mozzarella', 'feta', 'cheddar', 'ricotta', 'sour cream'],
        'meat': ['chicken', 'beef', 'pork', 'lamb', 'bacon', 'sausage', 'turkey',
                'fish', 'salmon', 'shrimp', 'meatballs', 'ham'],
        'grains': ['bread', 'pasta', 'rice', 'flour', 'oats', 'cereal', 'wheat',
                  'barley', 'couscous', 'quinoa', 'spaghetti', 'noodles'],
        'pantry': ['oil', 'salt', 'pepper', 'sugar', 'honey', 'vinegar', 'soy sauce',
                  'sauce', 'spices', 'herbs', 'beans', 'lentils', 'canned'],
        'frozen': ['frozen vegetables', 'frozen fruits', 'ice cream'],
        'beverages': ['milk', 'juice', 'water', 'coffee', 'tea', 'wine', 'beer']
    }
    
    @staticmethod
    def categorize_ingredient(ingredient: str) -> str:
        """
        Categorize an ingredient
        
        Args:
            ingredient: Ingredient name
        
        Returns:
            Category name
        """
        ingredient_lower = ingredient.lower()
        
        for category, items in GroceryListGenerator.CATEGORIES.items():
            for item in items:
                if item in ingredient_lower:
                    return category
        
        return 'other'
    
    @staticmethod
    def consolidate_ingredients(recipes: List[Dict], servings_multipliers: Dict = None) -> List[Dict]:
        """
        Consolidate ingredients from multiple recipes, removing duplicates
        
        Args:
            recipes: List of recipe dicts
            servings_multipliers: Dict mapping recipe_id to servings multiplier
        
        Returns:
            Consolidated ingredient list with categories
        """
        ingredient_map = defaultdict(lambda: {'quantity': 0, 'unit': '', 'recipes': []})
        
        for recipe in recipes:
            recipe_id = recipe.get('id', '')
            multiplier = 1
            
            if servings_multipliers and recipe_id in servings_multipliers:
                multiplier = servings_multipliers[recipe_id]
            
            for ingredient in recipe.get('ingredients', []):
                # Parse ingredient (simple parsing)
                parts = ingredient.strip().split()
                
                # Try to extract quantity and unit
                quantity_str = parts[0] if parts else '1'
                unit = parts[1] if len(parts) > 1 and parts[1].lower() in ['g', 'ml', 'oz', 'cup', 'tbsp', 'tsp', 'lbs'] else ''
                ingredient_name = ' '.join(parts[2:] if unit else parts[1:]) if len(parts) > 1 else ingredient
                
                try:
                    quantity = float(quantity_str) * multiplier
                except ValueError:
                    quantity = 1 * multiplier
                
                key = ingredient_name.lower()
                ingredient_map[key]['quantity'] += quantity
                ingredient_map[key]['unit'] = unit
                if recipe_id not in ingredient_map[key]['recipes']:
                    ingredient_map[key]['recipes'].append(recipe_id)
        
        # Convert to list format
        consolidated = []
        for ingredient_name, data in ingredient_map.items():
            consolidated.append({
                'name': ingredient_name,
                'quantity': round(data['quantity'], 2),
                'unit': data['unit'],
                'category': GroceryListGenerator.categorize_ingredient(ingredient_name),
                'checked': False,
                'recipes': data['recipes']
            })
        
        # Sort by category
        consolidated.sort(key=lambda x: x['category'])
        
        return consolidated
    
    @staticmethod
    def generate_from_recipes(recipes: List[Dict], servings_multipliers: Dict = None) -> Dict:
        """
        Generate a grocery list from recipes
        
        Args:
            recipes: List of recipe dicts
            servings_multipliers: Dict mapping recipe_id to servings multiplier
        
        Returns:
            Grocery list with categorized items
        """
        try:
            consolidated = GroceryListGenerator.consolidate_ingredients(recipes, servings_multipliers)
            
            # Group by category
            by_category = defaultdict(list)
            for item in consolidated:
                by_category[item['category']].append(item)
            
            return {
                'items': consolidated,
                'by_category': dict(by_category),
                'total_items': len(consolidated),
                'recipes': [r.get('id', '') for r in recipes]
            }
        except Exception as e:
            logger.error(f"Error generating grocery list: {e}")
            return {'items': [], 'by_category': {}, 'total_items': 0, 'recipes': []}
    
    @staticmethod
    def parse_ingredient_quantity(ingredient: str) -> Tuple[float, str, str]:
        """
        Parse ingredient string to extract quantity, unit, and name
        
        Args:
            ingredient: Ingredient string like "2 cups flour"
        
        Returns:
            Tuple of (quantity, unit, ingredient_name)
        """
        parts = ingredient.strip().split()
        
        quantity = 1.0
        unit = ''
        name_parts = []
        
        if parts:
            try:
                quantity = float(parts[0])
                idx = 1
            except ValueError:
                idx = 0
            
            if idx < len(parts) and parts[idx].lower() in ['g', 'ml', 'oz', 'cup', 'tbsp', 'tsp', 'lbs', 'kg', 'l']:
                unit = parts[idx]
                name_parts = parts[idx+1:]
            else:
                name_parts = parts[idx:]
        
        name = ' '.join(name_parts) if name_parts else ingredient
        return quantity, unit, name
