const String appVersion = '1.3.1';
const String appBuild = '1';

final Map<String, dynamic> changelogData = {
  'v1.3.1': {
    'title': 'Rediseño Home como Dashboard hub + Límite historial 10 registros',
    'date': '2026-03-27',
    'changes': [
      {
        'category': 'UI',
        'text': 'Home rediseñada como dashboard hub que reemplaza completamente el BottomNavigationBar redundante. Logo prominente + Título + 3 botones de acción grande.'
      },
      {
        'category': 'NAV',
        'text': 'Eliminado BottomNavigationBar y navegación por tabs. Nuevo layout: botón \"NUEVO CÁLCULO\" (full width 56px naranja) + Row con \"HISTORIAL\" (verde) y \"VUÓMETRO\" (azul) 50% ancho cada uno. Navegación con Navigator.push.'
      },
      {
        'category': 'NAV',
        'text': 'Cada pantalla secundaria tiene AppBar propio con botón \"atrás\" automático. Home es ahora la pantalla raíz (root).'
      },
      {
        'category': 'DB',
        'text': 'Límite de 10 registros en historial: guardarCalculo() ahora mantiene solo los últimos 10 cálculos. El 11º registro automáticamente sobrescribe el más viejo.'
      },
      {
        'category': 'REMOVED',
        'text': 'Completamente removido: BottomNavigationBar, NavBar StatefulWidget, callbacks de navegación por tabs. Redundancia eliminada.'
      },
    ]
  },
  'v1.3.0': {
    'title': 'Medidor de vibraciones con VU meter',
    'date': '2026-03-27',
    'changes': [
      {
        'category': 'FEAT',
        'text': 'Nueva pestaña "Vibración" para medición objetiva de nivel de audio (dBFS) en tiempo real. Captura la señal del sensor de vibraciones conectado al jack de audio (3.5mm), USB o Bluetooth.'
      },
      {
        'category': 'UI',
        'text': 'VU Meter visual con barra horizontal y escala de colores: verde (-60 a -18 dBFS), amarillo (-18 a -6 dBFS), rojo (-6 a 0 dBFS). Valor numérico grande (64px) mostrando dBFS actual.'
      },
      {
        'category': 'UI',
        'text': 'Indicador de pico: máximo detectado desde el inicio de la medición. Estadísticas: mínimo, promedio, máximo desde que se inició.'
      },
      {
        'category': 'PERMS',
        'text': 'Permisos de micrófono: Android (RECORD_AUDIO) + iOS (NSMicrophoneUsageDescription) con solicitud en tiempo de ejecución.'
      },
      {
        'category': 'DEPS',
        'text': 'Packages nuevos: noise_meter ^5.1.0 (captura de niveles dB) + permission_handler ^12.0.0 (gestión de permisos).'
      },
      {
        'category': 'NAV',
        'text': '4ta pestaña en BottomNavigationBar: Home, Montajes, Historial, Vibración (ícono de ecualizador). Navegación extendida con type: fixed.'
      },
    ]
  },
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
