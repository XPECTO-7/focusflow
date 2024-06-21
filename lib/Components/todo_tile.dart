import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

class ToDoTile extends StatelessWidget {
  final String taskname;
  final bool taskcompleted;
  Function(bool?)? onChanged;
  Function(BuildContext)? deletefunction;

 ToDoTile({super.key, 
  required this.onChanged, 
  required this.taskname, 
  required this.taskcompleted,
  required this.deletefunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 17,right: 17, top: 17),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deletefunction,
              icon: Icons.delete,
            backgroundColor: Colors.red.shade400,
            borderRadius: BorderRadius.circular(12),
            ),
          ]),
        child: Container(
          decoration: BoxDecoration(
            color:Colors.lightBlue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                //checkbox
                Checkbox(value:
                 taskcompleted,
                 onChanged: onChanged,
                 activeColor: Colors.black,
                ),
        
                //task name
                Text(taskname,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: GoogleFonts.raleway().fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: taskcompleted
                  ? TextDecoration.lineThrough 
                  : TextDecoration.none
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
