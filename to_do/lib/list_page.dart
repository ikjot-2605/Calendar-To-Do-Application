import 'package:flutter/material.dart';
import 'package:todo/main.dart';
import 'model/note.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'item_view.dart';
TextEditingController myController = new TextEditingController();
int currIndex=0;
class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  void addNote(Note note) {
    final notesBox = Hive.box('notes');
    notesBox.add(note);
  }

  String date = DateTime.now().toString().substring(0, 10);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[800],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            testAlert(context);
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Colors.grey[800],
          title: Text(
            '$date',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'poppins',
            ),
          ),
          centerTitle: true,
        ),
        body: _buildListView()
        );
  }

  void testAlert(BuildContext context) {
    var alert = AlertDialog(
      content: Column(
        children: <Widget>[
          Container(
            height: 200.0,
            child: TextFormField(
              controller: myController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: new InputDecoration(
                labelText: 'Add here',
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
          ),
          SizedBox(
            height: 40.0,
          ),
          FlatButton(
            child: Text('Add a To-Do'),
            onPressed: () {
              final newNote = Note(myController.text);
              addNote(newNote);
              Navigator.of(context, rootNavigator: true).pop('testAlert');
            },
          ),
        ],
      ),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  _buildListView() {
    final notesBox = Hive.box('notes');
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
