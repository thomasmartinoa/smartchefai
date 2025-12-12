import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartchefai/providers/app_providers.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Recipes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or ingredients...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSubmitted: (query) {
                context.read<RecipeProvider>().searchRecipes(query);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<RecipeProvider>().searchRecipes(_searchController.text);
              },
              icon: const Icon(Icons.search),
              label: const Text('Search'),
            ),
          ),
          Expanded(
            child: Consumer<RecipeProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.recipes.isEmpty) {
                  return const Center(child: Text('Enter a search query'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = provider.recipes[index];
                    return ListTile(
                      title: Text(recipe.name),
                      subtitle: Text('${recipe.cuisine} • ${recipe.difficulty}'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        // Navigate to recipe detail
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
