import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'list_page.dart';
import 'package:todo/bloc/note_bloc.dart';
import '../model/note.dart';

//this page is used to update tasks
//this variable checks if a task is complete, if yes, then it doesn't show mark as complete button, if not, it shows the mark complete button
bool _visible;
bool pressed = false;
TextEditingController myController1 = new TextEditingController();
//checks if task is done
int done;

class ItemView extends StatefulWidget {
  //used to get the particular index item selected by user
  final int index;
  ItemView(this.index, {Key key}) : super(key: key);
  @override
  _ItemViewState createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  @override
  Widget build(BuildContext context) {
    return ItemList(widget.index);
  }
}

class ItemList extends StatefulWidget {
  final int index;
  ItemList(this.index, {Key key}) : super(key: key);
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    //obtaining index in the box
    int currIndex = widget.index;
    final notesBox = Hive.box('notes');
    done = notesBox.getAt(currIndex).isDone;
    //checking if done
    if (done == 0)
      _visible = true;
    else
      _visible = false;
    return ValueListenableBuilder(
        valueListenable: Hive.box('notes').listenable(),
        builder: (context, Box notes, _) {
          updating_field() {
            return Center(
              child: Container(
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 200.0,
                      child: Card(
                        child: Center(
                          child: Text(
                            notes.getAt(currIndex).title,
                            style: TextStyle(
                              fontSize: 20.0,
                              wordSpacing: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          //buttons
          updateButton() {
            return FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => updateView()),
                );
                setState(() {
                  pressed = true;
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.assignment,
                    color: Colors.blueGrey[900],
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    'Update',
                    style: TextStyle(
                      color: Colors.blueGrey[900],
                    ),
                  ),
                ],
              ),
            );
          }

          markCompleteButton() {
            return Visibility(
              visible: _visible,
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    notesBox.getAt(currIndex).isDone = 1;
                    _visible = !_visible;
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.check,
                      color: Colors.blueGrey[900],
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      'Mark Complete',
                      style: TextStyle(
                        color: Colors.blueGrey[900],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          deleteButton() {
            return FlatButton(
              onPressed: () {
                notes.deleteAt(currIndex);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListPage()),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.clear,
                    color: Colors.blueGrey[900],
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.blueGrey[900],
                    ),
                  ),
                ],
              ),
            );
          }

          return MaterialApp(
            theme: ThemeData(
              brightness: Brightness.light,
              backgroundColor: Colors.white,
            ),
            home: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ListPage()));},
                ),
                backgroundColor: Colors.white,
                title: Text(
                  'Task for ' +
                      notesBox
                          .getAt(currIndex)
                          .deadlinedate
                          .toString()
                          .substring(0, 10),
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  updating_field(),
                  SizedBox(
                    height: 40.0,
                  ),
                  updateButton(),
                  SizedBox(
                    height: 40.0,
                  ),
                  markCompleteButton(),
                  SizedBox(
                    height: 40.0,
                  ),
                  deleteButton(),
                ],
              ),
            ),
          );
        });
  }
}

class updateView extends StatefulWidget {
  @override
  _updateViewState createState() => _updateViewState();
}

class _updateViewState extends State<updateView> {
  //this bool decides if deadline date has been selected, if not then it does not display
  bool _visible = false;
  TextEditingController myController = new TextEditingController();
  int dateselected = 0;
  DateTime selectedDate = DateTime.now();
  //date select function default
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: new Text(
          'Update Note',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              //processing validations
              if (dateselected == 1 &&
                  myController.text != null &&
                  myController.text != '') {
                final NoteBloc noteBloc = NoteBloc();
                noteBloc.add(UpdateNote(
                    Note(myController.text, selectedDate, done), currIndex));
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ListPage()));
              } else {
                showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                          title: new Text('Error'),
                          content: new Text(
                              'Please ensure that you have selected a deadline and also entered some todo-title'),
                          backgroundColor: Color.fromARGB(226, 117, 218, 255),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15)),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text("OKAY"),
                              textColor: Colors.black,
                              onPressed: () {
                                setState(() {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop('dialog');
                                });
                              },
                            ),
                          ],
                        ));
              }
            },
            color: Colors.black,
          ),
        ],
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new ListTile(
              leading: const Icon(
                Icons.border_color,
                color: Colors.blueGrey,
              ),
              title: new TextField(
                controller: myController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: new InputDecoration(
                  hintText: "What do you need to do ....",
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Visibility(
            visible: _visible,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Deadline: " + selectedDate.toString().substring(0, 10),
                style: TextStyle(letterSpacing: 2.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: () {
                _selectDate(context);
                setState(() {
                  dateselected = 1;
                  _visible = true;
                });
              },
              child: Text(
                'Select date',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
