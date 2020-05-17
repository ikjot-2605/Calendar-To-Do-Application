import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'list_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/note.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flare_flutter/flare_actor.dart';

Future<dynamic> a(int b,String c,String d,String e){}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  RenderErrorBox.backgroundColor = Colors.transparent;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(NoteAdapter());
  runApp(MaterialApp(
    theme: ThemeData(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
    ),
    home: MyApp(),

  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Tutorial',
      home: FutureBuilder(
        future: Hive.openBox('notes'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError)
              return Text(snapshot.error.toString());
            else
              return ListPage();
          }
          // Although opening a Box takes a very short time,
          // we still need to return something before the Future completes.
          else
            return Scaffold(
              body: FlareActor('assets/loading.flr'),
            );
        },
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}


