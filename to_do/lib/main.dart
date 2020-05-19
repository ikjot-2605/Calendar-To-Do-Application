import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/bloc/note_bloc.dart';
import 'pages/list_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/note.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

int firsttime = 0;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  RenderErrorBox.backgroundColor = Colors.transparent;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(NoteAdapter());
  SharedPreferences prefs = await SharedPreferences.getInstance().then((value) {
    bool firstTime = value.getBool('first_time');
    if (firstTime != null && !firstTime) {
      // Not first time
      firsttime = 0;
    } else {
      // First time
      value.setBool('first_time', false);
      firsttime = 1;
    }
    if (firsttime == 0)
      runApp(MyHome());
    else
      runApp(MyApp());
  });
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
        ),
        home: MyApp(),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: selectnotif);
  }

  shownotification() async {
    int length=notesBox.length;
    for(int i=0;i<length;i++){
      if(notesBox.getAt(i).deadlinedate.toString().substring(0,10)==DateTime.now().toString().substring(0,10)){

      }
    }
    var time = Time(08, 0, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'Check Up',
        'You have ${noteBloc.getTasks(DateTime.now().toString())} tasks scheduled for today!',
        time,
        platformChannelSpecifics);
  }

  Future selectnotif(String payload) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
        ),
        title: 'Hive Tutorial',
        home: FutureBuilder(
          future: Hive.openBox('notes'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError)
                return Text(snapshot.error.toString());
              else {
                if (firsttime == 1) {
                  return Scaffold(
                    body: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Image(image: AssetImage('assets/todo.jpeg'),height: 120.0,),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0.0,30.0,0.0,0.0),
                              child: Text(
                                "WELCOME TO YOUR OWN TO-DO APP",
                                style: TextStyle(fontSize: 30.0,color: Colors.teal),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0,48.0,8.0,48.0),
                              child: Text(
                                "Make notes and stay ahead of your schedule!",
                                style: TextStyle(fontSize: 20.0,color: Colors.green),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width-100,
                              child: FlatButton(
                                child: Text('Turn on daily notifications'),
                                color: Colors.black12,
                                onPressed: () {
                                  shownotification();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ListPage()),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(48.0),
                              child: Text(
                                'You will be reminded daily :)',
                                style: TextStyle(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                else {
                  return ListPage();
                }
              }
            }
            // Although opening a Box takes a very short time,
            // we still need to return something before the Future completes.
            else
              return Scaffold(
                body: FlareActor('assets/loading.flr'),
              );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
