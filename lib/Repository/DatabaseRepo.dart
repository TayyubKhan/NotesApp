import 'package:notesapp/Model/NotesModel.dart';
import 'package:notesapp/Model/dbModel.dart';

class DatabaseRepo {
  Future<NotesModel> databaseRepo(NotesModel notesModel) async {
    DBHelper db = DBHelper();
    return await db.insert(notesModel);
  }

  Future<List<NotesModel>> databaseUpdateRepo(NotesModel notesModel) async {
    DBHelper db = DBHelper();
    await db.updateNote(notesModel);
    return await databaseGetRepo();
  }

  Future<List<NotesModel>> databaseGetRepo() async {
    DBHelper db = DBHelper();
    return await db.getNotesList();
  }

  Future<List<NotesModel>> deleteNotesRepo(int id) async {
    DBHelper db = DBHelper();
    await db.deleteNoteById(id);
    return await db.getNotesList();
  }
}
