import 'package:flutter/material.dart';
import 'package:pks_3/components/item.dart';
import 'package:pks_3/model/product.dart';

class FavoritesPage extends StatelessWidget {
  final List<Bearing> favoriteBearings;
  final Function(Bearing) onFavoriteToggle;

  const FavoritesPage({
    super.key,
    required this.favoriteBearings,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        backgroundColor: Colors.green,
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: favoriteBearings.isNotEmpty
            ? GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: favoriteBearings.length,
          itemBuilder: (BuildContext context, int index) {
            final bearing = favoriteBearings[index];
            return ItemNote(
              bearing: bearing,
              isFavorite: true,
              onFavoriteToggle: () {
                onFavoriteToggle(bearing);
              },
              onAddToCart: () {},  // Пустая функция для onAddToCart
            );
          },
        )
            : const Center(child: Text('Упс! В избранном пусто')),
      ),
    );
  }
}
