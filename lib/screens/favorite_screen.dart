import 'package:flutter/material.dart';
import '../services/favorite_service.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fav = FavoriteService.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite')),
      // Otomatis rebuild setiap kali favourite berubah (dari halaman mana pun)
      body: ListenableBuilder(
        listenable: fav,
        builder: (context, _) {
          final items = fav.items;
          if (items.isEmpty) {
            return const Center(child: Text('Belum ada favorite'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) {
              final recipe = items[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(id: recipe.id),
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
                  subtitle: Text('${recipe.cuisine} • ${recipe.difficulty}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => fav.toggle(recipe),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
