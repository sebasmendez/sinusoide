// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'db_helper.dart';
import 'logica.dart';

class pantallaResultado extends StatefulWidget {
  final String equipo, tag, eje, cajaPort, sellos, manguito, tipo, clase, ubicacion;
  final int rodamiento;
  final double galgeo;
  final ResultadoMontaje resultado;

  const pantallaResultado({
    super.key,
    required this.equipo,
    required this.tag,
    required this.eje,
    required this.cajaPort,
    required this.sellos,
    required this.manguito,
    required this.tipo,
    required this.rodamiento,
    required this.clase,
    required this.ubicacion,
    required this.galgeo,
    required this.resultado,
  });

  @override
  State<pantallaResultado> createState() => _pantallaResultadoState();
}

class _pantallaResultadoState extends State<pantallaResultado> {
  final _ajusteCtrl = TextEditingController();
  bool _guardado = false;
  int? _registroId;

  String _fmt(double v) => v.toStringAsFixed(3);

  @override
  void initState() {
    super.initState();
    _guardar();
  }

  @override
  void dispose() {
    _ajusteCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final r = widget.resultado;
    final fecha = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    final id = await DbHelper.guardarCalculo({
      'fecha':             fecha,
      'equipo':            widget.equipo,
      'tag':               widget.tag,
      'eje':               widget.eje,
      'caja_port':         widget.cajaPort,
      'sellos':            widget.sellos,
      'manguito':          widget.manguito,
      'tipo':              widget.tipo,
      'rodamiento':        widget.rodamiento,
      'clase':             widget.clase,
      'ubicacion':         widget.ubicacion,
      'galgeo':            widget.galgeo,
      'diametro':          r.diametro,
      'ref_min':           r.refSinMontarMin,
      'ref_max':           r.refSinMontarMax,
      'reduc_min':         r.reduccionMin,
      'reduc_max':         r.reduccionMax,
      'juego_min':         r.juegoMin,
      'juego_max':         r.juegoMax,
      'ajuste_final':      null,
    });
    if (mounted) setState(() { _guardado = true; _registroId = id; });
  }

  Future<void> _guardarAjusteFinal() async {
    final v = double.tryParse(_ajusteCtrl.text.trim().replaceAll(',', '.'));
    if (v == null || _registroId == null) return;
    await DbHelper.actualizarAjusteFinal(_registroId!, v);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ajuste final guardado'), backgroundColor: Colors.green),
      );
    }
  }

  void _exportar() {
    final r = widget.resultado;
    final buf = StringBuffer();
    buf.writeln('=== SINUSOIDE — Montaje de Rodamiento ===');
    buf.writeln('Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}');
    buf.writeln('');
    buf.writeln('EQUIPO:      ${widget.equipo}');
    if (widget.tag.isNotEmpty)     buf.writeln('TAG:         ${widget.tag}');
    if (widget.eje.isNotEmpty)     buf.writeln('EJE:         ${widget.eje}');
    if (widget.cajaPort.isNotEmpty) buf.writeln('CAJA PORT:   ${widget.cajaPort}');
    if (widget.sellos.isNotEmpty)  buf.writeln('SELLOS:      ${widget.sellos}');
    if (widget.manguito.isNotEmpty) buf.writeln('MANGUITO:    ${widget.manguito}');
    if (widget.tipo.isNotEmpty)    buf.writeln('TIPO:        ${widget.tipo}');
    buf.writeln('RODAMIENTO:  ${widget.rodamiento}  (clase ${widget.clase} — ${widget.ubicacion})');
    buf.writeln('');
    buf.writeln('--- RESULTADOS ---');
    buf.writeln('Diámetro de eje:        ${r.diametro} mm');
    buf.writeln('Galgeo antes montaje:   ${_fmt(widget.galgeo)} mm');
    buf.writeln('');
    buf.writeln('Referencia sin montar:  MIN ${_fmt(r.refSinMontarMin)} / MAX ${_fmt(r.refSinMontarMax)} mm');
    buf.writeln('Reducción de juego:     MIN ${_fmt(r.reduccionMin)} / MAX ${_fmt(r.reduccionMax)} mm');
    buf.writeln('Juego residual:         MIN ${_fmt(r.juegoMin)} / MAX ${_fmt(r.juegoMax)} mm');
    if (_ajusteCtrl.text.isNotEmpty) {
      buf.writeln('Ajuste final:           ${_ajusteCtrl.text} mm');
    }
    Share.share(buf.toString(), subject: 'Montaje ${widget.equipo} — Rod. ${widget.rodamiento}');
  }

  Widget _fila(String label, String valor, {Color? color}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 180,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        Expanded(
          child: Text(valor, style: TextStyle(fontSize: 13, color: color)),
        ),
      ],
    ),
  );

  Widget _seccion(String titulo) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 6),
    child: Text(titulo,
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 13)),
  );

  @override
  Widget build(BuildContext context) {
    final r = widget.resultado;
    return Scaffold(
      appBar: AppBar(title: const Text('Resultados')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_guardado)
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 14),
                SizedBox(width: 4),
                Text('Guardado en historial', style: TextStyle(color: Colors.green, fontSize: 12)),
              ],
            ),

          _seccion('DATOS DEL EQUIPO'),
          _fila('Equipo',    widget.equipo),
          if (widget.tag.isNotEmpty)      _fila('TAG',         widget.tag),
          if (widget.eje.isNotEmpty)      _fila('Eje',         widget.eje),
          if (widget.cajaPort.isNotEmpty) _fila('Caja port.',  widget.cajaPort),
          if (widget.sellos.isNotEmpty)   _fila('Sellos',      widget.sellos),
          if (widget.manguito.isNotEmpty) _fila('Manguito',    widget.manguito),
          if (widget.tipo.isNotEmpty)     _fila('Tipo',        widget.tipo),
          _fila('Rodamiento', '${widget.rodamiento}  (${widget.clase} — ${widget.ubicacion})'),
          _fila('Diámetro de eje', '${r.diametro} mm'),

          _seccion('GALGEO ANTES DEL MONTAJE'),
          _fila('Medición', '${_fmt(widget.galgeo)} mm'),

          _seccion('REFERENCIA SIN MONTAR'),
          _fila('MIN', '${_fmt(r.refSinMontarMin)} mm'),
          _fila('MAX', '${_fmt(r.refSinMontarMax)} mm'),

          _seccion('REDUCCIÓN DE JUEGO RADIAL'),
          _fila('MIN', '${_fmt(r.reduccionMin)} mm'),
          _fila('MAX', '${_fmt(r.reduccionMax)} mm'),

          _seccion('JUEGO RESIDUAL CALCULADO'),
          _fila('MIN', '${_fmt(r.juegoMin)} mm',
            color: r.juegoMin < 0 ? Colors.red : null),
          _fila('MAX', '${_fmt(r.juegoMax)} mm',
            color: r.juegoMax < 0 ? Colors.red : null),

          _seccion('AJUSTE FINAL'),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _ajusteCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                  decoration: InputDecoration(
                    labelText: 'Medición post-montaje (mm)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.save, color: Colors.blueGrey),
                onPressed: _guardarAjusteFinal,
                tooltip: 'Guardar ajuste final',
              ),
            ],
          ),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver'),
              ),
              ElevatedButton.icon(
                onPressed: _exportar,
                icon: const Icon(Icons.share),
                label: const Text('Exportar'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
