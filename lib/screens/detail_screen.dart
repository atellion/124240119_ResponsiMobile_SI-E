import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/recipe.dart';
import '../services/favorite_service.dart';

class DetailScreen extends StatefulWidget {
  final int id;
  const DetailScreen({super.key, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Recipe? recipe;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    try {
      final data = await getRecipeDetail(widget.id); // by id
      setState(() {
        recipe = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Gagal memuat detail.';
      });
    }
  }

  Future<void> _toggleFav() async {
    final nowFav = await FavoriteService.instance.toggle(recipe!);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              nowFav ? 'Ditambahkan ke favorite' : 'Dihapus dari favorite')),
    );
  }

  Widget _info(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Resep'),
        actions: [
          if (recipe != null)
            // Ikon hati ikut berubah kalau favourite diubah dari mana pun
            ListenableBuilder(
              listenable: FavoriteService.instance,
              builder: (context, _) {
                final isFav = FavoriteService.instance.isFavorite(recipe!.id);
                return IconButton(
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.white),
                  onPressed: _toggleFav,
                );
              },
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        recipe!.image,
                        width: double.infinity,
                        height: 240,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Container(
                          height: 240,
                          color: Colors.grey.shade300,
                          child: const Center(
                              child: Icon(Icons.broken_image, size: 64)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(recipe!.name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                                '${recipe!.cuisine} • ${recipe!.mealType.join(', ')}',
                                style: TextStyle(color: Colors.grey.shade700)),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              children: [
                                _info(Icons.star,
                                    '${recipe!.rating} (${recipe!.reviewCount})'),
                                _info(Icons.speed, recipe!.difficulty),
                                _info(Icons.timer,
                                    'Persiapan ${recipe!.prepTimeMinutes} mnt'),
                                _info(Icons.local_fire_department,
                                    'Masak ${recipe!.cookTimeMinutes} mnt'),
                                _info(Icons.people,
                                    '${recipe!.servings} porsi'),
                                _info(Icons.bolt,
                                    '${recipe!.caloriesPerServing} kal/porsi'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text('Bahan-bahan',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            for (final bahan in recipe!.ingredients)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text('• $bahan',
                                    style: const TextStyle(fontSize: 16)),
                              ),
                            const SizedBox(height: 16),
                            const Text('Langkah Memasak',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            for (int i = 0; i < recipe!.instructions.length; i++)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      child: Text('${i + 1}',
                                          style:
                                              const TextStyle(fontSize: 12)),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(recipe!.instructions[i],
                                          style:
                                              const TextStyle(fontSize: 16)),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
