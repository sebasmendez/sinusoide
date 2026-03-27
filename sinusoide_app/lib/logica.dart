import 'tablas.dart';

class ResultadoMontaje {
  final int diametro;
  final double refSinMontarMin;
  final double refSinMontarMax;
  final double reduccionMin;
  final double reduccionMax;
  final double juegoMin;
  final double juegoMax;

  ResultadoMontaje({
    required this.diametro,
    required this.refSinMontarMin,
    required this.refSinMontarMax,
    required this.reduccionMin,
    required this.reduccionMax,
    required this.juegoMin,
    required this.juegoMax,
  });
}

// Calcula diametro de eje a partir del numero de rodamiento
// Regla: ultimos 2 digitos x 5
int calcularDiametro(int rodamiento) {
  return (rodamiento % 100) * 5;
}

// Retorna null si el diametro o la clase no estan en las tablas
ResultadoMontaje? calcularMontaje({
  required int diametro,
  required String clase,
  required double galgeo,
}) {

  // Lookup Tabla 1
  List<dynamic>? fila1;
  for (final fila in tabla1) {
    if (diametro > (fila[0] as int) && diametro <= (fila[1] as int)) {
      fila1 = fila;
      break;
    }
  }
  if (fila1 == null) return null;

  // Indices de columnas por clase
  final indices = {
    'C2':     [2, 3],
    'NORMAL': [4, 5],
    'C3':     [6, 7],
    'C4':     [8, 9],
    'C5':     [10, 11],
  };
  final idx = indices[clase];
  if (idx == null) return null;

  final rawMin = fila1[idx[0]];
  final rawMax = fila1[idx[1]];
  if (rawMin == null || rawMax == null) return null; // clase no disponible para este diametro

  final double refMin = (rawMin as int) / 1000.0;
  final double refMax = (rawMax as int) / 1000.0;

  // Lookup Tabla 2
  List<double>? fila2;
  for (final fila in tabla2) {
    if (diametro > fila[0] && diametro <= fila[1]) {
      fila2 = fila;
      break;
    }
  }
  if (fila2 == null) return null;

  final double reducMin = fila2[2];
  final double reducMax = fila2[3];

  // Juego residual = galgeo - reduccion
  // juego_min = galgeo - reduccion_max (peor caso: maxima reduccion)
  // juego_max = galgeo - reduccion_min (mejor caso: minima reduccion)
  final double juegoMin = galgeo - reducMax;
  final double juegoMax = galgeo - reducMin;

  return ResultadoMontaje(
    diametro: diametro,
    refSinMontarMin: refMin,
    refSinMontarMax: refMax,
    reduccionMin: reducMin,
    reduccionMax: reducMax,
    juegoMin: juegoMin,
    juegoMax: juegoMax,
  );
}
