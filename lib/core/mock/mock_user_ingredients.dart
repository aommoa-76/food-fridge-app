import '../models/ingredient.dart';

final List<Ingredient> mockUserIngredients = [
  Ingredient(
    name: 'Egg',
    category: "Protein",
    addedDate: DateTime.now().subtract(const Duration(days: 2)),
    expiryDate: DateTime.now().add(const Duration(days: 5)),
    inFridge: true,
  ),
  Ingredient(
    name: 'Milk',
    category: "Protein",
    addedDate: DateTime.now().subtract(const Duration(days: 4)),
    expiryDate: DateTime.now().add(const Duration(days: 2)),
    inFridge: true,
  ),
  Ingredient(
    name: 'Onion',
    category: "Vegetables",
    addedDate: DateTime.now().subtract(const Duration(days: 7)),
    expiryDate: DateTime.now().add(const Duration(days: 10)),
    inFridge: true,
  ),
  Ingredient(
    name: 'Garlic',
    category: "Vegetables",
    addedDate: DateTime.now().subtract(const Duration(days: 3)),
    expiryDate: DateTime.now().add(const Duration(days: 20)),
    inFridge: true,
  ),

  /// ❌ อันนี้ไม่อยู่ในตู้เย็น → จะไม่ถูก match
  Ingredient(
    name: 'Flour',
    category: "Carbohydrate",
    addedDate: DateTime.now().subtract(const Duration(days: 20)),
    expiryDate: DateTime.now().add(const Duration(days: 200)),
    inFridge: false,
  ),
];
