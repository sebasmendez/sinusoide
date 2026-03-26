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
      version: 2,
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
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha        TEXT NOT NULL,
        equipo       TEXT,
        tag          TEXT,
        eje          TEXT,
        caja_port    TEXT,
        sellos       TEXT,
        manguito     TEXT,
        tipo         TEXT,
        rodamiento   INTEGER,
        clase        TEXT,
        ubicacion    TEXT,
        galgeo       REAL,
        diametro     INTEGER,
        ref_min      REAL,
        ref_max      REAL,
        reduc_min    REAL,
        reduc_max    REAL,
        juego_min    REAL,
        juego_max    REAL,
        ajuste_final REAL
      )
    ''');
  }

  static Future<int> guardarCalculo(Map<String, dynamic> datos) async {
    final db = await database;
    return db.insert('historial', datos);
  }

  static Future<void> actualizarAjusteFinal(int id, double valor) async {
    final db = await database;
    await db.update('historial', {'ajuste_final': valor},
        where: 'id = ?', whereArgs: [id]);
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
