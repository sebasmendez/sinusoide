import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static Database? _db;

  static Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'sinusoide.db');
    return openDatabase(
      path,
      version: 3,
      onCreate: _crear,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS historial');
        await _crear(db, newVersion);
      },
    );
  }

  static Future<void> _crear(Database db, int version) {
    return db.execute('''
      CREATE TABLE historial (
        id               INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha            TEXT NOT NULL,
        equipo           TEXT,
        tag              TEXT,
        eje              TEXT,
        caja_port_la     TEXT,
        torque_la        TEXT,
        caja_port_lr     TEXT,
        torque_lr        TEXT,
        paralelismo      TEXT,
        sellos           TEXT,
        manguito         TEXT,
        tipo             TEXT,
        rodamiento       INTEGER,
        clase            TEXT,
        estado           TEXT,
        diametro         INTEGER,
        galgeo_acople    REAL,
        galgeo_rodete    REAL,
        ref_min          REAL,
        ref_max          REAL,
        reduc_min        REAL,
        reduc_max        REAL,
        juego_min_acople REAL,
        juego_max_acople REAL,
        juego_min_rodete REAL,
        juego_max_rodete REAL,
        ajuste_acople    REAL,
        ajuste_rodete    REAL
      )
    ''');
  }

  static Future<int> guardarCalculo(Map<String, dynamic> datos) async {
    final db = await database;
    final id = await db.insert('historial', datos);

    // Mantener solo los últimos 10 registros
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM historial')
    ) ?? 0;
    if (count > 10) {
      await db.rawDelete(
        'DELETE FROM historial WHERE id = (SELECT MIN(id) FROM historial)'
      );
    }

    return id;
  }

  static Future<void> actualizarAjustes(int id, double? acople, double? rodete) async {
    final db = await database;
    await db.update('historial', {
      'ajuste_acople': acople,
      'ajuste_rodete': rodete,
    }, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> obtenerHistorial() async {
    final db = await database;
    return db.query('historial', orderBy: 'id DESC');
  }

  static Future<void> eliminarCalculo(int id) async {
    final db = await database;
    await db.delete('historial', where: 'id = ?', whereArgs: [id]);
  }
}
