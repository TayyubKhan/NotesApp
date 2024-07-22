import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

import 'NotesModel.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'Notes.db');
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE Notes (id INTEGER PRIMARY KEY,
        title TEXT,
        content TEXT,
        isDeleting INTEGER,
        isFavourite INTEGER,
        isPin INTEGER,
        isArchived INTEGER,
        date TEXT)''');
  }

  Future<NotesModel> insert(NotesModel notesModel) async {
    var dbClient = await db;
    await dbClient!.insert('Notes', notesModel.toMap());
    return notesModel;
  }

  Future<List<NotesModel>> getNotes() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('Notes');
    return queryResult.map((e) => NotesModel.fromMap(e)).toList();
  }

  Future<NotesModel> updateNote(NotesModel note) async {
    var dbClient = await db;
    await dbClient!.update(
      'Notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );

    // Fetch the updated note from the database
    List<Map<String, Object?>> queryResult = await dbClient.query(
      'Notes',
      where: 'id = ?',
      whereArgs: [note.id],
    );
    // Extract the updated note from the query result and return it
    if (queryResult.isNotEmpty) {
      return NotesModel.fromMap(queryResult.first);
    } else {
      throw Exception('Note with id ${note.id} not found after update');
    }
  }

  Future<List<NotesModel>> getNotesList() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> queryResult =
        await dbClient!.query('Notes');
    return queryResult.map((e) => NotesModel.fromMap(e)).toList();
  }

  Future<void> deleteNoteById(int id) async {
    final dbClient = await db;
    await dbClient!.delete(
      'Notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
