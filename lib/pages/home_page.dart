import 'package:flutter/material.dart';
import 'package:pks_3/components/item.dart';  // Поменяй на свой путь импорта
import 'package:pks_3/model/product.dart';  // Поменяй на свой путь импорта
import 'package:pks_3/pages/add_bearing.dart';  // Поменяй на свой путь импорта

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Bearing> bearings = List.from(initialBearings);  // Используем список подшипников

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Подшипники',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: bearings.isNotEmpty
            ? GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: bearings.length,
          itemBuilder: (BuildContext context, int index) {
            final bearing = bearings[index];
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
              child: ItemNote(bearing: bearing),  // Используем ItemNote для отображения подшипников
            );
          },
        )
            : const Center(child: Text('Нет доступных подшипников')),
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
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
