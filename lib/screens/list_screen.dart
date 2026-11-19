import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/recipe.dart';
import '../services/auth_service.dart';
import '../services/favorite_service.dart';
import 'detail_screen.dart';
import 'favorite_screen.dart';
import 'login_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Recipe> recipes = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    fetchRecipes();
  }

  void _loadFavorites() async {
    final name = await AuthService.currentUsername();
    await FavoriteService.instance.load(name);
  }

  Future<void> fetchRecipes() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final data = await getRecipes();
      setState(() {
        recipes = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Gagal memuat data. Periksa koneksi internet.';
      });
    }
  }

  void _logout() async {
    await AuthService.logout();
    FavoriteService.instance.clear();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resep Masakan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoriteScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(error!),
                      const SizedBox(height: 8),
                      ElevatedButton(
                          onPressed: fetchRecipes,
                          child: const Text('Coba lagi')),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, i) {
                    final recipe = recipes[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailScreen(id: recipe.id),
                          ),
                        ),
                        leading: SizedBox(
                          width: 64,
                          height: 64,
                          child: Image.network(
                            recipe.image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) =>
                                const Icon(Icons.broken_image, size: 40),
                          ),
                        ),
                        title: Text(recipe.name,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                        subtitle:
                            Text('${recipe.cuisine} • * ${recipe.rating}'),
                      ),
                    );
                  },
                ),
    );
  }
}
