part of 'note_bloc.dart';
abstract class NoteState extends Equatable {
  const NoteState();
}
class NoteInitial extends NoteState{
  @override
  // TODO: implement props
  List<Object> get props => null;

}

class NoteObtained extends NoteState {
  final List<Note> list;
  const NoteObtained(this.list);
  @override
  List<Object> get props => [list];
}

class NoteCreated extends NoteState {
  final Note note;
  const NoteCreated(this.note);
  @override
  List<Object> get props => [note];
}

class NoteDeleted extends NoteState {
  final Note note;
  const NoteDeleted(this.note);
  @override
  List<Object> get props => [note];
}

class NoteUpdated extends NoteState {
  final Note note;
  final int index;
  const NoteUpdated(this.note,this.index);
  @override
  List<Object> get props => [note,index];
}