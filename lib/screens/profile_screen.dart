import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartchefai/providers/app_providers.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          if (!userProvider.isAuthenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person, size: 80),
                  const SizedBox(height: 16),
                  const Text('Not logged in'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Show login dialog
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            );
          }

          final user = userProvider.currentUser;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person, size: 50),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user?.name ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(user?.email ?? ''),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Dietary Preferences'),
              if ((user?.dietaryPreferences.isEmpty ?? true))
                const Text('No preferences set')
              else
                Wrap(
                  children: (user?.dietaryPreferences ?? [])
                      .map((pref) => Chip(label: Text(pref)))
                      .toList(),
                ),
              const SizedBox(height: 16),
              const Text('Allergies'),
              if ((user?.allergies.isEmpty ?? true))
                const Text('No allergies listed')
              else
                Wrap(
                  children: (user?.allergies ?? [])
                      .map((allergy) => Chip(label: Text(allergy)))
                      .toList(),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Show preferences dialog
                },
                child: const Text('Edit Preferences'),
              ),
            ],
          );
        },
      ),
    );
  }
}
