import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_app/Models/productModel.dart';

class DataBaseServices {
  final String tableOfProduct = 'product_table';
  final String productId = 'id';
  final String productTitle = 'title';
  final String productDescription = 'description';
  final String productPrice = 'price';
  final String productQuantity = 'quantity';
  final String productImage = 'image';

  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await createDB();
    return _db;
  }

  createDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "ptoducts.db");
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE $tableOfProduct ($productId INTEGER PRIMARY KEY, $productTitle TEXT,$productPrice DOUBLE, $productQuantity INT,$productImage TEXT)',
        );
      },
    );
    return db;
  }

  Future<int> addProduct(ProductModel product) async {
    var dbref = await db;
    var result = await dbref.insert(
      tableOfProduct,
      product.toMap(),
    );
    return result;
  }

  Future<int> updateProduct(ProductModel product) async {
    var dbref = await db;
    var result = await dbref.update(tableOfProduct, product.toMap(),
        where: "$productId = ?", whereArgs: [product.id]);

    return result;
  }

  Future<int> deleteProduct(int id) async {
    var dbref = await db;
    var result = await dbref
        .delete(tableOfProduct, where: "$productId = ?", whereArgs: [id]);
    // print("Delete result is  $result");
    return result;
  }

  Future<List> showProducts() async {
    var dbref = await db;
    var result = await dbref.query(
      tableOfProduct,
      columns: [
        productId,
        productTitle,
        productPrice,
        productQuantity,
        productImage,
      ],
    );
    return result;
  }

  Future<ProductModel> showProductsByID(int id) async {
    var dbref = await db;
    var result = await dbref.query(tableOfProduct,
        columns: [
          productId,
          productTitle,
          productPrice,
          productQuantity,
          productImage,
        ],
        where: "$productId = ?",
        whereArgs: [id]);
    return ProductModel.fromMap(result.first) ?? [];
  }

  Future<int> getCount() async {
    var dbref = await db;
    var result = await dbref.rawQuery("SELECT COUNT(*) FROM $tableOfProduct");
    return Sqflite.firstIntValue(result);
  }

  Future close() async {
    var dbref = await db;
    return dbref.close();
  }
}
