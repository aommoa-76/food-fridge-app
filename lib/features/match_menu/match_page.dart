import 'package:flutter/material.dart';
import '../../core/mock/mock_recipes.dart';
import '../../core/mock/mock_user_ingredients.dart';
import '../../core/utils/recipe_matcher.dart';
import '../../core/models/recipe.dart';
import '../../core/state/favorites_state.dart';
import '../recipe/recipe_card.dart';
import '../recipe/recipe_detail_page.dart';
import 'dart:async';
import '../../app/logout.dart';

Timer? _timer;


class MatchMenuPage extends StatefulWidget {
  const MatchMenuPage({super.key});

  @override
  State<MatchMenuPage> createState() => _MatchMenuPageState();
}

class _MatchMenuPageState extends State<MatchMenuPage> {
  late List<Recipe> matchedRecipes;
  static const primaryGreen = Color.fromARGB(255, 96, 235, 115);

  final FavoritesState _favoritesState =
    FavoritesState.instance;

  @override
  void initState() {
    super.initState();
    

    matchedRecipes =
        matchRecipes(mockRecipeList, mockUserIngredients);

    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) {
        setState(() {
          matchedRecipes =
              matchRecipes(
                  mockRecipeList,
                  mockUserIngredients);
        });
      },
    );
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text('Match Results'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton.icon(
              // 🔥 เรียกใช้ไฟล์กลาง ง่ายและสะอาด
              onPressed: () => AuthService.logout(context), 
              
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 69, 148, 79),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ).copyWith(
                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) => states.contains(WidgetState.pressed) 
                      ? Colors.green.withOpacity(0.2) 
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
      
    
      body: ListView.builder(
        
        padding: const EdgeInsets.all(16),
        itemCount: matchedRecipes.length,
        itemBuilder: (context, index) {
          final recipe = matchedRecipes[index];

          return Padding(
            
            
            padding: const EdgeInsets.only(bottom: 16),
            child: RecipeCard(
              title: recipe.title,
              description: recipe.description,
              imageUrl: recipe.imageUrl,
              matchPercent: recipe.matchPercent,

              /// ⭐ ใช้ FavoritesState
              isFavorite:
                  _favoritesState.isFavorite(recipe.idMeal),

              onFavoriteToggle: () {
                setState(() {
                  _favoritesState.toggleFavorite(recipe);
                });
              },

              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailPage(recipe: recipe),
                  ),
                );

                /// 🔥 refresh หลังกลับมา
                setState(() {
                  matchedRecipes =
                      matchRecipes(mockRecipeList, mockUserIngredients);
                });
              },
            ),
          );
        },
      ),
    );
  }
}