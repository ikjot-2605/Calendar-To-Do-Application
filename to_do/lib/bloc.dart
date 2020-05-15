import 'package:todo/model/note.dart';
import 'package:todo/note_repository.dart';


import 'dart:async';

class NoteBloc {
  //Get instance of the Repository
  final _noteRepository = NoteRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _noteController = StreamController<List<Note>>.broadcast();

  get notes => _noteController.stream;

  NoteBloc() {
    getNotes();
  }

  getNotes() async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    return await _noteRepository.getAllNotes();

  }

  addNote(Note note) async {
    await _noteRepository.insertNote(note);
    getNotes();
  }

  updateNote(int id,Note note) async {
    await _noteRepository.updateNote(id,note);
    getNotes();
  }

  deleteNoteById(int id) async {
    _noteRepository.deleteNoteById(id);
    getNotes();
  }

  dispose() {
    _noteController.close();
  }
}