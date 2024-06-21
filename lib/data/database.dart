import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {

  List toDoList = [];

  //reference the box
  final _mybox = Hive.box('mybox');

//run this method only on first launch
  void createInialData (){
    toDoList = [
      ["make a tea",false],
      ["Do exercise", false],
    ];
  }

  //load the data from database
  void loaddata(){
    toDoList =_mybox.get("TODOLIST");
  }

  //update the database
  void updatedata(){
    _mybox.put("TODOLIST", toDoList);
  }

}