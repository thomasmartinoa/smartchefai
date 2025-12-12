"""
Image-based ingredient detection using YOLO
"""
import cv2
import numpy as np
from PIL import Image
import io
import logging
from typing import List, Tuple, Dict
import torch
from pathlib import Path

logger = logging.getLogger(__name__)

class IngredientDetector:
    """Ingredient detection using pre-trained YOLO model"""
    
    def __init__(self, model_name: str = 'yolov5s'):
        """
        Initialize the ingredient detector
        
        Args:
            model_name: YOLO model to use (yolov5n, yolov5s, yolov5m, etc.)
        """
        try:
            # Load pre-trained YOLOv5 model
            self.model = torch.hub.load('ultralytics/yolov5', model_name, pretrained=True)
            self.model.conf = 0.45  # Confidence threshold
            logger.info(f"Loaded {model_name} model successfully")
        except Exception as e:
            logger.error(f"Error loading model: {e}")
            self.model = None
    
    def detect_ingredients(self, image_path: str = None, image_bytes: bytes = None) -> Tuple[List[Dict], Image.Image]:
        """
        Detect ingredients in an image
        
        Args:
            image_path: Path to image file
            image_bytes: Image as bytes
        
        Returns:
            Tuple of (detected_ingredients, annotated_image)
            where detected_ingredients is a list of dicts with 'name', 'confidence', 'bbox'
        """
        if self.model is None:
            logger.error("Model not initialized")
            return [], None
        
        try:
            # Load image
            if image_path:
                img = Image.open(image_path)
            elif image_bytes:
                img = Image.open(io.BytesIO(image_bytes))
            else:
                return [], None
            
            # Convert to RGB if necessary
            if img.mode != 'RGB':
                img = img.convert('RGB')
            
            # Run inference
            results = self.model(img)
            
            # Extract detections
            detections = []
            boxes = results.xyxy[0].cpu().numpy()
            confidences = results.conf[0].cpu().numpy()
            classes = results.cls[0].cpu().numpy()
            
            for box, confidence, cls in zip(boxes, confidences, classes):
                x1, y1, x2, y2 = box
                ingredient_name = results.names[int(cls)]
                
                detections.append({
                    'name': ingredient_name,
                    'confidence': float(confidence),
                    'bbox': {
                        'x1': float(x1),
                        'y1': float(y1),
                        'x2': float(x2),
                        'y2': float(y2)
                    }
                })
            
            # Draw annotations
            annotated_img = results.render()[0]
            annotated_pil = Image.fromarray(annotated_img)
            
            logger.info(f"Detected {len(detections)} ingredients")
            return detections, annotated_pil
        
        except Exception as e:
            logger.error(f"Error detecting ingredients: {e}")
            return [], None
    
    def get_ingredient_list(self, detections: List[Dict]) -> List[str]:
        """
        Extract unique ingredient names from detections
        
        Args:
            detections: List of detection dicts
        
        Returns:
            List of unique ingredient names
        """
        ingredients = []
        seen = set()
        
        for detection in sorted(detections, key=lambda x: x['confidence'], reverse=True):
            ingredient = detection['name'].lower().strip()
            if ingredient not in seen:
                ingredients.append(ingredient)
                seen.add(ingredient)
        
        return ingredients
    
    def filter_by_confidence(self, detections: List[Dict], threshold: float = 0.6) -> List[Dict]:
        """
        Filter detections by confidence score
        
        Args:
            detections: List of detection dicts
            threshold: Minimum confidence threshold
        
        Returns:
            Filtered list of detections
        """
        return [d for d in detections if d['confidence'] >= threshold]
