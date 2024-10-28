// ignore_for_file: non_constant_identifier_names

import 'dart:io';
//import 'package:flutter_application_2/models/salesdao.dart'; // Deberás crear esta clase SalesDAO.
import 'package:flutter_application_2/models/salesdao.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SalesDatabase {

  static final NAMEDB = 'SALESDB';
  static final VERSIONDB = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return _database = await initDatabase();
  }

  Future<Database> initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String path = join(folder.path, NAMEDB);
    return openDatabase(
      path,
      version: VERSIONDB,
      onCreate: (db, version) {
        String query1 = '''
          CREATE TABLE categories(
            idCategory INTEGER PRIMARY KEY,
            nameCategory VARCHAR(50)
          );''';
        db.execute(query1);

        String query2 = '''CREATE TABLE items(
            idItem INTEGER PRIMARY KEY,
            productName VARCHAR(100),
            price REAL,
            categoryId INTEGER,
            CONSTRAINT fk_category FOREIGN KEY(categoryId) REFERENCES categories(idCategory)
          );''';
        db.execute(query2);

        String query3 = '''CREATE TABLE sales(
            idSale INTEGER PRIMARY KEY,
            title VARCHAR(100),
            description TEXT,
            date CHAR(10),
            idItem INTEGER,
            quantity INTEGER,
            status VARCHAR(10),  -- 'pending', 'completed', 'cancelled'
            CONSTRAINT fk_item FOREIGN KEY(idItem) REFERENCES items(idItem)
          );''';
        db.execute(query3);

        String query4 = '''
          INSERT INTO categories (idCategory, nameCategory)
          VALUES (1,'Electronicos');
        ''';
        db.execute(query4);
      },
    );
  }


  // Método para insertar datos en cualquier tabla
  Future<int> INSERT(String table, Map<String, dynamic> row) async {
    var con = await database;
    return await con.insert(table, row);
  }

  // Método para actualizar datos en cualquier tabla
  Future<int> UPDATE(String table, Map<String, dynamic> row, String idColumn, int id) async {
    var con = await database;
    return await con.update(table, row, where: '$idColumn = ?', whereArgs: [id]);
  }

  // Método para eliminar una venta/servicio
  Future<int> DELETE(String table, String idColumn, int id) async {
    var con = await database;
    return await con.delete(table, where: '$idColumn = ?', whereArgs: [id]);
  }

  // Método para obtener la cantidad de items en la tabla 'items'
  Future<int> getItemCount() async {
    var con = await database;
    var result = await con.rawQuery('SELECT COUNT(*) as count FROM items');
    return result.isNotEmpty ? result.first['count'] as int : 0;
  }

  // Método para obtener todas las ventas
  Future<List<SalesDAO>> SELECT_ALL_SALES() async {
    var con = await database;
    var result = await con.query('sales');
    return result.map((sale) => SalesDAO.fromMap(sale)).toList();
  }

  // Método para obtener los items agrupados por categoría
Future<Map<String, List<Map<String, dynamic>>>> getItemsGroupedByCategory() async {
  var con = await database;
  var result = await con.rawQuery('''
    SELECT items.productName, items.price, categories.nameCategory
    FROM items
    JOIN categories ON items.categoryId = categories.idCategory
    ORDER BY categories.nameCategory;
  ''');

  // Agrupando los resultados en un Map por categoría
  Map<String, List<Map<String, dynamic>>> groupedItems = {};
  for (var item in result) {
    String category = item['nameCategory'] as String;
    if (groupedItems[category] == null) {
      groupedItems[category] = [];
    }
    groupedItems[category]!.add(item);
  }
  return groupedItems;
}


  Future<List<SalesDAO>> getPendingSales() async {
    var con = await database;
    var result = await con.query('sales', where: 'status = ?', whereArgs: ['pending']);
    return result.map((sale) => SalesDAO.fromMap(sale)).toList();
  }

  Future<List<SalesDAO>> getSalesByDate(DateTime date) async {
  final db = await database;
  // Asegura que el mes y día tengan dos dígitos
  final String formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  final List<Map<String, dynamic>> maps = await db.query(
    'sales',
    where: "date = ?",
    whereArgs: [formattedDate],
  );

  return maps.map((map) => SalesDAO.fromMap(map)).toList();
}



}
