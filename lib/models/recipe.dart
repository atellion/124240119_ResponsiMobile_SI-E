// Satu model untuk resep. Nama key JSON sama dengan API dummyjson,
// jadi fromJson/toJson dipakai untuk API sekaligus untuk simpan favourite.
class Recipe {
  final int id;
  final String name;
  final String cuisine;
  final String difficulty;
  final String image;
  final double rating;
  final int reviewCount;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final int caloriesPerServing;
  final List<String> mealType;
  final List<String> ingredients;
  final List<String> instructions;

  const Recipe({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.difficulty,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.caloriesPerServing,
    required this.mealType,
    required this.ingredients,
    required this.instructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> j) => Recipe(
        id: j['id'] as int,
        name: (j['name'] ?? '') as String,
        cuisine: (j['cuisine'] ?? '-') as String,
        difficulty: (j['difficulty'] ?? '-') as String,
        image: (j['image'] ?? '') as String,
        rating: ((j['rating'] ?? 0) as num).toDouble(),
        reviewCount: (j['reviewCount'] ?? 0) as int,
        prepTimeMinutes: (j['prepTimeMinutes'] ?? 0) as int,
        cookTimeMinutes: (j['cookTimeMinutes'] ?? 0) as int,
        servings: (j['servings'] ?? 0) as int,
        caloriesPerServing: (j['caloriesPerServing'] ?? 0) as int,
        mealType: List<String>.from(j['mealType'] ?? []),
        ingredients: List<String>.from(j['ingredients'] ?? []),
        instructions: List<String>.from(j['instructions'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cuisine': cuisine,
        'difficulty': difficulty,
        'image': image,
        'rating': rating,
        'reviewCount': reviewCount,
        'prepTimeMinutes': prepTimeMinutes,
        'cookTimeMinutes': cookTimeMinutes,
        'servings': servings,
        'caloriesPerServing': caloriesPerServing,
        'mealType': mealType,
        'ingredients': ingredients,
        'instructions': instructions,
      };
}
