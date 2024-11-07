import 'package:flutter/material.dart';
import 'package:pks_3/pages/home_page.dart';
import 'package:pks_3/pages/favorites_page.dart';
import 'package:pks_3/pages/profile_page.dart';
import 'package:pks_3/model/product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<Bearing> _favoriteBearings = [];

  void _toggleFavorite(Bearing bearing) {
    setState(() {
      if (_favoriteBearings.contains(bearing)) {
        _favoriteBearings.remove(bearing);
      } else {
        _favoriteBearings.add(bearing);
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      HomePage(
        onFavoriteToggle: _toggleFavorite,
        favoriteBearings: _favoriteBearings,
      ),
      FavoritesPage(
        favoriteBearings: _favoriteBearings,
        onFavoriteToggle: _toggleFavorite,
      ),
      const ProfilePage(),
    ];
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}