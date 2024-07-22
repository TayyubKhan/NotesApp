import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notesapp/Repository/FirebaseSendingRepo.dart';
import 'package:notesapp/Repository/firebasefetchingrepo.dart';
import '../Model/LoginModel.dart';
import '../Model/NotesModel.dart';
import '../Repository/DatabaseRepo.dart';
import '../Repository/LoginRepo.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  List<NotesModel> listNotesModel = [];
  LoginRepo repo;
  DatabaseRepo dbRepo;
  NotesBloc(this.repo, this.dbRepo) : super(const NotesState()) {
    on<FacebookLoginEvent>(_facebookLogin);
    on<GoogleLoginEvent>(_googleLogin);
    on<LogoutEvent>(_logout);
    on<FetchFirebaseEvent>(_fetchFirebaseData);
    on<AddNotesEvent>(_addNotes);
    on<UpdateNotesEvent>(_updateNotes);
    on<FetchNotesEvent>(_fetchNotes);
    on<DeleteNotesEvent>(_deleteNotes);
    on<SendNotesToFirebaseEvent>(_addNotesFirebase);
  }
  void _facebookLogin(
      FacebookLoginEvent event, Emitter<NotesState> emit) async {
    LoginModel data = await repo.facebookLogin();
    await FirebaseSendingRepo().sendingLoginData(data);
    emit(state.copyWith(logInStatus: LogInStatus.succeed));
  }

  void _fetchFirebaseData(
      FetchFirebaseEvent event, Emitter<NotesState> emit) async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      LoginModel data =
          await FirebaseFetchingRepo().firebaseFetching(auth.currentUser!.uid);
      emit(state.copyWith(loginModel: data, logInStatus: LogInStatus.succeed));
    } else {
      emit(state.copyWith(logInStatus: LogInStatus.failure));
    }
  }

  void _googleLogin(GoogleLoginEvent event, Emitter<NotesState> emit) async {
    LoginModel data = await repo.googleLogin();
    emit(state.copyWith(loginModel: data, logInStatus: LogInStatus.succeed));
  }

  void _logout(LogoutEvent event, Emitter<NotesState> emit) async {
    repo.logout();
    emit(state.copyWith(logInStatus: LogInStatus.failure));
  }

  void _addNotes(AddNotesEvent event, Emitter<NotesState> emit) async {
    NotesModel notesModel = await dbRepo.databaseRepo(event.notesModel);
    emit(state.copyWith(notesModel: notesModel));
  }

  void _addNotesFirebase(
      SendNotesToFirebaseEvent event, Emitter<NotesState> emit) async {
    await FirebaseSendingRepo()
        .sendingNotes(event.notesModel, state.loginModel);
  }

  void _updateNotes(UpdateNotesEvent event, Emitter<NotesState> emit) async {
    listNotesModel = await dbRepo.databaseUpdateRepo(event.notesModel);
    emit(state.copyWith(listNotesModel: List.from(listNotesModel)));
  }

  void _fetchNotes(FetchNotesEvent event, Emitter<NotesState> emit) async {
    listNotesModel = await dbRepo.databaseGetRepo();
    emit(state.copyWith(
        listNotesModel: List.from(listNotesModel),
        length: listNotesModel.length));
  }

  void _deleteNotes(DeleteNotesEvent event, Emitter<NotesState> emit) async {
    listNotesModel = await dbRepo.deleteNotesRepo(event.id);
    emit(state.copyWith(
        listNotesModel: List.from(listNotesModel),
        length: listNotesModel.length));
  }
}
