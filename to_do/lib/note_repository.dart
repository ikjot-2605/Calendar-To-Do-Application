import 'package:todo/note_dao.dart';
import 'package:todo/model/note.dart';

class NoteRepository {
  final todoDao = NoteDao();

  List<Note> getAllNotes() => todoDao.getNotes();

  void insertNote(Note note) => todoDao.createNote(note);

  void updateNote(int id,Note note) => todoDao.updateNote(id,note);

  void deleteNoteById(int id) => todoDao.deleteNote(id);
}