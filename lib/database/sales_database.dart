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
            idCategory INTEGER PRIMARY KEY AUTOINCREMENT,
            nameCategory VARCHAR(50)
          );''';
        db.execute(query1);

        String query2 = '''CREATE TABLE sales(
            idSale INTEGER PRIMARY KEY AUTOINCREMENT,
            title VARCHAR(100),
            description TEXT,
            date CHAR(10),
            status VARCHAR(10),  -- 'pending', 'completed', 'cancelled'
            categoryId INTEGER,
            CONSTRAINT fk_category FOREIGN KEY(categoryId) REFERENCES categories(idCategory)
          );''';
        db.execute(query2);

        String query3 = '''CREATE TABLE items(
            idItem INTEGER PRIMARY KEY AUTOINCREMENT,
            saleId INTEGER,
            productName VARCHAR(100),
            quantity INTEGER,
            price REAL,
            CONSTRAINT fk_sale FOREIGN KEY(saleId) REFERENCES sales(idSale)
          );''';
        db.execute(query3);

        String query4 = '''CREATE TABLE sale_detail(
            idSaleDetail INTEGER PRIMARY KEY AUTOINCREMENT,
            idSale INTEGER,
            idItem INTEGER,
            quantity INTEGER,
            totalPrice REAL),
            CONSTRAINT fk_sale FOREIGN KEY(idSale) REFERENCES sales(idSale),
            CONSTRAINT fk_item FOREIGN KEY(idItem) REFERENCES items(idItem)
            );''';
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

  // Método para obtener todas las ventas
  Future<List<SalesDAO>> SELECT_ALL_SALES() async {
    var con = await database;
    var result = await con.query('sales');
    return result.map((sale) => SalesDAO.fromMap(sale)).toList();
  }

}
