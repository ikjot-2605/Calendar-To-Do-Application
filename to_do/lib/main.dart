import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
TextEditingController myController=new TextEditingController();
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
  String imp='';
  String date = DateTime.now().toString().substring(0, 10);
  // This widget is the root of your application.
  Future<void> deleteString() async{
    final prefs=await SharedPreferences.getInstance();
    prefs.remove('stringValue');
  }
  Future<String> getStringValuesSF() async {
    final prefs = await SharedPreferences.getInstance();
    final stringValue = await prefs.getString('stringValue');
    return stringValue??'';
  }
  Future<String> removeString(String toRemove) async {
    final prefs = await SharedPreferences.getInstance();
    final currString=await prefs.getString('stringValue');
    String nowString=currString.replaceAll(("~"+toRemove),'');
    prefs.setString('stringValue', nowString);
    setState(() {
      imp=nowString;
    });
  }
  Future<void> _incrementStartup(String todo) async{
    final prefs = await SharedPreferences.getInstance();
    String last=await getStringValuesSF();
    String current=last+"~"+todo;
    await prefs.setString('stringValue', current);
    setState(() {
      imp=current;
    });
  }
  void initState() {
    getStringValuesSF().then((value){
      imp=value;
    });
    super.initState();
    print('Async done');
  }
  @override
  Widget build(BuildContext context) {
    List<String> finalList=imp.split('~');
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
        child: ListView.builder(
          itemCount: finalList.length,
          itemBuilder: (BuildContext context,int index){
            if(finalList[index]==''){return Container(height:0.0,);}
            return Column(
              mainAxisAlignment:MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(19.0),
                  child: Container(
                    height: 50.0,
                    child: Card(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            finalList[index],
                            style: TextStyle(letterSpacing: 1.0),
                          ),
                          SizedBox(width: 60.0,),
                          IconButton(
                            icon: Icon(Icons.check),
                            color: Colors.green,
                            iconSize: 30.0,
                            onPressed: (){
                              String toRemove=finalList[index];
                              removeString(toRemove);
                              bool _visible = true;
                              setState(() {
                                _visible = !_visible;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
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
              controller: myController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          FlatButton(
            child: Text('Add a To-Do'),
            onPressed: () {
              String todo=myController.text;
              _incrementStartup(todo);
              print (todo);
              print (imp);
              Navigator.pop(context);

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
