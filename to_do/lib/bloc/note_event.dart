part of 'note_bloc.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();
}
class GetNote extends NoteEvent {
  final int index;

  const GetNote(this.index);

  @override
  List<Object> get props => [index];
}

class MakeNote extends NoteEvent {
  final String title;
  final DateTime deadlinedate;
  const MakeNote(this.title,this.deadlinedate);

  @override
  List<Object> get props => [title,deadlinedate];
}

class DeleteNote extends NoteEvent {
  final int index;

  const DeleteNote(this.index);

  @override
  List<Object> get props => [index];
}

class UpdateNote extends NoteEvent {
  final Note note;
  final int index;
  const UpdateNote(this.note,this.index);

  @override
  List<Object> get props => [note,index];
}