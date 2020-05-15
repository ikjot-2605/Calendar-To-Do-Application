import 'package:flutter/material.dart';
import 'bloc.dart';
import 'model/note.dart';
class NewNote extends StatefulWidget {
  @override
  _NewNoteState createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  final NoteBloc noteBloc = NoteBloc();
  TextEditingController myController = new TextEditingController();
  int dateselected=0;
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
          new IconButton(icon: const Icon(Icons.save),
            onPressed: () {
            print("YOU'VE REACHED");
            print(dateselected);
            print(myController.text+" "+selectedDate.toString());
              if(dateselected==1&&myController.text!=null||myController.text!=''||selectedDate.difference(DateTime.now()).inMicroseconds<0) {
                print("TATTI");
                Note note = new Note(myController.text,selectedDate,0);
                noteBloc.addNote(note);
                Navigator.pop(context);
              }
              else{
                showDialog(context: context,
                builder: (_) =>new AlertDialog(
                  title: new Text('Hellllloo'),
                  content: new Text('You fool you made a mistake'),
                  backgroundColor: Color.fromARGB(220, 117, 218 ,255),
                  shape:
                  RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("OKAY"),
                      textColor: Colors.greenAccent,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    new FlatButton(
                      child: Text("NOT OKAY"),
                      textColor: Colors.redAccent,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
                );
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
              leading: const Icon(Icons.border_color,color: Colors.blueGrey,),
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
          SizedBox(height: 20.0,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: (){
                _selectDate(context);
                setState(() {
                  dateselected=1;
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
