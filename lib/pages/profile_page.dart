import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController(text: 'Ярослав Жидков');
  final TextEditingController _emailController = TextEditingController(text: 'zhidkov.y.n@edu.mirea.ru');
  final TextEditingController _phoneController = TextEditingController(text: '+7(916) 807-01-00');
  String avatarUrl = 'https://avatars.githubusercontent.com/u/119223289?v=4';
  bool _isEditing = false;  // Флаг для переключения режима редактирования

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
          // Иконка карандаша для редактирования
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;  // Переключаем режим редактирования
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
              onTap: () {
                // В будущем можно добавить логику смены аватара
              },
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(avatarUrl),
              ),
            ),
            const SizedBox(height: 20),
            // Поле для имени и фамилии
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Имя и фамилия',
                border: OutlineInputBorder(),
              ),
              enabled: _isEditing,  // Только в режиме редактирования
            ),
            const SizedBox(height: 10),
            // Поле для электронной почты
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Электронная почта',
                border: OutlineInputBorder(),
              ),
              enabled: _isEditing,  // Только в режиме редактирования
            ),
            const SizedBox(height: 10),
            // Поле для телефона
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Телефон',
                border: OutlineInputBorder(),
              ),
              enabled: _isEditing,  // Только в режиме редактирования
            ),
            const SizedBox(height: 20),

            // Кнопка для сохранения изменений, отображается только в режиме редактирования
            if (_isEditing)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  width: double.infinity,  // Кнопка будет занимать всю ширину
                  child: ElevatedButton(
                    onPressed: () {
                      // Логика сохранения данных
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Изменения успешно сохранены!")),
                      );
                      setState(() {
                        _isEditing = false;  // Выключаем режим редактирования после сохранения
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(
                        fontSize: 20,  // Увеличиваем размер шрифта до 20
                        fontWeight: FontWeight.bold,  // Жирный шрифт
                      ),
                      minimumSize: const Size(double.infinity, 48), // Занимает всю ширину экрана
                    ),
                    child: const Text(
                      'Сохранить изменения',
                      style: TextStyle(
                        color: Colors.black,  // Цвет шрифта черный
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
