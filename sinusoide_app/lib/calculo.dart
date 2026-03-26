// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'db_helper.dart';
import 'logica.dart';

class pantallaResultado extends StatefulWidget {
  final String equipo, tag, eje;
  final String cajaPortLA, torqueLA, cajaPortLR, torqueLR, paralelismo;
  final String sellos, manguito, tipo, clase, estado;
  final int rodamiento;
  final double galgeoAcople, galgeoRodete;
  final ResultadoMontaje resAcople, resRodete;

  const pantallaResultado({
    super.key,
    required this.equipo,
    required this.tag,
    required this.eje,
    required this.cajaPortLA,
    required this.torqueLA,
    required this.cajaPortLR,
    required this.torqueLR,
    required this.paralelismo,
    required this.sellos,
    required this.manguito,
    required this.tipo,
    required this.rodamiento,
    required this.clase,
    required this.estado,
    required this.galgeoAcople,
    required this.galgeoRodete,
    required this.resAcople,
    required this.resRodete,
  });

  @override
  State<pantallaResultado> createState() => _pantallaResultadoState();
}

class _pantallaResultadoState extends State<pantallaResultado> {
  final _ajusteAcopleCtrl = TextEditingController();
  final _ajusteRodeteCtrl = TextEditingController();
  bool _guardado = false;
  int? _registroId;

  String _fmt(double v) => v.toStringAsFixed(3);

  static const _estadoColores = {
    'BUENO':   Colors.green,
    'REGULAR': Colors.yellow,
    'ALERTA':  Colors.orange,
    'PELIGRO': Colors.red,
  };

  @override
  void initState() {
    super.initState();
    _guardar();
  }

  @override
  void dispose() {
    _ajusteAcopleCtrl.dispose();
    _ajusteRodeteCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final ra = widget.resAcople;
    final rr = widget.resRodete;
    final fecha = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    final id = await DbHelper.guardarCalculo({
      'fecha':              fecha,
      'equipo':             widget.equipo,
      'tag':                widget.tag,
      'eje':                widget.eje,
      'caja_port_la':       widget.cajaPortLA,
      'torque_la':          widget.torqueLA,
      'caja_port_lr':       widget.cajaPortLR,
      'torque_lr':          widget.torqueLR,
      'paralelismo':        widget.paralelismo,
      'sellos':             widget.sellos,
      'manguito':           widget.manguito,
      'tipo':               widget.tipo,
      'rodamiento':         widget.rodamiento,
      'clase':              widget.clase,
      'estado':             widget.estado,
      'diametro':           ra.diametro,
      'galgeo_acople':      widget.galgeoAcople,
      'galgeo_rodete':      widget.galgeoRodete,
      'ref_min':            ra.refSinMontarMin,
      'ref_max':            ra.refSinMontarMax,
      'reduc_min':          ra.reduccionMin,
      'reduc_max':          ra.reduccionMax,
      'juego_min_acople':   ra.juegoMin,
      'juego_max_acople':   ra.juegoMax,
      'juego_min_rodete':   rr.juegoMin,
      'juego_max_rodete':   rr.juegoMax,
      'ajuste_acople':      null,
      'ajuste_rodete':      null,
    });
    if (mounted) setState(() { _guardado = true; _registroId = id; });
  }

  Future<void> _guardarAjustes() async {
    if (_registroId == null) return;
    final vA = double.tryParse(_ajusteAcopleCtrl.text.trim().replaceAll(',', '.'));
    final vR = double.tryParse(_ajusteRodeteCtrl.text.trim().replaceAll(',', '.'));
    await DbHelper.actualizarAjustes(_registroId!, vA, vR);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ajustes finales guardados'), backgroundColor: Colors.green),
      );
    }
  }

  void _exportar() {
    final ra = widget.resAcople;
    final rr = widget.resRodete;
    final buf = StringBuffer();
    buf.writeln('=== SINUSOIDE - Montaje de Rodamiento ===');
    buf.writeln('Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}');
    buf.writeln('');
    buf.writeln('EQUIPO:      ${widget.equipo}');
    buf.writeln('ESTADO:      ${widget.estado}');
    if (widget.tag.isNotEmpty)        buf.writeln('TAG:         ${widget.tag}');
    if (widget.eje.isNotEmpty)        buf.writeln('EJE:         ${widget.eje}');
    if (widget.cajaPortLA.isNotEmpty) buf.writeln('CAJA PORT LA: ${widget.cajaPortLA}  TORQUE: ${widget.torqueLA}');
    if (widget.cajaPortLR.isNotEmpty) buf.writeln('CAJA PORT LR: ${widget.cajaPortLR}  TORQUE: ${widget.torqueLR}');
    if (widget.paralelismo.isNotEmpty) buf.writeln('PARALELISMO: ${widget.paralelismo}');
    if (widget.sellos.isNotEmpty)     buf.writeln('SELLOS:      ${widget.sellos}');
    if (widget.manguito.isNotEmpty)   buf.writeln('MANGUITO:    ${widget.manguito}');
    if (widget.tipo.isNotEmpty)       buf.writeln('TIPO:        ${widget.tipo}');
    buf.writeln('RODAMIENTO:  ${widget.rodamiento}  (clase ${widget.clase})');
    buf.writeln('Diametro de eje: ${ra.diametro} mm');
    buf.writeln('');
    buf.writeln('--- RESULTADOS ---');
    buf.writeln('                      LADO ACOPLE        LADO RODETE');
    buf.writeln('Galgeo:               ${_fmt(widget.galgeoAcople)} mm         ${_fmt(widget.galgeoRodete)} mm');
    buf.writeln('Ref. sin montar:      (${_fmt(ra.refSinMontarMin)}); (${_fmt(ra.refSinMontarMax)}) mm');
    buf.writeln('Reduccion juego:      (${_fmt(ra.reduccionMin)}) a (${_fmt(ra.reduccionMax)}) mm');
    buf.writeln('Calculo del juego:    (${_fmt(ra.juegoMin)} - ${_fmt(ra.juegoMax)}) mm   (${_fmt(rr.juegoMin)} - ${_fmt(rr.juegoMax)}) mm');
    if (_ajusteAcopleCtrl.text.isNotEmpty || _ajusteRodeteCtrl.text.isNotEmpty) {
      buf.writeln('Ajuste final:         (${_ajusteAcopleCtrl.text}) mm        (${_ajusteRodeteCtrl.text}) mm');
    }
    Share.share(buf.toString(), subject: 'Montaje ${widget.equipo} - Rod. ${widget.rodamiento}');
  }

  Widget _filaInfo(String label, String valor) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blueGrey)),
        ),
        Expanded(child: Text(valor, style: const TextStyle(fontSize: 12))),
      ],
    ),
  );

  Widget _seccion(String titulo) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 4),
    child: Text(titulo,
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 13)),
  );

  Widget _tablaResultados() {
    final ra = widget.resAcople;
    final rr = widget.resRodete;

    Widget celda(String texto, {bool bold = false, Color? color}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Text(
        texto,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: color,
        ),
      ),
    );

    Widget celdaHeader(String texto) => Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      color: Colors.blueGrey.shade100,
      child: Text(
        texto,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );

    Widget celdaLabel(String texto) => Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      color: Colors.grey.shade200,
      child: Text(
        texto,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );

    return Table(
      border: TableBorder.all(color: Colors.grey.shade400),
      columnWidths: const {
        0: FlexColumnWidth(2.2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
      },
      children: [
        // Header
        TableRow(children: [
          celdaHeader('UBICACION'),
          celdaHeader('SOPORTE\nLADO ACOPLE'),
          celdaHeader('SOPORTE\nLADO RODETE'),
        ]),
        // Galgeo
        TableRow(children: [
          celdaLabel('GALGEO ANTES\nDEL MONTAJE'),
          celda('${_fmt(widget.galgeoAcople)} mm'),
          celda('${_fmt(widget.galgeoRodete)} mm'),
        ]),
        // Referencia sin montar
        TableRow(children: [
          celdaLabel('REFERENCIA\nSIN MONTAR (1)'),
          celda('(${_fmt(ra.refSinMontarMin)}); (${_fmt(ra.refSinMontarMax)}) mm'),
          celda('(${_fmt(rr.refSinMontarMin)}); (${_fmt(rr.refSinMontarMax)}) mm'),
        ]),
        // Reduccion
        TableRow(children: [
          celdaLabel('REDUCCION JUEGO\nRADIAL SKF (2)'),
          celda('(${_fmt(ra.reduccionMin)}) a (${_fmt(ra.reduccionMax)}) mm'),
          celda('(${_fmt(rr.reduccionMin)}) a (${_fmt(rr.reduccionMax)}) mm'),
        ]),
        // Calculo del juego
        TableRow(children: [
          celdaLabel('CALCULO DEL\nJUEGO (3)'),
          celda('(${_fmt(ra.juegoMin)} - ${_fmt(ra.juegoMax)}) mm', bold: true),
          celda('(${_fmt(rr.juegoMin)} - ${_fmt(rr.juegoMax)}) mm', bold: true),
        ]),
        // Ajuste final
        TableRow(children: [
          celdaLabel('AJUSTE FINAL (4)'),
          Padding(
            padding: const EdgeInsets.all(4),
            child: TextFormField(
              controller: _ajusteAcopleCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: 'mm',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                border: InputBorder.none,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: TextFormField(
              controller: _ajusteRodeteCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: 'mm',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                border: InputBorder.none,
              ),
            ),
          ),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ra = widget.resAcople;
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

          // Datos del equipo
          _seccion('DATOS DEL EQUIPO'),
          Row(
            children: [
              Expanded(child: _filaInfo('Equipo', widget.equipo)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _estadoColores[widget.estado] ?? Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(widget.estado, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          if (widget.tag.isNotEmpty)        _filaInfo('TAG', widget.tag),
          if (widget.eje.isNotEmpty)        _filaInfo('Eje', widget.eje),
          if (widget.cajaPortLA.isNotEmpty) _filaInfo('Caja Port LA', '${widget.cajaPortLA}  Torque: ${widget.torqueLA}'),
          if (widget.cajaPortLR.isNotEmpty) _filaInfo('Caja Port LR', '${widget.cajaPortLR}  Torque: ${widget.torqueLR}'),
          if (widget.paralelismo.isNotEmpty) _filaInfo('Paralelismo', widget.paralelismo),
          if (widget.sellos.isNotEmpty)     _filaInfo('Sellos', widget.sellos),
          if (widget.manguito.isNotEmpty)   _filaInfo('Manguito', widget.manguito),
          if (widget.tipo.isNotEmpty)       _filaInfo('Tipo', widget.tipo),
          _filaInfo('Rodamiento', '${widget.rodamiento}  (${widget.clase})'),
          _filaInfo('Diametro de eje', '${ra.diametro} mm'),

          const SizedBox(height: 16),
          _tablaResultados(),

          const SizedBox(height: 8),
          const Text(
            'REFERENCIAS:\n'
            '(1) Referencia del juego para el rodamiento sin montar segun manual SKF.\n'
            '(2) Reduccion del juego radial para montaje de acuerdo a manual SKF.\n'
            '(3) Calculo del juego residual para lograr el ajuste del montaje correcto.\n'
            '(4) Ajuste final de los rodamientos montados.',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver'),
              ),
              ElevatedButton.icon(
                onPressed: _guardarAjustes,
                icon: const Icon(Icons.save),
                label: const Text('Guardar'),
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
