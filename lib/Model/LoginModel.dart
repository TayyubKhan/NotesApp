import 'package:equatable/equatable.dart';

class LoginModel extends Equatable {
  final bool authorised;
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl; // Nullable photo URL

  const LoginModel({
    required this.authorised,
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': uid,
      'name': displayName,
      'email': email,
      'photoUrl': photoUrl
    };
  }

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      authorised: json['authorised'] ?? false,
      uid: json['id'] ?? '',
      displayName: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'],
    );
  }

  @override
  List<Object?> get props => [uid, displayName, email, photoUrl, authorised];
}
