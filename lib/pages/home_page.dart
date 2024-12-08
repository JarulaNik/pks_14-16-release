import 'package:flutter/material.dart';
import 'package:pks_3/components/item.dart';
import 'package:pks_3/model/product.dart';
import 'package:pks_3/pages/add_bearing.dart';

class HomePage extends StatefulWidget {
  final Function(Bearing) onFavoriteToggle;
  final List<Bearing> favoriteBearings;
  final Function(Bearing) onAddToCart;

  const HomePage({
    super.key,
    required this.onFavoriteToggle,
    required this.favoriteBearings,
    required this.onAddToCart,
  });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Bearing> bearings = List.from(initialBearings);
  String searchQuery = '';

  void _addNewBearing(Bearing bearing) {
    setState(() {
      bearings.add(bearing);
    });
  }

  void _removeBearing(int id) {
    setState(() {
      bearings.removeWhere((bearing) => bearing.id == id);
    });
  }

  List<Bearing> get filteredBearings {
    if (searchQuery.isEmpty) {
      return bearings;
    } else {
      return bearings.where((bearing) => bearing.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: filteredBearings.isNotEmpty
            ? GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: filteredBearings.length,
          itemBuilder: (BuildContext context, int index) {
            final bearing = filteredBearings[index];
            final isFavorite = widget.favoriteBearings.contains(bearing);
            return Dismissible(
              key: Key(bearing.id.toString()),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                _removeBearing(bearing.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${bearing.title} удален")),
                );
              },
              child: ItemNote(
                bearing: bearing,
                isFavorite: isFavorite,
                onFavoriteToggle: () => widget.onFavoriteToggle(bearing),
                onAddToCart: () => widget.onAddToCart(bearing),
              ),
            );
          },
        )
            : const Center(child: Text('Нет доступных товаров')),
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
