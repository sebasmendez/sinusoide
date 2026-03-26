import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

String _fmt(dynamic v) {
  if (v == null) return '-';
  if (v is double) return v.toStringAsFixed(3);
  return v.toString();
}

Future<Uint8List> generarPdfMontaje(Map<String, dynamic> datos) async {
  final pdf = pw.Document();

  final headerStyle = pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold);
  final cellStyle = const pw.TextStyle(fontSize: 9);
  final cellBold = pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold);
  final labelStyle = pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold);
  final smallStyle = const pw.TextStyle(fontSize: 8);

  final fecha = datos['fecha'] ?? DateFormat('dd/MM/yyyy').format(DateTime.now());

  final equipo = datos['equipo'] ?? '';
  final tag = datos['tag'] ?? '';
  final eje = datos['eje'] ?? '';
  final cajaPortLA = datos['caja_port_la'] ?? datos['cajaPortLA'] ?? '';
  final torqueLA = datos['torque_la'] ?? datos['torqueLA'] ?? '';
  final cajaPortLR = datos['caja_port_lr'] ?? datos['cajaPortLR'] ?? '';
  final torqueLR = datos['torque_lr'] ?? datos['torqueLR'] ?? '';
  final paralelismo = datos['paralelismo'] ?? '';
  final sellos = datos['sellos'] ?? '';
  final manguito = datos['manguito'] ?? '';
  final tipo = datos['tipo'] ?? '';
  final rodamiento = datos['rodamiento']?.toString() ?? '';
  final clase = datos['clase'] ?? '';
  final diametro = datos['diametro']?.toString() ?? '';

  final galgeoAcople = _fmt(datos['galgeo_acople'] ?? datos['galgeoAcople']);
  final galgeoRodete = _fmt(datos['galgeo_rodete'] ?? datos['galgeoRodete']);
  final refMin = _fmt(datos['ref_min'] ?? datos['refMin']);
  final refMax = _fmt(datos['ref_max'] ?? datos['refMax']);
  final reducMin = _fmt(datos['reduc_min'] ?? datos['reducMin']);
  final reducMax = _fmt(datos['reduc_max'] ?? datos['reducMax']);
  final juegoMinAcople = _fmt(datos['juego_min_acople'] ?? datos['juegoMinAcople']);
  final juegoMaxAcople = _fmt(datos['juego_max_acople'] ?? datos['juegoMaxAcople']);
  final juegoMinRodete = _fmt(datos['juego_min_rodete'] ?? datos['juegoMinRodete']);
  final juegoMaxRodete = _fmt(datos['juego_max_rodete'] ?? datos['juegoMaxRodete']);
  final ajusteAcople = _fmt(datos['ajuste_acople'] ?? datos['ajusteAcople']);
  final ajusteRodete = _fmt(datos['ajuste_rodete'] ?? datos['ajusteRodete']);

  pw.Widget celdaLabel(String texto) => pw.Container(
    padding: const pw.EdgeInsets.all(4),
    color: PdfColor.fromHex('#E0E0E0'),
    alignment: pw.Alignment.centerLeft,
    child: pw.Text(texto, style: labelStyle),
  );

  pw.Widget celda(String texto, {bool bold = false}) => pw.Container(
    padding: const pw.EdgeInsets.all(4),
    alignment: pw.Alignment.center,
    child: pw.Text(texto, style: bold ? cellBold : cellStyle, textAlign: pw.TextAlign.center),
  );

  pw.Widget celdaHeader(String texto) => pw.Container(
    padding: const pw.EdgeInsets.all(5),
    color: PdfColor.fromHex('#90A4AE'),
    alignment: pw.Alignment.center,
    child: pw.Text(texto, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.white), textAlign: pw.TextAlign.center),
  );

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Sinusoide', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#37474F'))),
              pw.Text(fecha, style: const pw.TextStyle(fontSize: 11)),
            ],
          ),
          pw.Text('Confiabilidad para equipos rotantes', style: pw.TextStyle(fontSize: 8, color: PdfColor.fromHex('#78909C'))),
          pw.SizedBox(height: 16),
          pw.Text('MONTAJE DE RODAMIENTOS', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#37474F'))),
          pw.SizedBox(height: 12),

          // Datos del equipo
          pw.TableHelper.fromTextArray(
            border: pw.TableBorder.all(color: PdfColor.fromHex('#BDBDBD')),
            headerCount: 0,
            cellAlignment: pw.Alignment.centerLeft,
            cellStyle: cellStyle,
            cellPadding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            columnWidths: {0: const pw.FixedColumnWidth(140), 1: const pw.FlexColumnWidth()},
            data: [
              ['EQUIPO', equipo],
              if (tag.isNotEmpty) ['TAG', tag],
              ['EJE', eje.isNotEmpty ? eje : 'Diametros informados'],
              if (cajaPortLA.isNotEmpty) ['CAJA PORT LA', '$cajaPortLA    TORQUE: $torqueLA'],
              if (cajaPortLR.isNotEmpty) ['CAJA PORT LR', '$cajaPortLR    TORQUE: $torqueLR'],
              if (paralelismo.isNotEmpty) ['PARALELISMO', paralelismo],
              ['SELLOS', sellos],
              ['MANGUITO', manguito],
              ['TIPO', tipo],
            ],
          ),
          pw.SizedBox(height: 4),

          // Tabla de resultados
          pw.Table(
            border: pw.TableBorder.all(color: PdfColor.fromHex('#BDBDBD')),
            columnWidths: {
              0: const pw.FlexColumnWidth(2.5),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(2),
            },
            children: [
              // Rodamiento
              pw.TableRow(children: [
                celdaLabel('RODAMIENTO'),
                pw.Container(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('$rodamiento ($clase)', style: cellStyle),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('Diametro eje: $diametro mm', style: cellStyle),
                ),
              ]),
              // Header ubicacion
              pw.TableRow(children: [
                celdaHeader('UBICACION DE RODAMIENTO'),
                celdaHeader('SOPORTE LADO ACOPLE'),
                celdaHeader('SOPORTE LADO RODETE'),
              ]),
              // Galgeo
              pw.TableRow(children: [
                celdaLabel('GALGEO ANTES DEL MONTAJE'),
                celda('${galgeoAcople}mm'),
                celda('${galgeoRodete}mm'),
              ]),
              // Referencia
              pw.TableRow(children: [
                celdaLabel('REFERENCIA SIN MONTAR \u2071'),
                celda('(${refMin}mm); (${refMax}mm)'),
                celda('(${refMin}mm); (${refMax}mm)'),
              ]),
              // Reduccion
              pw.TableRow(children: [
                celdaLabel('REDUCCION DE JUEGO RADIAL SKF \u00B2'),
                celda('(${reducMin} mm) a (${reducMax} mm)'),
                celda('(${reducMin} mm) a (${reducMax} mm)'),
              ]),
              // Calculo del juego
              pw.TableRow(children: [
                celdaLabel('CALCULO DEL JUEGO \u00B3'),
                celda('($juegoMinAcople mm - $juegoMaxAcople mm)', bold: true),
                celda('($juegoMinRodete mm - $juegoMaxRodete mm)', bold: true),
              ]),
              // Ajuste final
              pw.TableRow(children: [
                celdaLabel('AJUSTE FINAL \u2074'),
                celda(ajusteAcople != '-' ? '($ajusteAcople mm)' : '-', bold: true),
                celda(ajusteRodete != '-' ? '($ajusteRodete mm)' : '-', bold: true),
              ]),
            ],
          ),

          pw.SizedBox(height: 16),
          pw.Text('REFERENCIAS:', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 4),
          pw.Text('(1) Referencia del juego para el rodamiento sin montar segun manual SKF.', style: smallStyle),
          pw.Text('(2) Reduccion del juego radial para montaje de acuerdo a manual SKF.', style: smallStyle),
          pw.Text('(3) Calculo del juego residual para lograr el ajuste del montaje correcto.', style: smallStyle),
          pw.Text('(4) Ajuste final de los rodamientos montados.', style: smallStyle),
        ],
      ),
    ),
  );

  return pdf.save();
}
