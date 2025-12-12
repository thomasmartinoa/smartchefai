import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartchefai/providers/recipes_provider.dart';
import 'package:smartchefai/widgets/custom_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecipeProvider>().getAllRecipes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: SmartChefAppBar(title: '🍳 SmartChef'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar with multi-modal input
            SmartChefSearchBar(
              controller: _searchController,
              onChanged: (query) {
                if (query.isNotEmpty) {
                  context.read<RecipeProvider>().searchRecipes(query);
                }
              },
              onVoicePressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Voice search coming soon!')),
                );
              },
              onCameraPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Camera detection coming soon!')),
                );
              },
            ),

            // Featured Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trending Recipes',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Consumer<RecipeProvider>(
                    builder: (context, provider, _) {
                      if (provider.isLoading) {
                        return const LoadingState(message: 'Loading recipes...');
                      }

                      if (provider.error != null) {
                        return ErrorState(
                          message: provider.error!,
                          onRetry: () => provider.getAllRecipes(),
                        );
                      }

                      if (provider.recipes.isEmpty) {
                        return const EmptyState(
                          message: 'No recipes found. Try searching!',
                          icon: Icons.restaurant,
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: provider.recipes.take(6).length,
                        itemBuilder: (context, index) {
                          final recipe = provider.recipes[index];
                          final isFavorite = provider.isFavorite(recipe.id);

                          return RecipeCard(
                            recipe: recipe,
                            isFavorite: isFavorite,
                            onTap: () {
                              // Navigate to recipe details
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Selected: ${recipe.name}')),
                              );
                            },
                            onFavoriteTap: () {
                              if (isFavorite) {
                                provider.removeFavorite(recipe.id);
                              } else {
                                provider.addFavorite('user1', recipe.id);
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            // Search History
            Consumer<RecipeProvider>(
              builder: (context, provider, _) {
                if (provider.searchHistory.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Searches',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          GestureDetector(
                            onTap: provider.clearSearchHistory,
                            child: Text(
                              'Clear',
                              style: TextStyle(color: Colors.orange.shade600, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: provider.searchHistory.map((query) {
                          return GestureDetector(
                            onTap: () {
                              _searchController.text = query;
                              provider.searchRecipes(query);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                query,
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
