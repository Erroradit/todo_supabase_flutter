import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Task {
  final String title;
  final String description;
  DateTime? dueDate;

  Task({required this.title, required this.description, required this.dueDate});
}

class AddTile extends StatefulWidget {
  final Task task;
  final VoidCallback onDelete;
  const AddTile({super.key, required this.task, required this.onDelete});

  @override
  State<AddTile> createState() => _AddTileState();
}

class _AddTileState extends State<AddTile> {
  @override
  Widget build(BuildContext context) {
    return SlidableAutoCloseBehavior(
      closeWhenOpened: true,
      closeWhenTapped: true,
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              label: 'Delete',
              icon: Icons.delete_outlined,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(20),
              onPressed: (context) => _onDismissed(),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Task:  ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(widget.task.title, style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(widget.task.description, style: TextStyle(fontSize: 15)),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Due date",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.task.dueDate != null
                        ? "${widget.task.dueDate!.day}-${widget.task.dueDate!.month}-${widget.task.dueDate!.year}"
                        : "No date",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onDismissed() {
    widget.onDelete;
  }
}
