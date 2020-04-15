import 'dart:io';
import 'dart:collection';
import 'dart:core';
import 'dart:async';
import 'dart:convert';
void main() {
  print('Enter type of user please : ');
  print('      1) Admin');
  print('      2) Student');
  var user_t='';
  var user_type=0;
  while(true){
    user_t = stdin.readLineSync();
    user_type = int.parse(user_t);
    if(user_type==1||user_type==2){break;}
    else{
      print('Please enter valid user type.');
    }
  }
  Map<String, String> credentials_admin = {'ikjot_sd':'helloikjot','bibek_sd':'hellobibek','teacher1':'teacher'};
  Map<String, String> credentials_student = {'ikjot_sd':'helloikjot','bibek_sd':'hellobibek','teacher1':'teacher'}; 
  var open_electives = new List();
  Map<int,String> branch_index={0:'CE',1:'CVE',2:'CSE',3:'ECE',4:'ME',5:'MME',6:'MNE',7:'EEE',8:'IT'};
  
  //CE=Chemical Engg
  //CVECivil
  //MME=Metallurgy
  //MNE=Mining
  if(user_type==1){
    //admin type
    
    while(true){
      print('Enter your username :');
      var user_name = stdin.readLineSync();
      if(credentials_admin.containsKey(user_name)){
        print('Enter your password, $user_name');
        var user_password = stdin.readLineSync();
        if(credentials_admin[user_name]==user_password){
          sleep(new Duration(seconds: 4));
          print('Logged in as $user_name');
          break;
        }
        else{
          sleep(new Duration(seconds: 4));
          print('Incorrect Password. Please enter a correct password.');
        }
      }
      else{
        print('Please enter a valid username.');
      }
    }
    print('Enter course type \n      1.Open elective \n      2.Branch elective');
    var course_t = stdin.readLineSync();
    int course_type=int.parse(course_t);
    if(course_type==1){
      //open elective
      print('Input the course name now');
      var course_name_o = stdin.readLineSync();
      print('Input the course code now');
      var course_code_o = stdin.readLineSync();
      File outputFile=new File('branch_o.txt');
      outputFile.createSync();
      String total_o=course_name_o+' '+course_code_o+'\n\n';
      outputFile.writeAsStringSync(total_o, mode:FileMode.append);
      print('Open elective course added!');
    }
    else if(course_type==2){
      //branch elective
      //ask for year and branch before name and code of course
      print('Enter Branch :');
      var branch_b = stdin.readLineSync();
      File outputFile=new File('branch_e.txt');
      outputFile.createSync();
      print('Enter year :');
      var year_b = stdin.readLineSync();
      print('Input the course name now');
      var course_name_b = stdin.readLineSync();
      print('Input the course code now');
      var course_code_b = stdin.readLineSync();
      String total=branch_b+'_'+year_b+' '+course_name_b+' '+course_code_b+'\n\n';
      outputFile.writeAsStringSync(total, mode:FileMode.append);
    }

  }
  else if(user_type==2){
    while(true){
      print('Enter your username :');
      var user_name = stdin.readLineSync();
      if(credentials_student.containsKey(user_name)){
        print('Enter your password, $user_name');
        var user_password = stdin.readLineSync();
        if(credentials_student[user_name]==user_password){
          sleep(new Duration(seconds: 4));
          print('Logged in as $user_name');
          break;
        }
        else{
          sleep(new Duration(seconds: 4));
          print('Incorrect Password. Please enter a correct password.');

        }
      }
      else{
        print('Please enter a valid username.');
      }
    }
    //student type
    print('Enter your Branch :');
    var branch_s = stdin.readLineSync();
    print('Enter your Year :');
    var year_s = stdin.readLineSync();
    String a='';
    final file = new File('branch_e.txt');
    Stream<List<int>> inputStream = file.openRead();
      inputStream
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(new LineSplitter()) // Convert stream to individual lines.
      .listen((String line) {        // Process results.
        if(line.split(" ")[0]==branch_s+'_'+year_s){
          print('Branch Elective');
          print('$line');
        }
      },
      onDone: () { print(''); },
      onError: (e) { print(e.toString()); });
    
    final file_o = new File('branch_o.txt');
    Stream<List<int>> inputStream_o = file_o.openRead();
      inputStream_o
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(new LineSplitter()) // Convert stream to individual lines.
      .listen((String line) {        // Process results.
        
        print('Open Elective');
        print('$line');
        
      },
      onDone: () { print(''); },
      onError: (e) { print(e.toString()); });  
      
    
    
    
      
    
  }
  
}
