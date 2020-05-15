import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:todo/main.dart';
import 'model/note.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'item_view.dart';
import 'package:todo/bloc.dart';
import 'package:todo/note_dao.dart';
import 'note_repository.dart';
import 'package:todo/new_note.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
TextEditingController myController = new TextEditingController();
int currIndex=0;
final DismissDirection _dismissDirection = DismissDirection.horizontal;
final NoteBloc noteBloc = NoteBloc();
class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  String date = DateTime.now().toString().substring(0, 10);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
          preferredSize: Size.fromHeight(30.0) ,
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
                print(date);
              },
              weekendTextStyle: TextStyle(
                color: Colors.red,
              ),
              thisMonthDayBorderColor: Colors.grey,
//      weekDays: null, /// for pass null when you do not want to render weekDays
//      headerText: Container( /// Example for rendering custom header
//        child: Text('Custom Header'),
//      ),
              customDayBuilder: (   /// you can provide your own build function to make custom day containers
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
                /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
                /// This way you can build custom containers for specific days only, leaving rest as default.

                // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
                if (day.day == 15) {
                  return Center(
                    child: Icon(Icons.local_airport),
                  );
                } else {
                  return null;
                }
              },
              weekFormat: false,
              height: 460.0,
              selectedDateTime: DateTime.now(),
              daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
            ),
            ValueListenableBuilder(
              valueListenable: Hive.box('notes').listenable(),
              builder: (context, Box notes, _) {
                return Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: notes.length,
                    itemBuilder: (BuildContext context, int index) {
                      final note = notes.getAt(index);
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          height: 70.0,
                          child: FlatButton(
                            onPressed: (){
                              setState(() {
                                currIndex=index;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ItemView()),
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
                                /*The magic
                    delete Todo item by ID whenever
                    the card is dismissed
                    */
                                noteBloc.deleteNoteById(index);
                              },
                              direction: _dismissDirection,
                              key: new ObjectKey(notes.getAt(index)),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.grey[200], width: 0.5),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: InkWell(
                                      onTap: () {
                                        //Reverse the value
                                        notes.getAt(index).isDone = 1;
                                        /*
                            Another magic.
                            This will update Todo isDone with either
                            completed or not
                          */
                                        noteBloc.updateNote(currIndex,notes.getAt(currIndex));
                                      },
                                      child: Container(
                                        //decoration: BoxDecoration(),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: notes.getAt(index).isDone==1
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
                                      notes.getAt(index).title,
                                      style: TextStyle(
                                          fontSize: 16.5,
                                          fontFamily: 'RobotoMono',
                                          fontWeight: FontWeight.w500,
                                          decoration: notes.getAt(index).isDone==1
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
              },
            ),
          ],
        ),
        );
  }



  _buildListView() {
    final notesBox = Hive.box('notes');
    print(notesBox.toMap().length);
    return ValueListenableBuilder(
      valueListenable: Hive.box('notes').listenable(),
      builder: (context, Box notes, _) {
        return ListView.builder(
          itemCount: notesBox.length,
          itemBuilder: (BuildContext context, int index) {
            final note = notesBox.getAt(index);
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 70.0,
                child: FlatButton(
                  onPressed: (){
                    setState(() {
                      currIndex=index;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ItemView()),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          notes.getAt(index).title,
                          style: TextStyle(
                            letterSpacing: 0.4,
                            fontSize: 20.0,
                            fontFamily: 'poppins',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
/*
* Dismissible(
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
                    /*The magic
                    delete Todo item by ID whenever
                    the card is dismissed
                    */
                    todoBloc.deleteTodoById(todo.id);
                  },
                  direction: _dismissDirection,
                  key: new ObjectKey(todo),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey[200], width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        leading: InkWell(
                          onTap: () {
                            //Reverse the value
                            todo.isDone = !todo.isDone;
                          /*
                            Another magic.
                            This will update Todo isDone with either
                            completed or not
                          */
                            todoBloc.updateTodo(todo);
                          },
                          child: Container(
                            //decoration: BoxDecoration(),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: todo.isDone
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
                          todo.description,
                          style: TextStyle(
                              fontSize: 16.5,
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.w500,
                              decoration: todo.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        ),
                      )),
                );*/