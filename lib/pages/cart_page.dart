import 'package:flutter/material.dart';
import 'package:pks_3/model/product.dart'; // Импортируем модель товаров

class CartPage extends StatefulWidget {
  final List<Bearing> cartItems; // Список товаров в корзине
  final Function(Bearing) onAddToCart; // Функция добавления товара в корзину
  final Function(Bearing) onRemoveFromCart; // Функция удаления товара из корзины

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onAddToCart,
    required this.onRemoveFromCart,
  });

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  double get _totalCost {
    return widget.cartItems.fold(0.0, (sum, item) => sum + item.cost);
  }

  void _handleBuy() {
    if (widget.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Корзина пуста!")),
      );
      return;
    }

    // Показать сообщение об успешной покупке
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Покупка успешно завершена!")),
    );

    // Очистить корзину после покупки
    setState(() {
      widget.cartItems.clear();
    });
  }

  // Функция для отображения диалога с подтверждением удаления
  void _confirmRemoveItem(Bearing item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтвердите удаление'),
          content: Text('Вы уверены, что хотите удалить товар "${item.title}" из корзины?'),
          actions: [
            TextButton(
              onPressed: () {
                widget.onRemoveFromCart(item);  // Удалить товар из корзины
                Navigator.of(context).pop();  // Закрыть диалог
              },
              child: const Text('Да'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Закрыть диалог без удаления
              },
              child: const Text('Нет'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Корзина',
          style: TextStyle(
            fontSize: 24,      // Размер шрифта 24
            fontWeight: FontWeight.bold,  // Жирный шрифт
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text('Корзина пуста'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(item.title),
                    subtitle: Text('Цена: ₽${item.cost.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_shopping_cart),
                      onPressed: () {
                        _confirmRemoveItem(item);  // Вызываем диалог для подтверждения удаления
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Итого:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '₽${_totalCost.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _handleBuy,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),  // Увеличиваем горизонтальные отступы
                    textStyle: const TextStyle(
                      fontSize: 20,  // Уменьшаем размер шрифта, чтобы текст влез
                      fontWeight: FontWeight.bold,  // Жирный шрифт для кнопки
                    ),
                    minimumSize: const Size(double.infinity, 48),
                    foregroundColor: Colors.black,// Задаем минимальный размер кнопки для большей гибкости
                  ),
                  child: const Text('Купить'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
