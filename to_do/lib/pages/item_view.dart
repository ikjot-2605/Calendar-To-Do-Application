import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'list_page.dart';
import 'package:todo/bloc/note_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import '../model/note.dart';

bool pressed = false;
TextEditingController myController1 = new TextEditingController();

class ItemView extends StatefulWidget {
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
    int currIndex=widget.index;
    final notesBox = Hive.box('notes');
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
                    color: Colors.blueGrey[200],
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    'Update',
                    style: TextStyle(
                      color: Colors.blueGrey[200],
                    ),
                  ),
                ],
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
                    color: Colors.blueGrey[200],
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.blueGrey[200],
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
  @override
  Widget build(BuildContext context) {
    final notesBox = Hive.box('notes');
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      home: ValueListenableBuilder(
          valueListenable: Hive.box('notes').listenable(),
          builder: (context, Box notes, _) {
            return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: myController1,
                    decoration: new InputDecoration(
                      labelText: notes.getAt(currIndex).title,
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  FlatButton(
                    onPressed: () {
                      DateTime datee=notesBox.getAt(currIndex).deadlinedate;
                      String updatedText = myController1.text;
                      final NoteBloc noteBloc = NoteBloc();
                      noteBloc.add(UpdateNote(Note(updatedText, datee, 0),currIndex));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ListPage()),
                      );
                      myController1.text = '';
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.assignment,
                          color: Colors.blueGrey[200],
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          'Update',
                          style: TextStyle(
                            color: Colors.blueGrey[200],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
