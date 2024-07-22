import 'package:notesapp/FirebaseServices/Firebase_Services.dart';
import 'package:notesapp/Model/LoginModel.dart';
import 'package:notesapp/Model/NotesModel.dart';

class FirebaseSendingRepo {
  Future<void> sendingLoginData(LoginModel loginModel) async {
    await FireStoreService()
        .addDocument('MetaData', loginModel.uid, loginModel.toMap());
  }

  Future<void> sendingNotes(
      NotesModel notesModel, LoginModel loginModel) async {
    await FireStoreService().sendNotes(
        '123', notesModel.id.toString(), notesModel.toMap());
  }

}
