import 'package:flutter/material.dart';
import 'package:pks_3/pages/home_page.dart';
import 'package:pks_3/pages/favorites_page.dart';
import 'package:pks_3/pages/profile_page.dart';
import 'package:pks_3/pages/cart_page.dart';
import 'package:pks_3/model/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(
      url: "https://viyqngwksgofhktecedm.supabase.co",
      anonKey:
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZpeXFuZ3drc2dvZmhrdGVjZWRtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIxMTQwNzEsImV4cCI6MjA0NzY5MDA3MX0.Fd-T1wNtWOakctyrmXo8cLeHRSzDRhkeWgfqwT6mLdo");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Подшипники FAG',
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
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Bearing> _favoriteBearings = []; // Избранные подшипники (ID)
  final List<Bearing> _cartItems = []; // Товары в корзине (ID)
  final _apiService = ApiService(); // Экземпляр ApiService


  void _toggleFavorite(Bearing bearing) {
    setState(() {
      if (_favoriteBearings.contains(bearing)) {
        _favoriteBearings.remove(bearing);
      } else {
        _favoriteBearings.add(bearing);
      }
    });
  }


  void _toggleCart(Bearing bearing) {
    setState(() {
      if (_cartItems.contains(bearing)) {
        _cartItems.remove(bearing);
      } else {
        _cartItems.add(bearing);
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
    List<Widget> pages = [
      HomePage(
        onFavoriteToggle: _toggleFavorite,
        favoriteBearings: _favoriteBearings,
        onAddToCart: _toggleCart,
        apiService: _apiService, // Передаем ApiService в HomePage
      ),
      FavoritesPage(
        favoriteBearings: _favoriteBearings,
        onFavoriteToggle: _toggleFavorite,
      ),
      ProfilePage(apiService: _apiService), // Передаем ApiService в ProfilePage
      CartPage(
        cartItems: _cartItems,
        onAddToCart: _toggleCart,
        onRemoveFromCart: _toggleCart,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('Подшипники FAG',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
        backgroundColor: Colors.green,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Корзина',
          ),
        ],
      ),
    );
  }
}