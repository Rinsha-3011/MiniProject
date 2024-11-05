import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';  // Make sure to import your AuthService

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  // Dropdown menu items
  String selectedCuisine = 'Italian'; // Default value
  String selectedDietaryRestriction = 'None'; // Default value

  List<String> cuisines = ['Italian', 'Chinese', 'Indian', 'Mexican', 'American'];
  List<String> dietaryRestrictions = ['None', 'Vegan', 'Vegetarian', 'Gluten-Free', 'Keto'];

  // Function to handle sign up
  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      String name = nameController.text;
      String email = emailController.text;
      String password = passwordController.text;
      String confirmPassword = confirmPasswordController.text;

      if (password != confirmPassword) {
        _showMessage('Passwords do not match');
        return;
      }

      try {
        User? user = await AuthService().signUp(
          email: email,
          password: password,
          userData: {
            'name': name,
            'preferredCuisine': selectedCuisine,
            'dietaryRestriction': selectedDietaryRestriction,
            'email': email,
          },
        );

        if (user != null) {
          // User signed up successfully, navigate to the home page or login
          _showMessage('Sign-up successful. Welcome, ${user.email}');
          Navigator.pop(context); // Navigate back to the previous screen (or home page)
        }
      } catch (e) {
        _showMessage('Error signing up: $e');
      }
    }
  }

  // Function to show a simple alert dialog
  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Message'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
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
        title: Text('Sign Up'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name', style: TextStyle(fontSize: 18)),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                Text('Preferred Cuisine', style: TextStyle(fontSize: 18)),
                DropdownButtonFormField<String>(
                  value: selectedCuisine,
                  items: cuisines.map((String cuisine) {
                    return DropdownMenuItem<String>(
                      value: cuisine,
                      child: Text(cuisine),
                    );
                  }).toList(),
                  onChanged: (String? newCuisine) {
                    setState(() {
                      selectedCuisine = newCuisine!;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),

                Text('Dietary Restriction', style: TextStyle(fontSize: 18)),
                DropdownButtonFormField<String>(
                  value: selectedDietaryRestriction,
                  items: dietaryRestrictions.map((String restriction) {
                    return DropdownMenuItem<String>(
                      value: restriction,
                      child: Text(restriction),
                    );
                  }).toList(),
                  onChanged: (String? newRestriction) {
                    setState(() {
                      selectedDietaryRestriction = newRestriction!;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),

                Text('Email', style: TextStyle(fontSize: 18)),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                        .hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                Text('Password', style: TextStyle(fontSize: 18)),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password should be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                Text('Confirm Password', style: TextStyle(fontSize: 18)),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Confirm your password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _signUp,
                  child: Text('Sign Up'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
