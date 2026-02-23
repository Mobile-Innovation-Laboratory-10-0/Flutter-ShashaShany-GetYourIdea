import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    var dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, 'motion_ideas.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE saved_ideas (
          id INTEGER PRIMARY KEY,
          title TEXT,
          body TEXT
        )
      ''');
      },
    );
  }

  // CREATE: Menyimpan data
  Future<void> insertIdea(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(
      'saved_ideas',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // READ: Mengambil data
  Future<List<Map<String, dynamic>>> getSavedIdeas() async {
    final db = await database;
    return await db.query('saved_ideas');
  }

  // UPDATE: Memperbarui data
  Future<void> updateIdea(int id, String newBody) async {
    final db = await database;
    await db.update(
      'saved_ideas',
      {'body': newBody},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE: Menghapus data
  Future<void> deleteIdea(int id) async {
    final db = await database;
    await db.delete('saved_ideas', where: 'id = ?', whereArgs: [id]);
  }
}
