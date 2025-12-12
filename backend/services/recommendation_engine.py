"""
Recommendation engine using TF-IDF and collaborative filtering
"""
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from typing import List, Dict, Tuple, Optional
import logging

try:
    from fuzzywuzzy import fuzz
except ImportError:
    # Fallback if fuzzywuzzy not available
    fuzz = None

logger = logging.getLogger(__name__)

class RecommendationEngine:
    """
    TF-IDF + Cosine Similarity + Collaborative Filtering based recommendation system
    """
    
    def __init__(self, recipe_data: List[Dict] = None):
        self.tfidf_vectorizer = TfidfVectorizer(
            max_features=1000,
            stop_words='english',
            lowercase=True
        )
        self.recipes = recipe_data or []
        self.recipe_vectors = None
        self.recipe_ids = []
        if recipe_data:
            self._build_index()
    
    def _build_index(self):
        """Build TF-IDF index from recipes"""
        try:
            if not self.recipes:
                logger.warning("No recipes found for indexing")
                return
            
            # Prepare recipe documents (combining name, ingredients, cuisine, dietary tags)
            recipe_documents = []
            self.recipe_ids = []
            
            for recipe in self.recipes:
                doc_parts = [
                    recipe.get('name', ''),
                    ' '.join(recipe.get('ingredients', [])),
                    recipe.get('cuisine', ''),
                    ' '.join(recipe.get('dietary_tags', []))
                ]
                recipe_documents.append(' '.join(doc_parts))
                self.recipe_ids.append(recipe.get('id'))
            
            # Build TF-IDF vectors
            self.recipe_vectors = self.tfidf_vectorizer.fit_transform(recipe_documents)
            logger.info(f"Built index for {len(self.recipes)} recipes")
        except Exception as e:
            logger.error(f"Error building index: {e}")
    
    def search_recipes(self, query: str, limit: int = 15, filters: Dict = None) -> List[Dict]:
        """
        Search recipes using TF-IDF + Cosine Similarity
        
        Args:
            query: Search query (text)
            limit: Number of results to return
            filters: Optional filters (cuisine, difficulty, dietary_tags)
        
        Returns:
            List of ranked recipes with similarity scores
        """
        if not self.recipe_vectors is not None or len(self.recipes) == 0:
            return []
        
        try:
            # Vectorize query
            query_vector = self.tfidf_vectorizer.transform([query])
            
            # Calculate cosine similarity
            similarities = cosine_similarity(query_vector, self.recipe_vectors)[0]
            
            # Get top matches
            top_indices = np.argsort(similarities)[::-1]
            
            results = []
            for idx in top_indices:
                if len(results) >= limit:
                    break
                
                recipe = self.recipes[idx]
                score = float(similarities[idx])
                
                # Apply filters if provided
                if filters:
                    if filters.get('cuisine') and recipe.get('cuisine') != filters['cuisine']:
                        continue
                    if filters.get('difficulty') and recipe.get('difficulty') != filters['difficulty']:
                        continue
                    if filters.get('dietary_tags'):
                        if not any(tag in recipe.get('dietary_tags', []) for tag in filters['dietary_tags']):
                            continue
                
                recipe['similarity_score'] = score
                results.append(recipe)
            
            return results
        except Exception as e:
            logger.error(f"Error searching recipes: {e}")
            return []
    
    def search_by_ingredients(self, ingredients: List[str], limit: int = 15) -> List[Dict]:
        """
        Search recipes by available ingredients
        
        Args:
            ingredients: List of available ingredients
            limit: Number of results to return
        
        Returns:
            List of recipes ranked by ingredient match
        """
        query = ' '.join(ingredients)
        return self.search_recipes(query, limit)
    
    def fuzzy_match_ingredient(self, ingredient: str, threshold: int = 80) -> str:
        """
        Fuzzy match ingredient name to handle variations
        """
        all_ingredients = set()
        for recipe in self.recipes:
            all_ingredients.update(recipe.get('ingredients', []))
        
        best_match = ingredient
        best_score = 0
        
        for recipe_ingredient in all_ingredients:
            score = fuzz.ratio(ingredient.lower(), recipe_ingredient.lower())
            if score > best_score:
                best_score = score
                best_match = recipe_ingredient
        
        if best_score >= threshold:
            return best_match
        return ingredient
    
    def get_personalized_recommendations(self, user_id: str, limit: int = 10, user_interactions: List[Dict] = None) -> List[Dict]:
        """
        Get personalized recommendations using collaborative filtering
        
        Args:
            user_id: User ID
            limit: Number of recommendations
            user_interactions: Optional user interactions data
        
        Returns:
            List of personalized recipe recommendations
        """
        try:
            # Use provided interactions or fall back to empty list
            if not user_interactions:
                user_interactions = []
            
            if not user_interactions:
                # Return popular recipes if no history
                return self.search_recipes("popular", limit)
            
            # Get recipes the user rated highly
            liked_recipe_ids = [
                interaction['recipe_id'] 
                for interaction in user_interactions 
                if interaction.get('rating', 0) >= 4
            ]
            
            if not liked_recipe_ids:
                return self.search_recipes("popular", limit)
            
            # Find similar recipes
            recommendations = set()
            for liked_recipe_id in liked_recipe_ids[:5]:  # Use top 5 liked recipes
                # Find in self.recipes
                liked_recipe = next((r for r in self.recipes if r.get('id') == liked_recipe_id), None)
                if liked_recipe:
                    # Search for similar recipes
                    similar = self.search_recipes(
                        f"{liked_recipe.get('name')} {liked_recipe.get('cuisine')}",
                        limit=limit * 2
                    )
                    for recipe in similar:
                        if recipe.get('id') not in liked_recipe_ids:
                            recommendations.add(recipe['id'])
            
            # Get full recipe objects
            result_recipes = []
            for recipe_id in list(recommendations)[:limit]:
                recipe = next((r for r in self.recipes if r.get('id') == recipe_id), None)
                if recipe:
                    result_recipes.append(recipe)
            
            return result_recipes
        except Exception as e:
            logger.error(f"Error getting personalized recommendations: {e}")
            return []
    
    def rebuild_index(self):
        """Rebuild the recommendation index"""
        self._build_index()
