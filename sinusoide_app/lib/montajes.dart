import 'package:flutter/material.dart';

import 'calculo.dart';

class MontajesPage extends StatefulWidget {
  @override
  _MontajesPageState createState() => _MontajesPageState();
}

class _MontajesPageState extends State<MontajesPage> {
  final List<String> preguntas = [
    'EQUIPO',
    'CAJA PORT',
    'SELLOS',
    'MANGUITO',
    'TIPO',
    'RODAMIENTO',
  ];

  List<String> respuestas = [];

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> controllers = List.generate(
      preguntas.length,
      (index) => TextEditingController(),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          'Montajes',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 0; i < preguntas.length; i++)
                Column(
                  children: [
                    const SizedBox(height: 7),
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: controllers[i],
                        decoration: InputDecoration(
                          labelText: preguntas[i],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Lógica para procesar los datos del formulario
                  setState(() {
                    respuestas = controllers
                        .map((controller) => controller.text)
                        .toList();
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => pantallaResultado(
                          respuestas: respuestas), // Editar esta línea
                    ),
                  );
                },
                child: const Text('Calcular'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

