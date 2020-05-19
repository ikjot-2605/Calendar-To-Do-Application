import 'package:flutter/material.dart';
import 'package:todo/pages/list_page.dart';
import 'package:todo/bloc/note_bloc.dart';

class NewNote extends StatefulWidget {
  @override
  _NewNoteState createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  bool _visible = false;
  TextEditingController myController = new TextEditingController();
  int dateselected = 0;
  DateTime selectedDate = DateTime.now();
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
          'Make a new note',
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
                noteBloc.add(MakeNote(myController.text, selectedDate));
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
