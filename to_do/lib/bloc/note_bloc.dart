import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:todo/model/note.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
part 'note_event.dart';
part 'note_state.dart';
final notesBox=Hive.box('notes');
class NoteBloc extends Bloc<NoteEvent, NoteState> {
  @override
  NoteState get initialState => NoteInitial();

  @override
  Stream<NoteState> mapEventToState(
      NoteEvent event,
      ) async* {
    if(event is MakeNote){
      String title=event.title;
      DateTime deadlinedate=event.deadlinedate;
      Note note=new Note(title,deadlinedate,0);
      notesBox.add(note);
      print('Added note ${note.title}');
      yield NoteCreated(note);
    }
    if(event is DeleteNote){
      int index=event.index;
      Note toDelete=notesBox.getAt(index);
      notesBox.deleteAt(index);
      print('Deleted note ${toDelete.title}');
      yield NoteDeleted(toDelete);
    }
    if(event is UpdateNote){
      int index=event.index;
      Note note=event.note;
      notesBox.putAt(index,note);
      print('Updated note ${note.title}');
      yield NoteCreated(note);
    }
  }
  List<Note> getAll(){
    List<Note> list=[];
    int length=notesBox.length;
    for(int i=0;i<length;i++){
      list.add(notesBox.getAt(i));
    }
    return list;
  }
  int getTasks(String date){
    int count=0;
    int length=notesBox.length;
    for(int i=0;i<length;i++){
      print(notesBox.getAt(i).deadlinedate.toString().substring(0,10));
      if(date.substring(0,10)==notesBox.getAt(i).deadlinedate.toString().substring(0,10)){
        count++;
      }
    }
    return count;
  }
}
