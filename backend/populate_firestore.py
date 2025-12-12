#!/usr/bin/env python3
"""
Script to populate Firebase Firestore with sample recipes
Run after setting up Firebase credentials
"""

import json
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import os
import sys

def load_recipes(json_file):
    """Load recipes from JSON file"""
    try:
        with open(json_file, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"Error: Recipe file not found at {json_file}")
        sys.exit(1)
    except json.JSONDecodeError:
        print(f"Error: Invalid JSON in {json_file}")
        sys.exit(1)

def init_firebase(cred_path):
    """Initialize Firebase"""
    try:
        if not os.path.exists(cred_path):
            print(f"Error: Firebase credentials not found at {cred_path}")
            print("Please create firebase-credentials.json in the backend directory")
            sys.exit(1)
        
        if not firebase_admin._apps:
            cred = credentials.Certificate(cred_path)
            firebase_admin.initialize_app(cred)
        
        return firestore.client()
    except Exception as e:
        print(f"Error initializing Firebase: {e}")
        sys.exit(1)

def populate_recipes(db, recipes):
    """Add recipes to Firestore"""
    batch = db.batch()
    count = 0
    
    print(f"Populating {len(recipes)} recipes...")
    
    for recipe in recipes:
        doc_ref = db.collection('recipes').document()
        batch.set(doc_ref, recipe)
        count += 1
        
        # Commit in batches of 500
        if count % 500 == 0:
            batch.commit()
            print(f"Committed {count} recipes...")
            batch = db.batch()
    
    # Commit remaining
    if count % 500 != 0:
        batch.commit()
    
    print(f"Successfully added {count} recipes to Firestore!")

def main():
    """Main function"""
    print("SmartChef AI - Firebase Data Population Script")
    print("=" * 50)
    
    cred_path = './firebase-credentials.json'
    recipes_path = '../data/recipes.json'
    
    print("\nInitializing Firebase...")
    db = init_firebase(cred_path)
    
    print("Loading recipes...")
    recipes = load_recipes(recipes_path)
    
    print(f"Found {len(recipes)} recipes")
    
    # Confirm before populating
    response = input("\nProceed with populating Firestore? (yes/no): ")
    if response.lower() != 'yes':
        print("Cancelled.")
        sys.exit(0)
    
    populate_recipes(db, recipes)
    print("\nDone!")

if __name__ == '__main__':
    main()
