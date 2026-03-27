import 'dart:async';
import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';

class VibracionPage extends StatefulWidget {
  const VibracionPage({super.key});

  @override
  State<VibracionPage> createState() => _VibracionPageState();
}

class _VibracionPageState extends State<VibracionPage> {
  StreamSubscription<NoiseReading>? _sub;
  final NoiseMeter _noiseMeter = NoiseMeter();

  bool _midiendo = false;
  double _dbActual = -60.0;
  double _dbPico = -60.0;
  double _dbMin = 0.0;
  double _dbMax = -60.0;
  final List<double> _valores = [];

  double get _dbPromedio {
    if (_valores.isEmpty) return -60.0;
    return _valores.reduce((a, b) => a + b) / _valores.length;
  }

  // Normaliza dB a 0.0–1.0 para la barra (escala -60 a 0 dBFS)
  double _normalizar(double db) => ((db + 60) / 60).clamp(0.0, 1.0);

  Color _colorBarra(double fraccion) {
    if (fraccion < 0.7) return Colors.green.shade600;
    if (fraccion < 0.9) return Colors.amber.shade600;
    return Colors.red.shade600;
  }

  Future<void> _iniciar() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Permiso requerido'),
            content: const Text(
              'La app necesita acceso al micrófono para capturar la señal del sensor.\n\n'
              'Habilitá el permiso en Configuración del sistema.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
                child: const Text('Abrir configuración'),
              ),
            ],
          ),
        );
      }
      return;
    }

    setState(() {
      _midiendo = true;
      _dbActual = -60.0;
      _dbPico = -60.0;
      _dbMin = 0.0;
      _dbMax = -60.0;
      _valores.clear();
    });

    _sub = _noiseMeter.noise.listen(
      (reading) {
        final db = reading.meanDecibel.isFinite ? reading.meanDecibel : -60.0;
        setState(() {
          _dbActual = db;
          if (_valores.isEmpty || db < _dbMin) _dbMin = db;
          if (db > _dbMax) _dbMax = db;
          if (db > _dbPico) _dbPico = db;
          _valores.add(db);
          if (_valores.length > 500) _valores.removeAt(0);
        });
      },
      onError: (_) => _detener(),
    );
  }

  void _detener() {
    _sub?.cancel();
    _sub = null;
    setState(() => _midiendo = false);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Widget _vuMeter() {
    final fraccion = _normalizar(_dbActual);

    return Column(
      children: [
        // Barra VU horizontal
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              // Barra de relleno
              FractionallySizedBox(
                widthFactor: fraccion,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 80),
                  decoration: BoxDecoration(
                    color: _colorBarra(fraccion),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              // Marcas de umbral
              _marcaUmbral(0.7, Colors.amber.shade300),  // -18 dBFS
              _marcaUmbral(0.9, Colors.red.shade300),    // -6 dBFS
            ],
          ),
        ),

        const SizedBox(height: 6),

        // Escala numérica
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('-60', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text('-48', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text('-36', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text('-24', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text('-18', style: TextStyle(fontSize: 10, color: Colors.amber)),
            Text('-12', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text('-6', style: TextStyle(fontSize: 10, color: Colors.red)),
            Text('0', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),

        const SizedBox(height: 4),
        Text(
          'dBFS',
          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _marcaUmbral(double posicion, Color color) {
    return LayoutBuilder(
      builder: (context, constraints) => Positioned(
        left: constraints.maxWidth * posicion - 1,
        top: 0,
        bottom: 0,
        child: Container(width: 2, color: color.withValues(alpha:0.6)),
      ),
    );
  }

  Widget _valorDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _dbActual.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: _colorBarra(_normalizar(_dbActual)),
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            ' dBFS',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _estadisticas() {
    return Row(
      children: [
        _statCard('MÍNIMO', _valores.isEmpty ? '-' : '${_dbMin.toStringAsFixed(1)} dB'),
        const SizedBox(width: 8),
        _statCard('PROMEDIO', _valores.isEmpty ? '-' : '${_dbPromedio.toStringAsFixed(1)} dB'),
        const SizedBox(width: 8),
        _statCard('PICO', _dbPico <= -60 ? '-' : '${_dbPico.toStringAsFixed(1)} dB',
            color: Colors.red.shade700),
      ],
    );
  }

  Widget _statCard(String label, String valor, {Color? color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(label,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(valor,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color ?? Colors.white)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: const Text('Medición de Vibraciones', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Instrucciones
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade900.withValues(alpha:0.4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade700, width: 1),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Conectá el sensor al jack de audio (o vía USB/Bluetooth) antes de iniciar.',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Valor numérico grande
            Center(child: _valorDisplay()),

            const SizedBox(height: 8),

            // Pico
            Center(
              child: Text(
                'Pico: ${_dbPico <= -60 ? "---" : "${_dbPico.toStringAsFixed(1)} dBFS"}',
                style: TextStyle(fontSize: 13, color: Colors.red.shade400),
              ),
            ),

            const SizedBox(height: 24),

            // Barra VU
            _vuMeter(),

            const SizedBox(height: 28),

            // Estadísticas
            _estadisticas(),

            const Spacer(),

            // Botón iniciar/detener
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _midiendo ? _detener : _iniciar,
                icon: Icon(_midiendo ? Icons.stop : Icons.play_arrow),
                label: Text(_midiendo ? 'Detener' : 'Iniciar medición'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _midiendo ? Colors.red.shade700 : Colors.green.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Estado
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _midiendo ? Colors.green : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _midiendo ? 'Capturando señal...' : 'Detenido',
                    style: TextStyle(
                      fontSize: 12,
                      color: _midiendo ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
