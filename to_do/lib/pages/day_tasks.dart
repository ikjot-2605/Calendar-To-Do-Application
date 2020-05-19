import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/model/note.dart';
import 'item_view.dart';
import 'package:tuple/tuple.dart';
import 'package:todo/bloc/note_bloc.dart';

int currIndex = 0;
//this page displays all tasks of one day
//this feature involves swiping to delete
final DismissDirection _dismissDirection = DismissDirection.horizontal;

class DayTasks extends StatefulWidget {
  final DateTime date;
  DayTasks(this.date, {Key key}) : super(key: key);
  @override
  _DayTasksState createState() => _DayTasksState();
}

class _DayTasksState extends State<DayTasks> {
  final NoteBloc noteBloc = NoteBloc();

  @override
  Widget build(BuildContext context) {
    //getting the tasks of selected day on calendar button click
    DateTime date = widget.date;
    List<Note> list = noteBloc.getAll();
    List<Tuple2<Note, int>> list_todisplay = [];
    for (int i = 0; i < list.length; i++) {
      if (date.toString().substring(0, 10) ==
          list[i].deadlinedate.toString().substring(0, 10)) {
        list_todisplay.add(Tuple2<Note, int>(list[i], i));
      }
    }
    Widget today() {
      List<Note> list = noteBloc.getAll();
      List<Tuple2<Note, int>> list_todisplay = [];
      for (int i = 0; i < list.length; i++) {
        if (date.toString().substring(0, 10) ==
            list[i].deadlinedate.toString().substring(0, 10)) {
          list_todisplay.add(Tuple2<Note, int>(list[i], i));
        }
      }
      return Expanded(
        child: list_todisplay.length == 0
            ? Center(
                child: Text(
                  "No Tasks for " + date.toString().substring(0, 10),
                  style: TextStyle(
                    color: Colors.greenAccent,
                    letterSpacing: 2.0,
                  ),
                ),
              )
            : ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: list_todisplay.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: 70.0,
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            currIndex = list_todisplay[index].item2;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ItemView(currIndex)),
                          );
                        },
                        child: Dismissible(
                          background: Container(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Deleting",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            color: Colors.redAccent,
                          ),
                          onDismissed: (direction) {
                            final NoteBloc noteBloc = NoteBloc();
                            noteBloc
                                .add(DeleteNote(list_todisplay[index].item2));
                          },
                          direction: _dismissDirection,
                          key: new ObjectKey(list_todisplay[index]),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.grey[200], width: 0.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              color: Colors.white,
                              child: ListTile(
                                leading: InkWell(
                                  onTap: () {
                                    setState(() {
                                      list_todisplay[index].item1.isDone = 1;
                                      final NoteBloc noteBloc = NoteBloc();
                                      noteBloc.add(UpdateNote(
                                          list_todisplay[index].item1,
                                          list_todisplay[index].item2));
                                    });
                                  },
                                  child: Container(
                                    //decoration: BoxDecoration(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child:
                                          list_todisplay[index].item1.isDone ==
                                                  1
                                              ? Icon(
                                                  Icons.done,
                                                  size: 26.0,
                                                  color: Colors.indigoAccent,
                                                )
                                              : Icon(
                                                  Icons.check_box_outline_blank,
                                                  size: 26.0,
                                                  color: Colors.tealAccent,
                                                ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  list_todisplay[index].item1.title,
                                  style: TextStyle(
                                      fontSize: 16.5,
                                      fontFamily: 'RobotoMono',
                                      fontWeight: FontWeight.w500,
                                      decoration:
                                          list_todisplay[index].item1.isDone ==
                                                  1
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none),
                                ),
                              )),
                        ),
                      ),
                    ),
                  );
                },
              ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Tasks for ' + date.toString().substring(0, 10),
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          ValueListenableBuilder(
            valueListenable: Hive.box('notes').listenable(),
            builder: (context, Box notes, _) {
              return BlocBuilder(
                  bloc: noteBloc,
                  builder: (BuildContext context, NoteState state) {
                    if (state is NoteInitial) {
                      return today();
                    }
                    if (state is NoteObtained) {
                      return today();
                    }
                  });
            },
          ),
        ],
      ),
    );
  }

  void dispose() {
    super.dispose();
    // Don't forget to call dispose on the Bloc to close the Streams!
    noteBloc.close();
  }
}
