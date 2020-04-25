import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      brightness: Brightness.dark,
      backgroundColor: Colors.black,
    ),
    home: MyApp(),

  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String date=DateTime.now().toString().substring(0,10);
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

          ),
        ),
        centerTitle: true,
      ),
      body: ListTileTheme(
        contentPadding: EdgeInsets.all(10.0),
        textColor: Colors.grey[300],
        selectedColor: Colors.grey[200],
        child: ListView(
          children: <Widget>[
            Card(
              color: Colors.grey[800],
              child: ListTile(
                title: Center(child: Text('Item')),
              ),
            ),
            Card(
              color: Colors.grey[800],
              child: ListTile(
                title: Center(child: Text('Item')),
              ),
            ),
            Card(
              color: Colors.grey[800],
              child: ListTile(
                title: Center(child: Text('Item')),
              ),
            ),
            Card(
              color: Colors.grey[800],
              child: ListTile(
                title: Center(child: Text('Item')),
              ),
            ),
            Card(
              color: Colors.grey[800],
              child: ListTile(
                title: Center(child: Text('Item')),
              ),
            ),
            Card(
              color: Colors.grey[800],
              child: ListTile(
                title: Center(child: Text('Item')),
              ),
            ),
            Card(
              color: Colors.grey[800],
              child: ListTile(
                title: Center(child: Text('Item')),
              ),
            ),
            Card(
              color: Colors.grey[800],
              child: ListTile(
                title: Center(child: Text('Item')),
              ),
            ),
            Card(
              color: Colors.grey[800],
              child: ListTile(
                title: Center(child: Text('Item')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void testAlert(BuildContext context) {
    var alert = AlertDialog(
      content: Column(
        children: <Widget>[
          Container(
            height: 200.0,
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          FlatButton(
            child: Text('Add a To-Do'),
            onPressed: (){
              setState(() {

              });
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
}
