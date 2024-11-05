// lib/pages/search_by_ingredient_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchByIngredientPage extends StatefulWidget {
  @override
  _SearchByIngredientPageState createState() => _SearchByIngredientPageState();
}

class _SearchByIngredientPageState extends State<SearchByIngredientPage> {
  final Map<String, List<String>> _ingredients = {
    'Meats': ['Chicken', 'Beef', 'Pork', 'Fish'],
    'Vegetables': ['Carrot', 'Potato', 'Tomato', 'Spinach'],
    'Spices': ['Salt', 'Pepper', 'Paprika', 'Cumin'],
  };

  Map<String, bool> _selectedIngredients = {};
  final String apiKey = '19db8be00ca84d3a9aa48caa2934852f'; // Replace with your API key

  @override
  void initState() {
    super.initState();
    for (var category in _ingredients.keys) {
      for (var ingredient in _ingredients[category]!) {
        _selectedIngredients[ingredient] = false;
      }
    }
  }

  Future<void> _searchRecipes() async {
    List<String> selected = _selectedIngredients.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selected.isEmpty) {
      _showMessage('Please select at least one ingredient.');
      return;
    }

    String ingredientList = selected.join(',');
    final response = await http.get(Uri.parse(
        'https://api.spoonacular.com/recipes/findByIngredients?ingredients=$ingredientList&apiKey=$apiKey'));

    if (response.statusCode == 200) {
      List<dynamic> recipes = json.decode(response.body);
      List<RecipeDetail> recipeDetails = await _fetchRecipeDetails(recipes);
      _showRecipes(recipeDetails);
    } else {
      _showMessage('Failed to fetch recipes.');
    }
  }

  Future<List<RecipeDetail>> _fetchRecipeDetails(List<dynamic> recipes) async {
    List<RecipeDetail> recipeDetails = [];
    for (var recipe in recipes) {
      int recipeId = recipe['id'];
      final response = await http.get(Uri.parse(
          'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=$apiKey'));
      if (response.statusCode == 200) {
        var recipeInfo = json.decode(response.body);
        recipeDetails.add(RecipeDetail.fromJson(recipeInfo));
      }
    }
    return recipeDetails;
  }

  void _showRecipes(List<RecipeDetail> recipes) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Recipes'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400, // Set a height to allow scrolling
            child: ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(recipes[index].title),
                  leading: Image.network(recipes[index].imageUrl, width: 50, height: 50),
                  subtitle: Text(recipes[index].summary),
                  onTap: () {
                    _showRecipeDetails(recipes[index]);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showRecipeDetails(RecipeDetail recipe) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(recipe.title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(recipe.imageUrl),
                SizedBox(height: 10),
                Text('Ingredients:'),
                ...recipe.ingredients.map((ingredient) => Text('- $ingredient')).toList(),
                SizedBox(height: 10),
                Text('Instructions:'),
                Text(recipe.instructions),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Message'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search by Ingredient')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: _ingredients.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ...entry.value.map((ingredient) {
                        return CheckboxListTile(
                          title: Text(ingredient),
                          value: _selectedIngredients[ingredient],
                          onChanged: (bool? value) {
                            setState(() {
                              _selectedIngredients[ingredient] = value ?? false;
                            });
                          },
                        );
                      }).toList(),
                      Divider(),
                    ],
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: _searchRecipes,
              child: Text('Search Recipes'),
              style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 10)),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeDetail {
  final String title;
  final String imageUrl;
  final String summary;
  final String instructions;
  final List<String> ingredients;

  RecipeDetail({
    required this.title,
    required this.imageUrl,
    required this.summary,
    required this.instructions,
    required this.ingredients,
  });

  factory RecipeDetail.fromJson(Map<String, dynamic> json) {
    return RecipeDetail(
      title: json['title'],
      imageUrl: json['image'],
      summary: json['summary'],
      instructions: json['instructions'] ?? 'No instructions available.',
      ingredients: List<String>.from(json['extendedIngredients'].map((ingredient) => ingredient['name'])),
    );
  }
}
