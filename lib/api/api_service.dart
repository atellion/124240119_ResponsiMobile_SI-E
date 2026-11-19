import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

const String baseUrl = 'https://dummyjson.com/recipes';

// Ambil semua resep (API membungkus datanya di key 'recipes')
Future<List<Recipe>> getRecipes() async {
  final response = await http.get(Uri.parse('$baseUrl?limit=50'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final results = data['recipes'] as List<dynamic>;
    return results
        .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Failed to load recipes');
  }
}

// Detail diakses berdasarkan id: /recipes/{id}
Future<Recipe> getRecipeDetail(int id) async {
  final response = await http.get(Uri.parse('$baseUrl/$id'));
  if (response.statusCode == 200) {
    return Recipe.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load detail');
  }
}
