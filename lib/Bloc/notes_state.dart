part of 'notes_bloc.dart';

enum LogInStatus { failure, succeed }

class NotesState extends Equatable {
  final int length;
  final List<NotesModel> listNotesModel;
  final NotesModel notesModel;
  final List<NotesModel> tempList;
  final LogInStatus logInStatus;
  final LoginModel loginModel;
  const NotesState(
      {this.length = 0,
      this.notesModel = const NotesModel(id: 0),
      this.loginModel = const LoginModel(
          uid: '', displayName: '', email: '', photoUrl: '', authorised: false),
      this.listNotesModel = const [],
      this.logInStatus = LogInStatus.failure,
      this.tempList = const []});
  NotesState copyWith(
      {int? length,
      NotesModel? notesModel,
      LoginModel? loginModel,
      List<NotesModel>? listNotesModel,
      List<NotesModel>? tempList,
      LogInStatus? logInStatus}) {
    return NotesState(
        length: length ?? this.length,
        notesModel: notesModel ?? this.notesModel,
        loginModel: loginModel ?? this.loginModel,
        listNotesModel: listNotesModel ?? this.listNotesModel,
        logInStatus: logInStatus ?? this.logInStatus,
        tempList: tempList ?? this.tempList);
  }

  @override
  List<Object?> get props =>
      [listNotesModel, tempList, logInStatus, loginModel, notesModel];
}
