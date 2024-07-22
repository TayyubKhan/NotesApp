import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/Bloc/notes_bloc.dart';
import 'package:notesapp/Model/NotesModel.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class NotesScreen extends StatefulWidget {
  final int id;
  final int index;
  const NotesScreen({super.key, required this.id, required this.index});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  ///[controller] create a QuillEditorController to access the editor methods
  late QuillEditorController controller;
  late QuillEditorController controller2;
  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.align,
    ToolBarStyle.color,
    ToolBarStyle.background,
    ToolBarStyle.listBullet,
    ToolBarStyle.listOrdered,
    ToolBarStyle.clean,
    ToolBarStyle.addTable,
    ToolBarStyle.editTable,
  ];

  final _backgroundColor = Colors.white70;
  final _toolbarIconColor = Colors.black87;
  final _editorTextStyle = const TextStyle(
      fontSize: 30,
      color: Colors.white,
      fontWeight: FontWeight.normal,
      fontFamily: 'Roboto');
  final _hintTextStyle = const TextStyle(
      fontSize: 25, color: Color(0xff9A9A9A), fontWeight: FontWeight.normal);

  bool _hasFocus = false;

  @override
  void initState() {
    controller = QuillEditorController();
    controller.onTextChanged((text) {
      debugPrint('listening to $text');
    });
    super.initState();
    controller2 = QuillEditorController();
    controller2.onTextChanged((text) {
      debugPrint('listening to $text');
    });
    super.initState();
    context.read<NotesBloc>().add(FetchNotesEvent());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff252525),
          title: const Text(
            'Notes',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<NotesBloc, NotesState>(builder: (context, state) {
              return ElevatedButton(
                  onPressed: () {
                    print(state.listNotesModel[widget.index].title);
                  },
                  child: Text('Hello'));
            }),
            BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state) {
                return QuillHtmlEditor(
                  text: state.listNotesModel[widget.index].title,
                  hintText: 'Title',
                  controller: controller,
                  isEnabled: true,
                  ensureVisible: false,
                  minHeight: height * .2,
                  autoFocus: false,
                  textStyle: _editorTextStyle,
                  hintTextStyle: _hintTextStyle,
                  hintTextAlign: TextAlign.start,
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  hintTextPadding: const EdgeInsets.only(left: 20),
                  backgroundColor: const Color(0xff252525),
                  inputAction: InputAction.newline,
                  onEditingComplete: (s) {
                    context.read<NotesBloc>().add(UpdateNotesEvent(
                        notesModel:
                            NotesModel(id: widget.id, title: s.toString())));
                  },
                  loadingBuilder: (context) {
                    return const Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 1,
                      color: Colors.red,
                    ));
                  },
                  onFocusChanged: (focus) async {
                    await controller.getText().then((value) {
                      context.read<NotesBloc>().add(UpdateNotesEvent(
                          notesModel: NotesModel(
                              id: state.listNotesModel[widget.index].id,
                              title: value.toString(),
                              content:
                                  state.listNotesModel[widget.index].content)));
                    });
                    debugPrint(
                        'has focus ${state.listNotesModel[widget.index].title}');
                    setState(() {
                      _hasFocus = focus;
                    });
                  },
                  onTextChanged: (text) {},
                  onEditorCreated: () {
                    debugPrint('Editor has been loaded');
                  },
                  onEditorResized: (height) =>
                      debugPrint('Editor resized $height'),
                  onSelectionChanged: (sel) =>
                      debugPrint('index ${sel.index}, range ${sel.length}'),
                );
              },
            ),
            BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state) {
                return Expanded(
                  child: QuillHtmlEditor(
                    text: state.listNotesModel[widget.index].content,
                    hintText: 'Body',
                    controller: controller2,
                    isEnabled: true,
                    ensureVisible: false,
                    minHeight: height * .4,
                    autoFocus: false,
                    textStyle: _editorTextStyle,
                    hintTextStyle: const TextStyle(
                        fontSize: 18,
                        color: Color(0xff9A9A9A),
                        fontWeight: FontWeight.normal),
                    hintTextAlign: TextAlign.start,
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    hintTextPadding: const EdgeInsets.only(left: 20),
                    backgroundColor: const Color(0xff252525),
                    inputAction: InputAction.newline,
                    onEditingComplete: (s) {
                      context.read<NotesBloc>().add(UpdateNotesEvent(
                          notesModel: NotesModel(
                              id: state.notesModel.id, content: s.toString())));
                    },
                    loadingBuilder: (context) {
                      return const Center(
                          child: CircularProgressIndicator(
                        strokeWidth: 1,
                        color: Colors.red,
                      ));
                    },
                    onFocusChanged: (focus) async {
                      await controller2.getText().then((value) {
                        context.read<NotesBloc>().add(UpdateNotesEvent(
                            notesModel: NotesModel(
                                id: widget.id,
                                content: value.toString(),
                                title:
                                    state.listNotesModel[widget.index].title)));
                      });
                      debugPrint(
                          'has focus ${state.listNotesModel[widget.index].content}');
                    },
                    onTextChanged: (text) =>
                        debugPrint('widget text change $text'),
                    onEditorCreated: () {
                      debugPrint('Editor has been loaded');
                    },
                    onEditorResized: (height) =>
                        debugPrint('Editor resized $height'),
                    onSelectionChanged: (sel) =>
                        debugPrint('index ${sel.index}, range ${sel.length}'),
                  ),
                );
              },
            ),
            ToolBar(
              toolBarConfig: const [
                ToolBarStyle.bold,
                ToolBarStyle.italic,
                ToolBarStyle.listBullet,
                ToolBarStyle.listOrdered,
              ],
              toolBarColor: Colors.transparent,
              padding: const EdgeInsets.all(8),
              iconSize: 25,
              iconColor: Colors.white,
              activeIconColor: Colors.amberAccent,
              controller: _hasFocus ? controller : controller2,
              crossAxisAlignment: WrapCrossAlignment.start,
              direction: Axis.horizontal,
            ),
          ],
        ),
      ),
    );
  }
}
