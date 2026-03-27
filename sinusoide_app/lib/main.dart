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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _nuevoCalculo() {
    _onItemTapped(1);
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return HomePage(onNuevoCalculo: _nuevoCalculo);
      case 1:
        return MontajesPage();
      case 2:
        return const HistorialPage();
      default:
        return HomePage(onNuevoCalculo: _nuevoCalculo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SinusoideApp'),
      ),
      body: _buildPage(_selectedIndex),
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
  final VoidCallback onNuevoCalculo;

  const HomePage({Key? key, required this.onNuevoCalculo});

  static const double _logoRadius = 20;
  static const Color _shadowColor = Color.fromARGB(102, 48, 80, 184);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_logoRadius),
                boxShadow: const [
                  BoxShadow(
                    color: _shadowColor,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_logoRadius),
                child: Image.asset(
                  'imagenes/SINUSOIDE-1024.png',
                  width: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'MONTAJE DE\nRODAMIENTOS',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 55, 71, 79),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onNuevoCalculo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                ),
                child: const Text(
                  'NUEVO CÁLCULO',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
