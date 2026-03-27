const String appVersion = '1.2.0';
const String appBuild = '2';

final Map<String, dynamic> changelogData = {
  'v1.2.0': {
    'title': 'Mejoras UX para ambiente industrial',
    'date': '2026-03-26',
    'changes': [
      {
        'category': 'UI',
        'text': 'Clase de juego: reemplazado dropdown por SegmentedButton con 5 opciones visibles (C2, NORMAL, C3, C4, C5). Un tap, área táctil grande, estado visual inmediato — optimizado para guantes en campo.'
      },
      {
        'category': 'UI',
        'text': 'Botón Calcular: SizedBox(width: double.infinity, height: 56px) con color naranja destacado. Full width, prominente, fácil de tocar con guantes.'
      },
      {
        'category': 'UI',
        'text': 'Jerarquía visual: campos críticos (rodamiento, clase de juego, galgeos) en Card azul con borde resaltado; datos opcionales en Card gris — deja claro qué parámetros determinan el cálculo.'
      },
      {
        'category': 'UI',
        'text': 'Tamaño de fuentes: aumentadas en tabla de resultados de fontSize: 11 → 13 para mejor legibilidad en campo.'
      },
      {
        'category': 'UI',
        'text': 'Ajuste final: sacado de la tabla → sección independiente Card amarilla con dos campos (Lado Acople / Lado Rodete) en Row.'
      },
      {
        'category': 'UI',
        'text': 'Botones de acción: reordenados por importancia. PDF: ElevatedButton full width 56px verde (acción principal). Guardar: OutlinedButton full width 48px (secundaria). Volver: TextButton (navegación).'
      },
      {
        'category': 'NAV',
        'text': 'Home mejorada: agregado botón "NUEVO CÁLCULO" (56px naranja, full width) que navega directo al formulario. Acceso inmediato sin confusión.'
      },
    ]
  },
  'v1.1.0': {
    'title': 'Tablas de datos SKF + cálculo real + exportación PDF',
    'date': '2026-03-25',
    'changes': [
      {
        'category': 'DATA',
        'text': 'Tablas SKF precargadas: Tabla 1 (DATOS SKF SIN MONTAR) con juego radial interno por rango de diámetro + clase de juego. Tabla 2 (REDUCCIÓN DEL JUEGO) con reducción MIN/MAX.'
      },
      {
        'category': 'CALC',
        'text': 'Lógica de búsqueda automática en tablas SKF. Cálculo del juego residual: juego_min = galgeo - reduccion_max, juego_max = galgeo - reduccion_min.'
      },
      {
        'category': 'PDF',
        'text': 'Exportación profesional en PDF con tabla de dos columnas (Lado Acople / Lado Rodete), datos del equipo, referencias. Exportable vía share nativo.'
      },
      {
        'category': 'DB',
        'text': 'Persistencia v3: esquema SQLite actualizado para soportar dos lados (Acople/Rodete) con juego_min/max y ajuste_final por lado.'
      },
    ]
  },
  'v1.0.1': {
    'title': 'Persistencia + Historial + Exportación',
    'date': '2026-03-25',
    'changes': [
      {
        'category': 'DB',
        'text': 'SQLite (sqflite): historial persistido automáticamente en cada cálculo.'
      },
      {
        'category': 'UI',
        'text': 'Pantalla Historial: listado de cálculos guardados con detalles expandibles, posibilidad de borrar entradas.'
      },
      {
        'category': 'EXPORT',
        'text': 'Share nativo: exportación vía share_plus — WhatsApp, email, SMS, etc.'
      },
    ]
  },
  'v1.0.0': {
    'title': 'Primera versión compilada y funcional',
    'date': '2026-03-25',
    'changes': [
      {
        'category': 'NAV',
        'text': 'Navegación: bottom nav bar con 3 pestañas (Home, Montajes, Historial).'
      },
      {
        'category': 'FORM',
        'text': 'Formulario inicial con 6 campos de texto: Equipo, TAG, Eje, Rodamiento, Clase de juego, Galgeo.'
      },
      {
        'category': 'BUILD',
        'text': 'APK compilado y probado en dispositivo Android físico.'
      },
    ]
  },
};
