import 'package:flutter/material.dart';
import 'login_page.dart';
import 'sign_in_page.dart';
import 'about_page.dart';
import 'SearchByIngredientPage.dart';
import 'package:http/http.dart' as http;
import 'Recipedetailpage.dart';
import 'dart:convert';
import 'AdvancedSearchPage.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String apiKey = '19db8be00ca84d3a9aa48caa2934852f'; // Replace with your API key
  final TextEditingController _searchController = TextEditingController();

  Future<void> _searchRecipe(String recipeName) async {
    if (recipeName.isEmpty) {
      _showMessage('Please enter a recipe name.');
      return;
    }
    final url = 'https://api.spoonacular.com/recipes/search?query=$recipeName&apiKey=$apiKey';
    print('Request URL: $url');
    try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data); // Debugging output

      if (data['results'].isNotEmpty) {
        var recipe = data['results'][0]; // Get the first recipe
        int recipeId = recipe['id'];

        // Fetch detailed information about the recipe
        final recipeResponse = await http.get(Uri.parse(
            'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=$apiKey'));
        if (recipeResponse.statusCode == 200) {
          var recipeDetail = json.decode(recipeResponse.body);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailPage.fromJson(recipeDetail),
            ),
          );
        } else {
          _showMessage('Failed to fetch recipe details.');
        }
      } else {
        _showMessage('No recipes found for "$recipeName".');
      }
    } else {
      _showMessage('Failed to fetch recipes. Response code: ${response.statusCode}');
      }
  }catch (e) {
      _showMessage('An error occurred: $e');
    }
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
      appBar: AppBar(
        title: Center(
          child: Text(
            'Easy Cook',
            style: TextStyle(
              fontSize: 50, // Increased font size
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 11, 169, 177), // Changed color
            ),
          ),
        ),
        leading: PopupMenuButton<String>(
          icon: Icon(Icons.menu), // Menu icon on the left
          onSelected: (value) {
            if (value == 'Search by Ingredient') {
              // Navigate to Search by Ingredient Page
              // Uncomment and create the respective page
               Navigator.push(context, MaterialPageRoute(builder: (context) => SearchByIngredientPage()));
            } else if (value == 'Advanced Search') {
              // Navigate to Advanced Search Page
              Navigator.push(context, MaterialPageRoute(builder: (context) => AdvancedSearchPage()));
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'Search by Ingredient',
                child: Text('Search by Ingredient'),
              ),
              PopupMenuItem<String>(
                value: 'Advanced Search',
                child: Text('Advanced Search'),
              ),
            ];
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.person), // User icon
            onSelected: (value) {
              if (value == 'Login') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              } else if (value == 'Sign In') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Login', 'Sign In'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.settings),
            onSelected: (value) {
              if (value == 'Profile') {
                // Navigate to Profile Page
                /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );*/
              } else if (value == 'App Settings') {
                // Navigate to App Settings Page
                /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AppSettingsPage()),
                );*/
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Profile',
                  child: Text('Profile'),
                ),
                PopupMenuItem<String>(
                  value: 'App Settings',
                  child: Text('App Settings'),
                ),
              ];
            },
          ),
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              // Navigate to history
            },
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AboutPage()),
    );// Navigate to about
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpeg'), // Add your background image here
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for recipes...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (value) {
                    _searchRecipe(value); 
                    // Implement search functionality
                  },
                ),
              ),
              
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  _searchRecipe(_searchController.text);// Navigate to search
                },
                child: Text('Search'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '© 2024 Easy Cook. All rights reserved.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
