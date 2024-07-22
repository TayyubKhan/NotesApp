import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:notesapp/Bloc/notes_bloc.dart';
import 'package:notesapp/Utils/Utils.dart';

signUpScreen(BuildContext context) {
  double width = MediaQuery.sizeOf(context).width;
  double height = MediaQuery.sizeOf(context).height;

  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: height * 0.2,
            width: width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xff3B3B3B),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                row(height, width, 'Continue with ', FontAwesomeIcons.facebook,
                    () async {
                  try {
                    context.read<NotesBloc>().add(FacebookLoginEvent());
                    context.read<NotesBloc>().add(FetchFirebaseEvent());
                  } catch (e) {
                    showErrorSnackbar(context, e.toString());
                  }
                  Navigator.pop(context);
                }),
                Gap(height * 0.01),
                row(height, width, 'Continue with ', FontAwesomeIcons.google,
                    () async {
                  try {
                    context.read<NotesBloc>().add(GoogleLoginEvent());
                    context.read<NotesBloc>().add(FetchFirebaseEvent());
                  } catch (e) {
                    showErrorSnackbar(context, e.toString());
                    Navigator.pop(context);
                  }
                }),
              ],
            ),
          ),
        );
      });
}

Widget row(height, width, String text, IconData icon, onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: height * 0.06,
      width: width * 0.6,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: const TextStyle(color: Colors.white)),
          Gap(width * 0.1),
          Icon(
            icon,
            color: Colors.white,
          )
        ],
      ),
    ),
  );
}
