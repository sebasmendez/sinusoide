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
  final _tipoCtrl           = TextEditingController();
  final _rodCtrl            = TextEditingController();
  final _diametroAcopleCtrl = TextEditingController();
  final _diametroRodeteCtrl = TextEditingController();
  final _galgeoAcopleCtrl   = TextEditingController();
  final _galgeoRodeteCtrl   = TextEditingController();

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
      _diametroAcopleCtrl, _diametroRodeteCtrl,
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
    final int diametroAcople = int.parse(_diametroAcopleCtrl.text.trim());
    final int diametroRodete = int.parse(_diametroRodeteCtrl.text.trim());
    final double galgeoAcople = _parseNum(_galgeoAcopleCtrl.text)!;
    final double galgeoRodete = _parseNum(_galgeoRodeteCtrl.text)!;

    final resAcople = calcularMontaje(
      diametro: diametroAcople,
      clase: _clase,
      galgeo: galgeoAcople,
    );

    final resRodete = calcularMontaje(
      diametro: diametroRodete,
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
            Card(
              elevation: 1,
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _campo('Equipo', _equipoCtrl, obligatorio: true),
                    _campo('TAG', _tagCtrl),
                    _campo('Eje', _ejeCtrl),
                  ],
                ),
              ),
            ),

            _seccion('CAJAS PORTARRODAMIENTO'),
            Card(
              elevation: 1,
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
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
                  ],
                ),
              ),
            ),

            _seccion('DATOS DEL RODAMIENTO Y MEDICIONES'),
            Card(
              elevation: 3,
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.blue, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Clase de juego *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey)),
                          const SizedBox(height: 8),
                          SegmentedButton<String>(
                            segments: _clases.map((c) => ButtonSegment(label: Text(c), value: c)).toList(),
                            selected: {_clase},
                            onSelectionChanged: (v) => setState(() => _clase = v.first),
                            style: ButtonStyle(
                              padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _campo('Diámetro Acople (mm)', _diametroAcopleCtrl,
                            teclado: TextInputType.number,
                            formatos: [FilteringTextInputFormatter.digitsOnly],
                            obligatorio: true,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Campo requerido';
                              if (int.tryParse(v.trim()) == null) return 'Número inválido';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _campo('Diámetro Rodete (mm)', _diametroRodeteCtrl,
                            teclado: TextInputType.number,
                            formatos: [FilteringTextInputFormatter.digitsOnly],
                            obligatorio: true,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Campo requerido';
                              if (int.tryParse(v.trim()) == null) return 'Número inválido';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    _campoGalgeo('Galgeo Lado Acople (mm)', _galgeoAcopleCtrl),
                    _campoGalgeo('Galgeo Lado Rodete (mm)', _galgeoRodeteCtrl),
                  ],
                ),
              ),
            ),

            _seccion('DATOS OPCIONALES DEL EQUIPO'),
            Card(
              elevation: 1,
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _campo('Sellos', _sellosCtrl),
                    _campo('Manguito', _manguitoCtrl),
                    _campo('Tipo de rodamiento', _tipoCtrl),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _calcular,
                icon: const Icon(Icons.calculate),
                label: const Text('Calcular'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
