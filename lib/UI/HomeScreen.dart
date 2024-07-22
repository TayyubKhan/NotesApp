import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:notesapp/Bloc/notes_bloc.dart';
import 'package:notesapp/Model/NotesModel.dart';
import 'package:notesapp/Repository/DatabaseRepo.dart';
import 'package:notesapp/Repository/LoginRepo.dart';
import 'package:notesapp/UI/NotesScreen/NotesScreen.dart';
import 'package:notesapp/UI/SignUp.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Will used to access the Animated list
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  /// This holds the items
  List<int> _items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<NotesBloc>().add(FetchNotesEvent());
    (Connectivity().checkConnectivity()).then((connectivityResult) {
      if (connectivityResult.contains(ConnectivityResult.mobile)) {

      } else if (connectivityResult.contains(ConnectivityResult.wifi)) {}
    });
  }

  /// This holds the item count
  int counter = 0;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff252525),
        title: const Text(
          'Notes',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        actions: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xff3B3B3B),
            ),
            child: IconButton(
                onPressed: () async {
                  context.read<NotesBloc>().add(LogoutEvent());
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                )),
          ),
          const SizedBox(
            width: 10,
          ),
          BlocBuilder<NotesBloc, NotesState>(
            builder: (context, state) {
              return Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xff3B3B3B),
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (state.logInStatus == LogInStatus.failure) {
                        signUpScreen(context);
                      }
                    },
                    icon: state.logInStatus == LogInStatus.failure
                        ? const Icon(
                            Icons.person,
                            color: Colors.white,
                          )
                        : CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                state.loginModel.photoUrl!),
                          ),
                  ));
            },
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          return FloatingActionButton(
            backgroundColor: Colors.black,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 35,
            ),
            onPressed: () async {
              int id = DateTime.now().microsecondsSinceEpoch;
              context
                  .read<NotesBloc>()
                  .add(AddNotesEvent(notesModel: NotesModel(id: id)));
              context.read<NotesBloc>().add(FetchNotesEvent());
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotesScreen(
                            id: id,
                            index: state.listNotesModel.length,
                          )));
            },
          );
        },
      ),
      backgroundColor: const Color(0xff252525),
      body: SafeArea(
        child: BlocBuilder<NotesBloc, NotesState>(
          builder: (context, state) {
            return state.length == 0
                ? Center(
                    child: Text('Please Enter Your First Note',
                        style: Theme.of(context).textTheme.headlineLarge),
                  )
                : ListView.builder(
                    itemCount: state.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotesScreen(
                                        id: state.listNotesModel[index].id,
                                        index: index,
                                      )));
                          print(state.listNotesModel[index].id);
                        },
                        onLongPress: () {
                          context.read<NotesBloc>().add(DeleteNotesEvent(
                              id: state.listNotesModel[index].id));
                          print(state.length);
                        },
                        child: SizedBox(
                          height: 128.0,
                          child: Card(
                            color: Colors
                                .primaries[index % Colors.primaries.length],
                            child: Center(
                              child: Text(
                                  _stripHtmlTags(
                                      state.listNotesModel[index].title),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge),
                            ),
                          ),
                        ),
                      );
                    });
          },
        ),
      ),
    );
  }

  String _stripHtmlTags(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }
}
