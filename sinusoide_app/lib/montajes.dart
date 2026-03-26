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

  final _equipoCtrl       = TextEditingController();
  final _tagCtrl          = TextEditingController();
  final _ejeCtrl          = TextEditingController();
  final _cajaPortLACtrl   = TextEditingController();
  final _torqueLACtrl     = TextEditingController();
  final _cajaPortLRCtrl   = TextEditingController();
  final _torqueLRCtrl     = TextEditingController();
  final _paralelismoCtrl  = TextEditingController();
  final _sellosCtrl       = TextEditingController();
  final _manguitoCtrl     = TextEditingController();
  final _tipoCtrl         = TextEditingController();
  final _rodCtrl          = TextEditingController();
  final _galgeoAcopleCtrl = TextEditingController();
  final _galgeoRodeteCtrl = TextEditingController();

  String _clase = 'NORMAL';

  static const _clases = ['C2', 'NORMAL', 'C3', 'C4', 'C5'];

  @override
  void dispose() {
    for (final c in [
      _equipoCtrl, _tagCtrl, _ejeCtrl,
      _cajaPortLACtrl, _torqueLACtrl,
      _cajaPortLRCtrl, _torqueLRCtrl,
      _paralelismoCtrl, _sellosCtrl, _manguitoCtrl,
      _tipoCtrl, _rodCtrl,
      _galgeoAcopleCtrl, _galgeoRodeteCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double? _parseNum(String text) {
    return double.tryParse(text.trim().replaceAll(',', '.'));
  }

  void _calcular() {
    if (!_formKey.currentState!.validate()) return;

    final int rodamiento = int.parse(_rodCtrl.text.trim());
    final double galgeoAcople = _parseNum(_galgeoAcopleCtrl.text)!;
    final double galgeoRodete = _parseNum(_galgeoRodeteCtrl.text)!;

    final resAcople = calcularMontaje(
      rodamiento: rodamiento,
      clase: _clase,
      galgeo: galgeoAcople,
    );

    final resRodete = calcularMontaje(
      rodamiento: rodamiento,
      clase: _clase,
      galgeo: galgeoRodete,
    );

    if (resAcople == null || resRodete == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontraron datos para ese rodamiento/clase. Verifica el numero.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => pantallaResultado(
          equipo:       _equipoCtrl.text.trim(),
          tag:          _tagCtrl.text.trim(),
          eje:          _ejeCtrl.text.trim(),
          cajaPortLA:   _cajaPortLACtrl.text.trim(),
          torqueLA:     _torqueLACtrl.text.trim(),
          cajaPortLR:   _cajaPortLRCtrl.text.trim(),
          torqueLR:     _torqueLRCtrl.text.trim(),
          paralelismo:  _paralelismoCtrl.text.trim(),
          sellos:       _sellosCtrl.text.trim(),
          manguito:     _manguitoCtrl.text.trim(),
          tipo:         _tipoCtrl.text.trim(),
          rodamiento:   rodamiento,
          clase:        _clase,
          galgeoAcople: galgeoAcople,
          galgeoRodete: galgeoRodete,
          resAcople:    resAcople,
          resRodete:    resRodete,
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

  Widget _campoGalgeo(String label, TextEditingController ctrl) {
    return _campo(
      label, ctrl,
      teclado: const TextInputType.numberWithOptions(decimal: true),
      obligatorio: true,
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Campo requerido';
        if (_parseNum(v) == null) return 'Ingresa un valor numerico';
        return null;
      },
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

            _seccion('CAJAS PORTARRODAMIENTO'),
            Row(
              children: [
                Expanded(child: _campo('Caja Port LA (Lado Acople)', _cajaPortLACtrl)),
                const SizedBox(width: 8),
                SizedBox(width: 100, child: _campo('Torque', _torqueLACtrl)),
              ],
            ),
            Row(
              children: [
                Expanded(child: _campo('Caja Port LR (Lado Rodete)', _cajaPortLRCtrl)),
                const SizedBox(width: 8),
                SizedBox(width: 100, child: _campo('Torque', _torqueLRCtrl)),
              ],
            ),
            _campo('Paralelismo entre cajas port', _paralelismoCtrl),

            _seccion('DATOS DEL RODAMIENTO'),
            _campo('Sellos', _sellosCtrl),
            _campo('Manguito', _manguitoCtrl),
            _campo('Tipo de rodamiento', _tipoCtrl),
            _campo('Numero de rodamiento', _rodCtrl,
              teclado: TextInputType.number,
              formatos: [FilteringTextInputFormatter.digitsOnly],
              obligatorio: true,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Campo requerido';
                final n = int.tryParse(v.trim());
                if (n == null || n <= 0) return 'Ingresa un numero valido';
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

            _seccion('MEDICIONES (GALGEO ANTES DEL MONTAJE)'),
            _campoGalgeo('Galgeo Lado Acople (mm)', _galgeoAcopleCtrl),
            _campoGalgeo('Galgeo Lado Rodete (mm)', _galgeoRodeteCtrl),

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
