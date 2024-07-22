// ignore_for_file: must_be_immutable

part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();
  @override
  List<Object> get props => [];
}

class FacebookLoginEvent extends NotesEvent {}

class GoogleLoginEvent extends NotesEvent {}

class CheckLoginEvent extends NotesEvent {}

class LogoutEvent extends NotesEvent {}

class AddNotes extends NotesEvent {}

class FetchFirebaseEvent extends NotesEvent {}

class FetchNotesEvent extends NotesEvent {}

class DeleteNotesEvent extends NotesEvent {
  int id;
  DeleteNotesEvent({required this.id});
  @override
  List<Object> get props => [id];
}

class UpdateNotesEvent extends NotesEvent {
  NotesModel notesModel;
  UpdateNotesEvent({required this.notesModel});
  @override
  List<Object> get props => [notesModel];
}

class AddNotesEvent extends NotesEvent {
  NotesModel notesModel;
  AddNotesEvent({required this.notesModel});
  @override
  List<Object> get props => [notesModel];
}

class SendNotesToFirebaseEvent extends NotesEvent {
  NotesModel notesModel;
  SendNotesToFirebaseEvent({required this.notesModel});
  @override
  List<Object> get props => [notesModel];
}
