import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'calculo.dart';
import 'logica.dart';

class MontajesPage extends StatefulWidget {
  @override
  _MontajesPageState createState() => _MontajesPageState();
}

class _MontajesPageState extends State<MontajesPage> {
  final _formKey = GlobalKey<FormState>();

  final _equipoCtrl    = TextEditingController();
  final _tagCtrl       = TextEditingController();
  final _ejeCtrl       = TextEditingController();
  final _cajaPortCtrl  = TextEditingController();
  final _sellosCtrl    = TextEditingController();
  final _manguitorCtrl = TextEditingController();
  final _tipoCtrl      = TextEditingController();
  final _rodCtrl       = TextEditingController();
  final _galgeoCtrl    = TextEditingController();

  String _clase    = 'NORMAL';
  String _ubicacion = 'Lado Rodete';

  static const _clases    = ['C2', 'NORMAL', 'C3', 'C4', 'C5'];
  static const _ubicaciones = ['Lado Rodete', 'Lado Acople'];

  @override
  void dispose() {
    for (final c in [_equipoCtrl, _tagCtrl, _ejeCtrl, _cajaPortCtrl,
                     _sellosCtrl, _manguitorCtrl, _tipoCtrl, _rodCtrl, _galgeoCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  void _calcular() {
    if (!_formKey.currentState!.validate()) return;

    final int rodamiento = int.parse(_rodCtrl.text.trim());
    final double galgeo  = double.parse(_galgeoCtrl.text.trim().replaceAll(',', '.'));

    final resultado = calcularMontaje(
      rodamiento: rodamiento,
      clase: _clase,
      galgeo: galgeo,
    );

    if (resultado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontraron datos para ese rodamiento/clase. Verificá el número.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => pantallaResultado(
          equipo:    _equipoCtrl.text.trim(),
          tag:       _tagCtrl.text.trim(),
          eje:       _ejeCtrl.text.trim(),
          cajaPort:  _cajaPortCtrl.text.trim(),
          sellos:    _sellosCtrl.text.trim(),
          manguito:  _manguitorCtrl.text.trim(),
          tipo:      _tipoCtrl.text.trim(),
          rodamiento: rodamiento,
          clase:     _clase,
          ubicacion: _ubicacion,
          galgeo:    galgeo,
          resultado: resultado,
        ),
      ),
    );
  }

  Widget _campo(String label, TextEditingController ctrl, {
    TextInputType teclado = TextInputType.text,
    List<TextInputFormatter>? formatos,
    String? Function(String?)? validator,
    bool obligatorio = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: ctrl,
        keyboardType: teclado,
        inputFormatters: formatos,
        decoration: InputDecoration(
          labelText: obligatorio ? '$label *' : label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          isDense: true,
        ),
        validator: validator ?? (obligatorio
            ? (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null
            : null),
      ),
    );
  }

  Widget _seccion(String titulo) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 4),
    child: Text(titulo,
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 13)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Montajes', style: TextStyle(fontStyle: FontStyle.italic)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _seccion('DATOS DEL EQUIPO'),
            _campo('Equipo', _equipoCtrl, obligatorio: true),
            _campo('TAG', _tagCtrl),
            _campo('Eje', _ejeCtrl),
            _campo('Caja portarrodamiento', _cajaPortCtrl),
            _campo('Sellos', _sellosCtrl),
            _campo('Manguito', _manguitorCtrl),

            _seccion('DATOS DEL RODAMIENTO'),
            _campo('Tipo de rodamiento', _tipoCtrl),
            _campo('Número de rodamiento', _rodCtrl,
              teclado: TextInputType.number,
              formatos: [FilteringTextInputFormatter.digitsOnly],
              obligatorio: true,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Campo requerido';
                final n = int.tryParse(v.trim());
                if (n == null || n <= 0) return 'Ingresá un número válido';
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: DropdownButtonFormField<String>(
                value: _clase,
                decoration: InputDecoration(
                  labelText: 'Clase de juego *',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  isDense: true,
                ),
                items: _clases.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _clase = v!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: DropdownButtonFormField<String>(
                value: _ubicacion,
                decoration: InputDecoration(
                  labelText: 'Ubicación',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  isDense: true,
                ),
                items: _ubicaciones.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                onChanged: (v) => setState(() => _ubicacion = v!),
              ),
            ),

            _seccion('MEDICIÓN'),
            _campo('Galgeo antes del montaje (mm)', _galgeoCtrl,
              teclado: const TextInputType.numberWithOptions(decimal: true),
              obligatorio: true,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Campo requerido';
                final n = double.tryParse(v.trim().replaceAll(',', '.'));
                if (n == null || n <= 0) return 'Ingresá un valor numérico positivo';
                return null;
              },
            ),

            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _calcular,
              icon: const Icon(Icons.calculate),
              label: const Text('Calcular'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
