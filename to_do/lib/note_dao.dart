import 'dart:async';
import 'package:todo/model/note.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'list_page.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
class NoteDao {
  final notesBox = Hive.box('notes');

  //Adds new Note records
  EventList<Event> addEvent(EventList _markedDateMap,Note note){
    _markedDateMap.add(
        note.deadlinedate,
        Event(
            date: note.deadlinedate,
            title: note.title
        )
    );
    return _markedDateMap;
  }
  void createNote(Note note){
    notesBox.add(note);
  }

  //Get All Note items
  //Searches if query string was passed
  List<Note> getNotes() {
    int numberofNotes=notesBox.toMap().length;
    List<Note> got;
    for(int i=0;i<numberofNotes;i++){
      Note a=notesBox.getAt(i);
      got.add(a);
    }
    return got;
  }

  //Update Note record
  void updateNote(int id,Note note){
    notesBox.putAt(id, note);
  }

  //Delete Note records
  void deleteNote(int id){
    notesBox.deleteAt(id);
  }
  List<Note> getAll() {
    List<Note> a=[];
    int length=notesBox.length;
    for(int i=0;i<length;i++){
      a.add(notesBox.getAt(i));
    }
    return a;
  }

}