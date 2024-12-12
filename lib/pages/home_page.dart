import 'package:flutter/material.dart';
import 'package:pks_3/components/item.dart';
import 'package:pks_3/model/product.dart';
import 'package:pks_3/pages/add_bearing.dart';
import 'package:pks_3/pages/chat_page.dart';
import '../api_service.dart';

class HomePage extends StatefulWidget {
  final Function(Bearing) onFavoriteToggle;
  final List<Bearing> favoriteBearings;
  final Function(Bearing) onAddToCart;
  final ApiService apiService; // Добавлено поле apiService

  const HomePage({
    super.key,
    required this.onFavoriteToggle,
    required this.favoriteBearings,
    required this.onAddToCart,
    required this.apiService, // apiService теперь обязательный параметр
  });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Bearing> bearings = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadBearings();
  }

  Future<void> _loadBearings() async {
    try {
      final loadedBearings = await widget.apiService.getBearings();
      setState(() {
        bearings = loadedBearings;
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при загрузке: $e')),
        );
      }
    }
  }

  void _removeBearing(int id) async {
    try {
      await widget.apiService.deleteBearing(id);
      _loadBearings(); // Обновляем список после удаления
    } catch (e) {
      // ignore: use_build_context_synchronously
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при удалении: $e')),
        );
      }
    }
  }

  void _addNewBearing(Bearing bearing) {
    _loadBearings(); // Просто обновляем список, сервер уже обновил данные
  }

  List<Bearing> get filteredBearings {
    if (searchQuery.isEmpty) {
      return bearings;
    } else {
      return bearings
          .where((bearing) =>
          bearing.title.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(15.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Поиск...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Colors.green),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chat, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChatPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadBearings,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<Bearing>>(
              future: widget.apiService.getBearings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Подшипников нет'));
                } else {
                  final bearings = snapshot.data!;
                  return GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: filteredBearings.length,
                    itemBuilder: (BuildContext context, int index) {
                      final bearing = filteredBearings[index];
                      final isFavorite =
                      widget.favoriteBearings.contains(bearing);
                      return Dismissible(
                        key: Key(bearing.id.toString()),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child:
                          const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Подтверждение"),
                                content: const Text(
                                    "Вы уверены, что хотите удалить этот элемент?"),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text("Удалить")),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("Отмена"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          _removeBearing(bearing.id);
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${bearing.title} удален")),
                          );
                        },
                        child: ItemNote(
                          bearing: bearing,
                          isFavorite: isFavorite,
                          onFavoriteToggle: () =>
                              widget.onFavoriteToggle(bearing),
                          onAddToCart: () => widget.onAddToCart(bearing),
                        ),
                      );
                    },
                  );
                }
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newBearing = await Navigator.push<Bearing>(
            context,
            MaterialPageRoute(builder: (context) => const AddBearingPage()),
          );
          if (newBearing != null) {
            _addNewBearing(newBearing);
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}