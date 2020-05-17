import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/model/note.dart';
import 'bloc.dart';
import 'package:todo/note_dao.dart';
import 'item_view.dart';
final NoteBloc noteBloc = NoteBloc();
final NoteDao noteDao = NoteDao();
int currIndex=0;
final DismissDirection _dismissDirection = DismissDirection.horizontal;
class DayTasks extends StatefulWidget {
  final DateTime date;
  DayTasks(this.date, {Key key}) : super(key: key);
  @override
  _DayTasksState createState() => _DayTasksState();
}

class _DayTasksState extends State<DayTasks> {
  final notesBox=Hive.box('notes');
  @override
  Widget build(BuildContext context) {
    List<Note> list=noteDao.getAll();
    List<Note> list_todisplay=[];
    final date=widget.date;
    print(list);
    for(int i=0;i<list.length;i++){
      if(date==list[i].deadlinedate){
        list_todisplay.add(list[i]);
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tasks to-do on $date",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: list_todisplay.length==0?Center(
        child: Text(
          "No Tasks for "+date.toString().substring(0,10),
          style: TextStyle(
            color: Colors.greenAccent,
            letterSpacing: 2.0,
          ),
        ),
      ):ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: list_todisplay.length,
      itemBuilder: (BuildContext context, int index) {
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
                key: new ObjectKey(list_todisplay[index]),
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
                          list_todisplay[index].isDone = 1;
                          /*
                            Another magic.
                            This will update Todo isDone with either
                            completed or not
                          */
                          noteBloc.updateNote(currIndex,list_todisplay[currIndex]);
                        },
                        child: Container(
                          //decoration: BoxDecoration(),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: list_todisplay[index].isDone==1
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
                        list_todisplay[index].title,
                        style: TextStyle(
                            fontSize: 16.5,
                            fontFamily: 'RobotoMono',
                            fontWeight: FontWeight.w500,
                            decoration: list_todisplay[index].isDone==1
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
}
