"""
Package init file for backend routes
"""

from .recipes import recipe_bp
from .detection import detector_bp
from .users import user_bp
from .grocery import grocery_bp

__all__ = [
    'recipe_bp',
    'detector_bp',
    'user_bp',
    'grocery_bp',
]
