import 'package:todo/note_dao.dart';
import 'note.dart';
final NoteDao noteDao=NoteDao();
class NotificationData {
  String idField = 'id';
  String notificationIdField = 'notificationId';
  String titleField = 'title';
  int numberofTasks = 0;
  String hourField = 'hour';
  String minuteField = 'minute';
  String id;
  int notificationId;
  String title;
  int numberOfTasks;
  int hour;
  int minute;
  List<Note> list=noteDao.getAll();
  NotificationData(this.title, this.numberofTasks, this.hour, this.minute);


  @override
  NotificationData GetNotification(){
    List<Note> list=noteDao.getAll();
    DateTime today=DateTime.now();
    List<Note> todayList;
    for(int i=0;i<list.length;i++){
      if(list[i].deadlinedate==today){
        todayList.add(list[i]);
      }
    }
    numberOfTasks=todayList.length;
    return(
    NotificationData('You have',numberOfTasks,8,00)
    );
  }
}