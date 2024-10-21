import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class VentasDatabase {
  static final VentasDatabase _instance = VentasDatabase._internal();
  static Database? _database;

  factory VentasDatabase() {
    return _instance;
  }

  VentasDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'business_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ventas_servicios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descripcion TEXT,
        fecha TEXT NOT NULL,
        estatus TEXT NOT NULL,
        categoria TEXT NOT NULL,
        cantidad INTEGER NOT NULL,
        cliente TEXT NOT NULL,
        fecha_vencimiento TEXT
      )
    ''');
  }
}
