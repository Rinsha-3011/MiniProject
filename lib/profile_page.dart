import 'package:flutter/material.dart';
import 'package:mynewapp/data/local_storage/shared_preference.dart';
import 'package:mynewapp/services/service_locator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final sharedPrefService = serviceLocator<SharedPreferencesService>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50,),
                Text(
                    "Name: ${sharedPrefService.userName}",
                  style: const TextStyle(
                    fontSize: 20
                  ),
                ),
                Text(
                    "Email Id: ${sharedPrefService.email}",
                  style: const TextStyle(
                      fontSize: 20
                  ),
                ),
                Text(
                    "Dietry Restriction: ${sharedPrefService.dietryRestriction}",
                  style: const TextStyle(
                      fontSize: 20
                  ),
                ),
                Text(
                    "Preferred Cuisine: ${sharedPrefService.preferredCuisine}",
                  style: const TextStyle(
                      fontSize: 20
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
