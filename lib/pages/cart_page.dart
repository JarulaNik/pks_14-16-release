import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pks_3/model/product.dart';
import 'package:pks_3/model/order.dart';
import 'package:pks_3/api_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartPage extends StatefulWidget {
  final List<Bearing> cartItems;
  final Function(Bearing) onAddToCart;
  final Function(Bearing) onRemoveFromCart;

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
  final _apiService = ApiService();
  double get _totalCost {
    return widget.cartItems.fold(0.0, (sum, item) => sum + item.cost);
  }

  get orderId => null;

  void _handleBuy() async {
    if (widget.cartItems.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Корзина пуста!")),
      );
      return;
    }

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ошибка: пользователь не авторизован!")),
      );
      return;
    }

    final orderItems = widget.cartItems.map((bearing) => OrderItem(
      orderID: orderId,
      productId: bearing.id,
      quantity: 1,
      price: bearing.cost,
      productName: bearing.title,
    )).toList();

    final order = Order(
      userId: user.id,
      orderDate: DateTime.now(),
      totalAmount: _totalCost,
      items: [], // Инициализируем пустым списком
    );

    print(jsonEncode(order.toJson()));

    try {
      final orderResponse = await _apiService.createOrder(order);
      if (orderResponse != null && orderResponse.orderId != null) {
        final orderId = orderResponse.orderId!; // Use the ! operator to assert non-null after checking
        // ... (rest of your code to create OrderItems and update the order) ...
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error creating order: Null response or orderId")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating order: $e')),
      );
    }
  }


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
                widget.onRemoveFromCart(item);
                Navigator.of(context).pop();
              },
              child: const Text('Да'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
            fontSize: 24,
            fontWeight: FontWeight.bold,
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
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: Image.network(item.imageUrl,
                        width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(item.title),
                    subtitle:
                    Text('Цена: ₽${item.cost.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_shopping_cart),
                      onPressed: () {
                        _confirmRemoveItem(item);
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
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '₽${_totalCost.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _handleBuy,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    minimumSize: const Size(double.infinity, 48),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Купить'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension on List<Order> {
  get statusCode => null;
}