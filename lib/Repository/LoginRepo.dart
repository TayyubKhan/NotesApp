// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notesapp/Model/facebookDataModel.dart';
import 'package:notesapp/Utils/Utils.dart';

import '../Model/LoginModel.dart';

class LoginRepo {
  final _auth = FirebaseAuth.instance;
  Future<LoginModel> googleLogin() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      User currentUser = _auth.currentUser!;
      return LoginModel(
        uid: currentUser.uid,
        displayName: currentUser.displayName!,
        email: currentUser.email!,
        photoUrl: currentUser.photoURL,
        authorised: true,
      );
    } else {
      throw Exception('Login Unsuccessful');
    }
  }

  Future<LoginModel> facebookLogin() async {
    final result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      FacebookAuth auth = FacebookAuth.instance;
      final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(credential);
      await _auth.signInWithCredential(credential);
      User currentUser = _auth.currentUser!;
      final userdata = await auth.getUserData();
      FacebookDataModel data = FacebookDataModel.fromJson(userdata);
      return LoginModel(
          uid: currentUser.uid,
          displayName: currentUser.displayName!,
          email: currentUser.email!,
          photoUrl: data.picture!.data!.url,
          authorised: true);
    } else {
      throw Exception('Login Unsuccessful');
    }
  }

  Future<void> logout() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    auth.signOut();
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().signOut();
    }
    if (user != null &&
        user.providerData
            .any((provider) => provider.providerId == 'facebook.com')) {
      final facebook = FacebookAuth.instance;
      await facebook.logOut();
    }
  }
}
