import 'package:equatable/equatable.dart';

class NotesModel extends Equatable {
  const NotesModel({
    required this.id,
    this.content = '',
    this.title = '',
    this.isDeleting = 0,
    this.isFavourite = 0,
    this.isPin = 0,
    this.isArchived = 0,
    this.date = '',
  });

  final int id;
  final String title;
  final String content;
  final int isDeleting;
  final int isFavourite;
  final int isPin;
  final int isArchived;
  final String date;

  NotesModel copyWith(
      {int? id,
      String? title,
      String? content,
      int? isDeleting,
      int? isFavourite,
      int? isPin,
      int? isArchived,
      String? date}) {
    return NotesModel(
      id: id ?? this.id,
      isDeleting: isDeleting ?? this.isDeleting,
      isFavourite: isFavourite ?? this.isFavourite,
      content: content ?? this.content,
      title: title ?? this.title,
      isPin: isPin ?? this.isPin,
      isArchived: isArchived ?? this.isArchived,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isDeleting': isDeleting,
      'isFavourite': isFavourite,
      'isPin': isPin,
      'isArchived': isArchived,
      'date': date,
    };
  }

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      isDeleting: map['isDeleting'] ?? 0,
      isFavourite: map['isFavourite'] ?? 0,
      isPin: map['isPin'] ?? 0,
      isArchived: map['isArchived'] ?? 0,
      date: map['date'],
    );
  }

  @override
  List<Object?> get props =>
      [id, content, isDeleting, isFavourite, title, isPin, isArchived, date];
}
