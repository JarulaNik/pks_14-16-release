import 'package:flutter/material.dart';
import 'package:pks_3/model/product.dart';
import 'package:pks_3/pages/information.dart';

class ItemNote extends StatelessWidget {
  final Bearing bearing;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const ItemNote({
    super.key,
    required this.bearing,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CatalogPage(bearing: bearing)),
      ),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                  child: Container(
                    color: Colors.white,
                    height: 120,
                    width: double.infinity,
                    child: Image.network(
                      bearing.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: onFavoriteToggle,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                bearing.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Цена: ${bearing.cost}',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.green,
                side: const BorderSide(color: Colors.white12, width: 2),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CatalogPage(bearing: bearing)),
                );
              },
              child: const Text(
                'Подробнее',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}