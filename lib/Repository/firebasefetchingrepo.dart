import 'package:notesapp/FirebaseServices/Firebase_Services.dart';

import '../Model/LoginModel.dart';

class FirebaseFetchingRepo {
  Future<LoginModel> firebaseFetching(uid) async {
    return await FireStoreService().getUserData(uid);
  }
}
