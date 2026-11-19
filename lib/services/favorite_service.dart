import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

// Satu sumber kebenaran untuk favourite. Halaman Detail dan Favourite sama-sama
// membaca & mengubah object ini; ChangeNotifier memberi tahu semua listener,
// sehingga kedua halaman otomatis ter-update.
class FavoriteService extends ChangeNotifier {
  FavoriteService._();
  static final FavoriteService instance = FavoriteService._();

  String _username = '';
  List<Recipe> _items = [];

  List<Recipe> get items => List.unmodifiable(_items);
  String get _key => 'favorites_$_username'; // favourite per user

  Future<void> load(String username) async {
    _username = username;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    _items = raw
        .map((s) => Recipe.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
    notifyListeners();
  }

  bool isFavorite(int id) => _items.any((e) => e.id == id);

  // return true jika sekarang menjadi favourite, false jika dihapus
  Future<bool> toggle(Recipe recipe) async {
    final wasFav = isFavorite(recipe.id);
    if (wasFav) {
      _items.removeWhere((e) => e.id == recipe.id);
    } else {
      _items.add(recipe);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        _key, _items.map((e) => jsonEncode(e.toJson())).toList());
    return !wasFav;
  }

  void clear() {
    _username = '';
    _items = [];
    notifyListeners();
  }
}
