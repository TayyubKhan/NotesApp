import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/Bloc/notes_bloc.dart';
import 'package:notesapp/Model/dbModel.dart';
import 'package:notesapp/Repository/DatabaseRepo.dart';
import 'package:notesapp/Repository/LoginRepo.dart';
import 'package:notesapp/UI/HomeScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/UI/SplashScreen.dart';
import 'package:sqflite/sqflite.dart';
import 'UI/NotesScreen/NotesScreen.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper().initDatabase();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesBloc(LoginRepo(), DatabaseRepo()),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Theme.of(context).colorScheme.onPrimary,
            selectionColor:
                Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
            selectionHandleColor: Theme.of(context).colorScheme.outline,
          ),
          splashColor:
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.005),
          colorScheme: const ColorScheme.dark(),
          scaffoldBackgroundColor: const Color(0xff252525),
          textTheme: GoogleFonts.latoTextTheme(),
          appBarTheme: AppBarTheme(
            backgroundColor:
                Theme.of(context).colorScheme.onPrimary.withOpacity(0.02),
            centerTitle: true,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color:
                    Theme.of(context).colorScheme.onPrimary.withOpacity(0.05),
              ),
            ),
          ),
          tooltipTheme: const TooltipThemeData(
            decoration: BoxDecoration(color: Colors.white),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Theme.of(context).colorScheme.onPrimary,
            unselectedItemColor:
                Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
