import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../model/note.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'item_view.dart';
import 'package:todo/pages/new_note.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'day_tasks.dart';
import 'package:tuple/tuple.dart';
import 'package:todo/bloc/note_bloc.dart';
TextEditingController myController = new TextEditingController();
int currIndex = 0;
final DismissDirection _dismissDirection = DismissDirection.horizontal;
final NoteBloc noteBloc=NoteBloc();

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  String date = DateTime.now().toString().substring(0, 10);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    List<Note> list = noteBloc.getAll();
    List<Tuple2<Note, int>> list_todisplay = [];
    for (int i = 0; i < list.length; i++) {
      if (date.toString().substring(0, 10) ==
          list[i].deadlinedate.toString().substring(0, 10)) {
        list_todisplay.add(Tuple2<Note, int>(list[i], i));
      }
    }
    Widget today(){
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
                          builder: (context) =>
                              ItemView(currIndex)),
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
                      noteBloc.add(DeleteNote(list_todisplay[index].item2));
                    },
                    direction: _dismissDirection,
                    key: new ObjectKey(list_todisplay[index]),
                    child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.grey[200],
                              width: 0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        color: Colors.white,
                        child: ListTile(
                          leading: InkWell(
                            onTap: () {
                              setState(() {
                                list_todisplay[index]
                                    .item1
                                    .isDone = 1;
                                final NoteBloc noteBloc = NoteBloc();
                                noteBloc.add(UpdateNote(list_todisplay[index].item1,list_todisplay[index].item2));
                              });
                            },
                            child: Container(
                              //decoration: BoxDecoration(),
                              child: Padding(
                                padding:
                                const EdgeInsets.all(15.0),
                                child: list_todisplay[index]
                                    .item1
                                    .isDone ==
                                    1
                                    ? Icon(
                                  Icons.done,
                                  size: 26.0,
                                  color:
                                  Colors.indigoAccent,
                                )
                                    : Icon(
                                  Icons
                                      .check_box_outline_blank,
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
                                decoration: list_todisplay[index]
                                    .item1
                                    .isDone ==
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewNote()),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30.0),
        child: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            '$date',
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'poppins',
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Column(
        children: <Widget>[
          CalendarCarousel<Event>(
            onDayPressed: (DateTime date, List<Event> events) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DayTasks(date)));
            },
            weekendTextStyle: TextStyle(
              color: Colors.red,
            ),
            thisMonthDayBorderColor: Colors.grey,
            customDayBuilder: (
                bool isSelectable,
                int index,
                bool isSelectedDay,
                bool isToday,
                bool isPrevMonthDay,
                TextStyle textStyle,
                bool isNextMonthDay,
                bool isThisMonthDay,
                DateTime day,
                ) {
              for (int i = 0; i < list.length; i++) {
                if (day == list[i].deadlinedate) {
                  return Center(
                    child: Icon(Icons.today),
                  );
                }
              }
            },
            weekFormat: false,
            height: 460.0,
            markedDateShowIcon: true,
            selectedDateTime: DateTime.now(),
            daysHaveCircularBorder: false,

            /// null for not rendering any border, true for circular border, false for rectangular border
          ),
          Text(
            "Today's tasks",
            style: TextStyle(
              color: Colors.blue,
              letterSpacing: 1.5,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: Hive.box('notes').listenable(),
            builder: (context, Box notes, _) {
              return BlocBuilder(
                  bloc: noteBloc,
                  builder: (BuildContext context, NoteState state){
                    if(state is NoteInitial){
                      return today();
                    }
                    if(state is NoteObtained){
                      return today();
                    }
                  }
              );
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