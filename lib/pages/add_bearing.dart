// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:pks_3/api_service.dart'; // Импортируйте ApiService
import 'package:pks_3/model/product.dart';


class AddBearingPage extends StatefulWidget {
  const AddBearingPage({super.key});

  @override
  AddBearingPageState createState() => AddBearingPageState();
}

class AddBearingPageState extends State<AddBearingPage> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService(); // Создайте экземпляр ApiService
  String name = '';  // Изменено имя переменной
  String description = '';
  String imageUrl = '';
  double price = 0.0; // Изменено имя переменной
  int stock = 0;     // Добавлено поле stock
  String article = ''; // Добавлено поле article


  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newBearing = Bearing(
        id: 0,
        title: name,     // Используйте измененное имя переменной
        description: description,
        imageUrl: imageUrl,
        cost: price,   // Используйте измененное имя переменной
        article: article, // Добавьте значение article
      );

      try {
        final createdBearing = await _apiService.createBearing(newBearing); // Вызовите метод API
        // ignore: use_build_context_synchronously
        Navigator.pop(context, createdBearing); // Возвращаем созданный подшипник
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при создании: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить подшипник'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Название'),
                onSaved: (value) {
                  name = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Описание'),
                onSaved: (value) {
                  description = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите описание';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Ссылка на изображение'),
                onSaved: (value) {
                  imageUrl = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите URL изображения';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Цена (рублей)'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  price = value != null && value.isNotEmpty
                      ? double.tryParse(value) ?? 0.0
                      : 0.0; // Преобразуем строку в double, если не удается - присваиваем 0.0
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите цену';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Пожалуйста, введите корректную цену';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Артикул'),
                onSaved: (value) {
                  article = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите артикул';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: _saveForm,
                  child: const Text('Сохранить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
