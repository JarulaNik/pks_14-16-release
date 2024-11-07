import 'package:flutter/material.dart';
import '../model/product.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key, required this.bearing});

  final Bearing bearing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          bearing.title,
          style: const TextStyle(fontSize: 22),
        ),
        backgroundColor: Color(0xFF08954C), // Цвет AppBar
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(
                  bearing.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                bearing.description,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87, // Основной текст чёрный
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Цена: ${bearing.cost}',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000), // Зелёный цвет для заголовков
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Артикул: ${bearing.article}',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF000000), // Зелёный цвет для акцентов
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Информация о товаре:',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF08954C), // Зелёный цвет для заголовков
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '• Тип товара: Радиальный подшипник\n'
                    '• Радиальный зазор: 200мк\n'
                    '• Тип стали: ШХ15\n'
                    '• Индустрия: тяжёлая промышленность',
                style: TextStyle(fontSize: 16.0, color: Colors.black54), // Основной текст чёрный
              ),
            ),
          ],
        ),
      ),
    );
  }
}
