import 'package:flutter/material.dart';

class HistorialPage extends StatelessWidget {
  final List<String> ultimosCalculos = [
    'Cálculo 1',
    'Cálculo 2',
    'Cálculo 3',
    'Cálculo 4',
    'Cálculo 5',
    'Cálculo 6',
    'Cálculo 7',
    'Cálculo 8',
    'Cálculo 9',
    'Cálculo 10',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial'),
      ),
      body: ListView.builder(
        itemCount: ultimosCalculos.length,
        itemBuilder: (context, index) {
          final calculo = ultimosCalculos[index];
          return ListTile(
            title: Text(calculo),
            leading: Icon(Icons.history),
          );
        },
      ),
    );
  }
}
