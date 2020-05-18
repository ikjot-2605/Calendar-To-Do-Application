import 'package:todo/model/note.dart';
import 'package:todo/DAO_Repository/note_repository.dart';

import 'dart:async';

class NoteBloc {
  final _noteRepository = NoteRepository();
  final _noteController = StreamController<List<Note>>.broadcast();

  get notes => _noteController.stream;

  NoteBloc() {
    getNotes();
  }

  getNotes() async {
    return await _noteRepository.getAllNotes();
  }

  getAll() {
    _noteRepository.getAll();
  }

  addNote(Note note) async {
    await _noteRepository.insertNote(note);
    getNotes();
  }

  updateNote(int id, Note note) async {
    await _noteRepository.updateNote(id, note);
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
