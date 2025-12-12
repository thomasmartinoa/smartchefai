"""
Nutrition tracking and calculation
"""
from typing import Dict, List
import logging

logger = logging.getLogger(__name__)

class NutritionCalculator:
    """Calculate nutrition information for recipes"""
    
    @staticmethod
    def calculate_recipe_nutrition(recipe: Dict) -> Dict:
        """
        Calculate total nutrition for a recipe
        
        Args:
            recipe: Recipe dict with nutrition info
        
        Returns:
            Nutrition dict with totals and per-serving info
        """
        try:
            nutrition = recipe.get('nutrition', {})
            servings = recipe.get('servings', 1)
            
            if not nutrition:
                return NutritionCalculator._empty_nutrition()
            
            total_calories = float(nutrition.get('calories', 0))
            total_protein = NutritionCalculator._parse_quantity(nutrition.get('protein', '0'))
            total_carbs = NutritionCalculator._parse_quantity(nutrition.get('carbs', '0'))
            total_fat = NutritionCalculator._parse_quantity(nutrition.get('fat', '0'))
            total_fiber = NutritionCalculator._parse_quantity(nutrition.get('fiber', '0'))
            
            per_serving_calories = total_calories / servings if servings > 0 else 0
            per_serving_protein = total_protein / servings if servings > 0 else 0
            per_serving_carbs = total_carbs / servings if servings > 0 else 0
            per_serving_fat = total_fat / servings if servings > 0 else 0
            per_serving_fiber = total_fiber / servings if servings > 0 else 0
            
            return {
                'per_recipe': {
                    'calories': round(total_calories, 1),
                    'protein_g': round(total_protein, 1),
                    'carbs_g': round(total_carbs, 1),
                    'fat_g': round(total_fat, 1),
                    'fiber_g': round(total_fiber, 1)
                },
                'per_serving': {
                    'calories': round(per_serving_calories, 1),
                    'protein_g': round(per_serving_protein, 1),
                    'carbs_g': round(per_serving_carbs, 1),
                    'fat_g': round(per_serving_fat, 1),
                    'fiber_g': round(per_serving_fiber, 1)
                },
                'macros_percentage': NutritionCalculator._calculate_macro_percentages(
                    per_serving_protein, per_serving_carbs, per_serving_fat
                )
            }
        except Exception as e:
            logger.error(f"Error calculating nutrition: {e}")
            return NutritionCalculator._empty_nutrition()
    
    @staticmethod
    def calculate_multiple_recipes(recipes: List[Dict]) -> Dict:
        """
        Calculate combined nutrition for multiple recipes
        
        Args:
            recipes: List of recipe dicts
        
        Returns:
            Combined nutrition info
        """
        total_calories = 0
        total_protein = 0
        total_carbs = 0
        total_fat = 0
        total_fiber = 0
        total_servings = 0
        
        for recipe in recipes:
            nutrition = NutritionCalculator.calculate_recipe_nutrition(recipe)
            
            total_calories += nutrition['per_recipe']['calories']
            total_protein += nutrition['per_recipe']['protein_g']
            total_carbs += nutrition['per_recipe']['carbs_g']
            total_fat += nutrition['per_recipe']['fat_g']
            total_fiber += nutrition['per_recipe']['fiber_g']
            total_servings += recipe.get('servings', 1)
        
        avg_servings = total_servings / len(recipes) if recipes else 1
        
        return {
            'total_recipes': len(recipes),
            'per_recipe_avg': {
                'calories': round(total_calories / len(recipes), 1) if recipes else 0,
                'protein_g': round(total_protein / len(recipes), 1) if recipes else 0,
                'carbs_g': round(total_carbs / len(recipes), 1) if recipes else 0,
                'fat_g': round(total_fat / len(recipes), 1) if recipes else 0,
                'fiber_g': round(total_fiber / len(recipes), 1) if recipes else 0
            },
            'macros_percentage': NutritionCalculator._calculate_macro_percentages(
                total_protein / len(recipes) if recipes else 0,
                total_carbs / len(recipes) if recipes else 0,
                total_fat / len(recipes) if recipes else 0
            )
        }
    
    @staticmethod
    def _parse_quantity(value: str) -> float:
        """Parse quantity string like '18g' to float"""
        try:
            # Remove common units and convert to number
            value_str = str(value).lower().strip()
            for unit in ['g', 'mg', 'ml', 'l', 'oz', 'lbs', 'cup', 'tbsp', 'tsp']:
                value_str = value_str.replace(unit, '').strip()
            return float(value_str) if value_str else 0
        except (ValueError, TypeError):
            return 0
    
    @staticmethod
    def _calculate_macro_percentages(protein_g: float, carbs_g: float, fat_g: float) -> Dict:
        """
        Calculate macro percentage breakdown
        
        Returns:
            Dict with protein_pct, carbs_pct, fat_pct
        """
        # Calorie values per gram
        protein_cal = protein_g * 4
        carbs_cal = carbs_g * 4
        fat_cal = fat_g * 9
        
        total_cal = protein_cal + carbs_cal + fat_cal
        
        if total_cal == 0:
            return {'protein_pct': 0, 'carbs_pct': 0, 'fat_pct': 0}
        
        return {
            'protein_pct': round((protein_cal / total_cal) * 100, 1),
            'carbs_pct': round((carbs_cal / total_cal) * 100, 1),
            'fat_pct': round((fat_cal / total_cal) * 100, 1)
        }
    
    @staticmethod
    def _empty_nutrition() -> Dict:
        """Return empty nutrition object"""
        return {
            'per_recipe': {'calories': 0, 'protein_g': 0, 'carbs_g': 0, 'fat_g': 0, 'fiber_g': 0},
            'per_serving': {'calories': 0, 'protein_g': 0, 'carbs_g': 0, 'fat_g': 0, 'fiber_g': 0},
            'macros_percentage': {'protein_pct': 0, 'carbs_pct': 0, 'fat_pct': 0}
        }
    
    @staticmethod
    def is_recipe_dietary_compliant(recipe: Dict, dietary_requirements: Dict) -> bool:
        """
        Check if recipe meets dietary requirements
        
        Args:
            recipe: Recipe dict
            dietary_requirements: Dict with 'max_calories', 'min_protein', etc.
        
        Returns:
            Boolean indicating compliance
        """
        nutrition = NutritionCalculator.calculate_recipe_nutrition(recipe)
        per_serving = nutrition['per_serving']
        
        if 'max_calories' in dietary_requirements:
            if per_serving['calories'] > dietary_requirements['max_calories']:
                return False
        
        if 'min_protein' in dietary_requirements:
            if per_serving['protein_g'] < dietary_requirements['min_protein']:
                return False
        
        if 'max_carbs' in dietary_requirements:
            if per_serving['carbs_g'] > dietary_requirements['max_carbs']:
                return False
        
        if 'max_fat' in dietary_requirements:
            if per_serving['fat_g'] > dietary_requirements['max_fat']:
                return False
        
        dietary_tags = recipe.get('dietary_tags', [])
        
        if 'vegetarian' in dietary_requirements and dietary_requirements['vegetarian']:
            if 'vegetarian' not in dietary_tags:
                return False
        
        if 'vegan' in dietary_requirements and dietary_requirements['vegan']:
            if 'vegan' not in dietary_tags:
                return False
        
        if 'gluten_free' in dietary_requirements and dietary_requirements['gluten_free']:
            if 'gluten-free' not in dietary_tags:
                return False
        
        return True
