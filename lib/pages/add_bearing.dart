// ignore_for_file: avoid_print

import 'package:flutter/material.dart';



class AddBearingPage extends StatefulWidget {
  const AddBearingPage({super.key});

  @override
  AddBearingPageState createState() => AddBearingPageState();
}

class AddBearingPageState extends State<AddBearingPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String imageUrl = '';
  double cost = 0.0;  // Убедитесь, что это double
  String article = '';

  // Этот метод вызывается при сохранении формы
  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();  // Сохранение значений из полей

      // Преобразование строки в double уже выполнено в onSaved
      print('Title: $title');
      print('Description: $description');
      print('Image URL: $imageUrl');
      print('Cost: $cost');
      print('Article: $article');
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
                  title = value!;
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
                  cost = value != null && value.isNotEmpty
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
