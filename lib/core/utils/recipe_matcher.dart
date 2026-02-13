import '../models/recipe.dart';
import '../models/ingredient.dart';
String normalizeIngredient(String text) {
  return text
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-zA-Z\s]'), '') // ลบตัวเลข/หน่วย
      .replaceAll(RegExp(r'\b(chopped|minced|finely|fresh|tsp|tbsp|cup|lb|oz)\b'), '')
      .trim();
}

DateTime _soonestExpiry(
  Recipe recipe,
  List<Ingredient> fridgeIngredients,
) {
  final now = DateTime.now();

  DateTime soonest = now.add(const Duration(days: 365));

  for (final ing in recipe.ingredients) {
    for (final userIng in fridgeIngredients) {
      if (ing.toLowerCase().contains(userIng.name.toLowerCase())) {
        if (userIng.expiryDate.isBefore(soonest)) {
          soonest = userIng.expiryDate;
        }
      }
    }
  }

  return soonest;
}

List<Recipe> matchRecipes(
  List<Recipe> recipes,
  List<Ingredient> userIngredients,
) {
  /// ✅ ใช้เฉพาะของที่อยู่ในตู้เย็น
  final fridgeIngredients =
      userIngredients.where((i) => i.inFridge).toList();

  final userNames = fridgeIngredients
      .map((i) => normalizeIngredient(i.name))
      .toSet();

  for (final recipe in recipes) {
    final matched = recipe.ingredients.where((ing) {
      final recipeIng = normalizeIngredient(ing);

      return userNames.any(
        (userIng) => recipeIng.contains(userIng),
      );
    });

    recipe.matchPercent =
        recipe.ingredients.isEmpty
            ? 0
            : matched.length / recipe.ingredients.length * 100;
  }

  recipes.sort((a, b) {
    int cmp = b.matchPercent.compareTo(a.matchPercent);

    if (cmp != 0) return cmp;

    // tie-breaker: ใช้ของใกล้หมดอายุก่อน (เฉพาะของในตู้เย็น)
    final soonA = _soonestExpiry(a, fridgeIngredients);
    final soonB = _soonestExpiry(b, fridgeIngredients);

    return soonA.compareTo(soonB);
  });

  return recipes.where((r) => r.matchPercent > 0).toList();
}