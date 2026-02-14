class Recipe {
  final String idMeal;
  final String title;
  final String category;
  final String area;
  final String description;
  final String imageUrl;

  final List<String> ingredients;
  final List<String> steps;

  final String tags;         
  final String youtubeUrl;   


  double matchPercent; //ต้องการโชว์

  Recipe({
    required this.idMeal,
    required this.title,
    required this.category,
    required this.area,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.tags,
    required this.youtubeUrl,

    this.matchPercent = 0,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    /// 🔹 รวม ingredient + measure
    List<String> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null &&
          ingredient.toString().trim().isNotEmpty) {

        final text = "${measure ?? ''} ${ingredient}".trim();
        ingredients.add(text);
      }
    }

    /// 🔹 แยกขั้นตอนจาก instructions
    List<String> steps = [];

    final instructions = json['strInstructions'] ?? '';

    if (instructions.isNotEmpty) {
      // 🔹 ทำ newline ให้เหมือนกัน
      String normalized = instructions
          .replaceAll('\r\n', '\n')
          .replaceAll('\r', '\n');

      // 🔹 split
      List<String> rawSteps = normalized.split('\n');

      for (var s in rawSteps) {
        String step = s.trim();

        if (step.isEmpty) continue;

        // 🔹 ลบ "step 1", "1", "2", etc.
        step = step.replaceFirst(RegExp(r'^(step\s*\d+|\d+)[\.\)]?\s*', caseSensitive: false), '');

        if (step.isNotEmpty) {
          steps.add(step);
        }
      }
    }

    return Recipe(
      idMeal: json['idMeal'] ?? '',
      title: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      description: json['strInstructions'] ?? '',
      imageUrl: json['strMealThumb'] ?? '',
      ingredients: ingredients,
      steps: steps,
      tags: json['strTags'] ?? '',
      youtubeUrl: json['strYoutube'] ?? '',
    );
  }
}