import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'note.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  String title;
  @HiveField(1)
  DateTime deadlinedate;
  @HiveField(2)
  int isDone;
  Note(this.title, this.deadlinedate, this.isDone);
}
