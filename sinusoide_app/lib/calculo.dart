
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class pantallaResultado extends StatelessWidget {
  final List<String> respuestas;

  const pantallaResultado({super.key, required this.respuestas});

  @override
  Widget build(BuildContext context) {
    var var1 = 3.14;
    var var2 = 1234;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Galgeo antes del montaje: ',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text('L Rodetee: $var1'),
                Text('L acople: $var2'),
              ]),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'referencia sin Montar: ',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text('L Rodete: $var1'),
                Text('L acople: $var2'),
              ]),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Reduccion de Juego Radial: ',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text('L Rodete: $var1'),
                Text('L acople: $var2'),
              ]),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'calculo del Juego: ',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text('L Rodete: $var1'),
                Text('L acople: $var2'),
              ]),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Auste Final: ',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text('L Rodete: $var1'),
                Text('L acople: $var2'),
              ]),

              const SizedBox(
                height: 96,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Navegar a la página anterior
                    },
                    child: const Text('Volver'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para exportar los resultados
                      // Aquí puedes agregar tu código para exportar los resultados
                    },
                    child: const Text('Exportar'),
                  ),
                ],
              ),
              // Fin de los cambios
            ],
          ),
        ),
      ),
    );
  }
}