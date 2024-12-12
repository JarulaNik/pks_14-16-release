import 'package:flutter/material.dart';
import 'package:pks_3/api_service.dart';
import 'package:pks_3/auth/auth_service.dart';
import 'package:pks_3/model/order.dart';
import 'package:pks_3/pages/login_page.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  final ApiService apiService; // Добавляем ApiService как параметр

  const ProfilePage({super.key, required this.apiService});

  @override
  ProfilePageState createState() => ProfilePageState();
}


class ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController(text: 'Ярослав Жидков');
  final TextEditingController _emailController = TextEditingController(text: 'zhidkov.y.n@edu.mirea.ru');
  final TextEditingController _phoneController = TextEditingController(text: '+7(916) 807-01-00');
  String userId = Supabase.instance.client.auth.currentUser!.id;
  String avatarUrl = 'https://avatars.githubusercontent.com/u/119223289?v=4';
  bool _isEditing = false;
  final AuthService _authService = AuthService();

  List<Order> _orders = [];


  @override
  void initState() {
    super.initState();
    _loadOrders();
  }



  Future<void> _loadOrders() async {
    try {
      final orders = await widget.apiService.getOrders(userId);
      setState(() {
        _orders = orders;
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при загрузке заказов: $e')),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Профиль',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(avatarUrl),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Имя и фамилия',
                border: OutlineInputBorder(),
              ),
              enabled: _isEditing,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Электронная почта',
                border: OutlineInputBorder(),
              ),
              enabled: _isEditing,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Телефон',
                border: OutlineInputBorder(),
              ),
              enabled: _isEditing,
            ),

            const SizedBox(height: 20),
            if (_isEditing)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // сохранение изменений профиля
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Изменения успешно сохранены!")),
                      );
                      setState(() {
                        _isEditing = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(
                      'Сохранить изменения',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ElevatedButton( // Кнопка для загрузки заказов
              onPressed: _loadOrders,
              child: const Text('История заказов'),
            ),
            Expanded(
              child: _orders.isEmpty
                  ? const Center(child: Text('Заказов нет'))
                  : ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  final formattedDate =
                  DateFormat('dd.MM.yyyy HH:mm').format(order.orderDate);
                  return Card(
                    child: ListTile(
                      title: Text('Заказ №${order.orderId}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Дата: $formattedDate'),
                          Text(
                              'Сумма: ${order.totalAmount.toStringAsFixed(2)} руб.'),
                          ...order.items.map((item) => Text(
                            '${item.productName} x ${item.quantity}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),


          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ElevatedButton(
              onPressed: () async {
                await _authService.sighOut();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.black,
              ),
              child: const Text("Выход"),
            ),
          ),
        ),
      ),
    );
  }
}