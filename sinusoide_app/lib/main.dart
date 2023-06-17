import 'package:flutter/material.dart';
import 'montajes.dart';
import 'historial.dart';

void main() {
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
          scaffoldBackgroundColor: const Color.fromARGB(255, 191, 207, 228)),
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
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 48, 80, 184).withOpacity(0.7),
              blurRadius: 10,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Image.asset(
          'imagenes/SINUSOIDE-1024.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
