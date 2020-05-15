import 'dart:async';
import 'package:todo/model/note.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
class NoteDao {
  final notesBox = Hive.box('notes');

  //Adds new Note records
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

}