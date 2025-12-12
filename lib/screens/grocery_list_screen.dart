import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartchefai/providers/app_providers.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery Lists'),
      ),
      body: Consumer<GroceryListProvider>(
        builder: (context, provider, _) {
          if (provider.lists.isEmpty) {
            return const Center(
              child: Text('No grocery lists yet'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.lists.length,
            itemBuilder: (context, index) {
              final list = provider.lists[index];
              return Card(
                child: ListTile(
                  title: Text('Grocery List ${index + 1}'),
                  subtitle: Text('${list.totalItems} items'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    // Navigate to grocery list detail
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create new grocery list
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
