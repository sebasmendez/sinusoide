import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'montajes.dart';
import 'historial.dart';

void main() {
  // Inicializar databaseFactoryFfi antes de usar la base de datos
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  
  runApp(const SinosoideApp());
}

class SinosoideApp extends StatelessWidget {
  const SinosoideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SinusoideApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NavBar(),
    );
  }
}

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    MontajesPage(),
    HistorialPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SinusoideApp'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.adjust_sharp),
            label: 'Montajes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Home Page',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
