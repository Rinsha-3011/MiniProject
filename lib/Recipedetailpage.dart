// lib/pages/recipe_detail_page.dart
import 'package:flutter/material.dart';

class RecipeDetailPage extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String instructions;
  final List<String> ingredients;

  RecipeDetailPage({
    required this.title,
    required this.imageUrl,
    required this.instructions,
    required this.ingredients,
  });

  // Factory constructor to create an instance from JSON
  factory RecipeDetailPage.fromJson(Map<String, dynamic> json) {
    print('Image URL: ${json['image']}'); 
    return RecipeDetailPage(
      title: json['title'],
      imageUrl: json['image'],
      instructions: json['instructions'] ?? 'No instructions available.',
      ingredients: List<String>.from(
        json['extendedIngredients'].map((ingredient) => ingredient['name']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Image.asset('assets/images/placeholder.png'); // Replace with your placeholder image
              },
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Ingredients:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ingredients.map((ingredient) {
                  return Text('- $ingredient');
                }).toList(),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Instructions:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(instructions),
            ),
          ],
        ),
      ),
    );
  }
}
