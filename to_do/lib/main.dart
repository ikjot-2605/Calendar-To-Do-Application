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

//firsttime variable determines if the app is being opened for the first time. Shared preferences are used for this.
int firsttime = 0;
void main() async {
  //basic hive initializations
  WidgetsFlutterBinding.ensureInitialized();
  RenderErrorBox.backgroundColor = Colors.transparent;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(NoteAdapter());
  //following code determines if app is being opened for the FirstTime or not.
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
    //It's run only after determining if it's the first time.
    runApp(MyHome());
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
  //initializing notification part
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    //boilerplate for notifications in initstate
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: selectnotif);
  }

  //notification show function
  shownotification() async {
    //time to show daily notifications 8:00 am
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

  //on selecting notification, home page of app is opened
  Future selectnotif(String payload) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    //gesturedetector to prevent keyboard interference issues
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
        title: 'Todo-Hive',
        home: FutureBuilder(
          future: Hive.openBox('notes'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError)
                return Text(snapshot.error.toString());
              else {
                //display welcome page if app opened first time after installation
                //choose to turn on notification here
                if (firsttime == 1) {
                  Color gradientStart =
                      Color(0xffffd89b); //Change start gradient color here
                  Color gradientEnd = Color(0xff19547b);
                  return Scaffold(
                    body: Container(
                      //basic gradient
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [gradientStart, gradientEnd],
                            begin: const FractionalOffset(0.5, 0.0),
                            end: const FractionalOffset(0.0, 0.5),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      child: Center(
                        child: SafeArea(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 20.0, 0.0, 40.0),
                                child: Text(
                                  "Welcome To The Best To-Do App.",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      fontFamily: 'Pacifico'),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 100,
                                child: FlatButton(
                                  child: Text(
                                    'Turn on daily notifications',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  onPressed: () {
                                    shownotification();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ListPage()),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return ListPage();
                }
              }
            }
            // Although opening a Box takes a very short time,
            // we still need to return something before the Future completes.
            else
              return Scaffold(
                  //in case of error
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
