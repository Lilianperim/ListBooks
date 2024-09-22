import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/book.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._internal();

  final String tblBook = "book";
  final String colId = "id";
  final String colTitle = "title";
  final String colGenre = "genre";
  final String colAuthor = "author";

  static Database? _db;

  DBHelper._internal();

  factory DBHelper() {
    return instance;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "books.db");
    var dbBooks = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbBooks;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tblBook($colId INTEGER PRIMARY KEY, $colTitle TEXT, " +
            "$colGenre TEXT, $colAuthor TEXT)");
  }

  Future<Database> get db async {
    _db ??= await initializeDb();
    return _db!;
  }

  Future<List<Map<String, dynamic>>> getBooks() async {
    Database db = await this.db;
    return await db.rawQuery('SELECT * FROM $tblBook');
  }

  Future<int> insertBook(Book book) async {
    Database db = await this.db;
    return await db.insert(tblBook, book.toMap());
  }

  Future<int> deleteBook(int id) async {
    var dbClient = await db;
    var result = await dbClient.delete("book", where: 'id = ?', whereArgs: [id]);
    return result;
  }
}
