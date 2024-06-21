
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_to_do_list/Components/dialog_box.dart';
import 'package:my_to_do_list/Components/todo_tile.dart';
import 'package:my_to_do_list/data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    //if it is the first opening
    if (_mybox.get("TODOLIST") == null) {
      db.createInialData();
    } else {
      //if the app already exists
      db.loaddata();
    }
    super.initState();
  }

  //reference box
  final _mybox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  //textcontroller
  final _controller = TextEditingController();

  //selected color
  Color selectedColor = Colors.white;

  //checkbox tap
  void checkboxchanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updatedata();
  }

  //save new task
  void savenewtask() {
    setState(() {
      db.toDoList.add([_controller.text, false, selectedColor]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updatedata();
  }

  void createnewtask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onCancel: () => Navigator.of(context).pop(),
          onSave: savenewtask,
          onColorChanged: (color) {
            setState(() {
              selectedColor = color;
            });
          },
        );
      },
    );
  }

  //delete a task
  void deletetask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updatedata();
  }

  //calculate progress
  double calculateProgress() {
    if (db.toDoList.isEmpty) {
      return 0;
    }
    int completedTasks = db.toDoList.where((task) => task[1] == true).length;
    return completedTasks / db.toDoList.length;
  }

  //get progress color
  Color getProgressColor(double progress) {
    if (progress < 0.33) {
      return Colors.red;
    } else if (progress < 0.66) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = calculateProgress();
    int progressPercentage = (progress * 100).toInt();

    return Scaffold(
      backgroundColor: Colors.grey[900],
      floatingActionButton: SizedBox(
        width: 80, // Set your desired width
        height: 80, // Set your desired height
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              30), // half of width/height for a perfect circle
          child: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: createnewtask,
            child: ClipOval(
              child: Icon(Icons.add, size: 50, color: Colors.lightBlue[50]),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[800],
                      color: getProgressColor(progress),
                      minHeight: 20,
                    ),
                    Text(
                      '$progressPercentage%',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.strait().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: db.toDoList.length,
                  itemBuilder: (context, index) {
                    return ToDoTile(
                      taskname: db.toDoList[index][0].toString(),
                      taskcompleted: db.toDoList[index][1],
                      onChanged: (value) => checkboxchanged(value, index),
                      deletefunction: (context) => deletetask(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
