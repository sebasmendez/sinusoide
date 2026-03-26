import 'package:flutter/material.dart';
import 'db_helper.dart';

class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  List<Map<String, dynamic>> _historial = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final data = await DbHelper.obtenerHistorial();
    setState(() => _historial = data);
  }

  Future<void> _eliminar(int id) async {
    await DbHelper.eliminarCalculo(id);
    await _cargar();
  }

  String _fmt(dynamic v) {
    if (v == null) return '-';
    if (v is double) return v.toStringAsFixed(3);
    return v.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Historial'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _cargar),
        ],
      ),
      body: _historial.isEmpty
          ? const Center(child: Text('No hay cálculos guardados'))
          : ListView.builder(
              itemCount: _historial.length,
              itemBuilder: (context, index) {
                final item = _historial[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ExpansionTile(
                    leading: const Icon(Icons.history, color: Colors.blueGrey),
                    title: Text(
                      item['equipo']?.toString().isNotEmpty == true
                          ? item['equipo']
                          : 'Sin equipo',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Rod. ${item['rodamiento'] ?? '-'}  ${item['clase'] ?? ''}  —  ${item['fecha'] ?? ''}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _eliminar(item['id']),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            _linea('Diámetro de eje', '${item['diametro'] ?? '-'} mm'),
                            _linea('Galgeo antes montaje', '${_fmt(item['galgeo'])} mm'),
                            const SizedBox(height: 6),
                            _linea('Ref. sin montar',
                              'MIN ${_fmt(item['ref_min'])} / MAX ${_fmt(item['ref_max'])} mm'),
                            _linea('Reducción de juego',
                              'MIN ${_fmt(item['reduc_min'])} / MAX ${_fmt(item['reduc_max'])} mm'),
                            _linea('Juego residual',
                              'MIN ${_fmt(item['juego_min'])} / MAX ${_fmt(item['juego_max'])} mm'),
                            if (item['ajuste_final'] != null)
                              _linea('Ajuste final', '${_fmt(item['ajuste_final'])} mm',
                                bold: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _linea(String label, String valor, {bool bold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        SizedBox(
          width: 160,
          child: Text(label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: Colors.blueGrey,
            ),
          ),
        ),
        Expanded(
          child: Text(valor,
            style: TextStyle(
              fontSize: 12,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    ),
  );
}
