import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:to_do_supabase/pages/login_page.dart';
import 'package:to_do_supabase/services/supabase_services.dart';
import 'package:to_do_supabase/widgets/add_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Task> _task = [];
  @override
  void initState() {
    super.initState();
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
        );
      });
    } else {
      _loadTasks();
    }
  }

  void _addtask(Task task) {
    setState(() {
      _task.add(task);
    });
  }

  void _loadTasks() async {
    final tasks = await SupabaseServices().fetchTasks();

    setState(() {
      _task.clear();
      for (final t in tasks) {
        _task.add(
          Task(
            title: t['title'],
            description: t['description'],
            dueDate: DateTime.parse(t['due_date']),
          ),
        );
      }
    });
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: Text("Add Task"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(labelText: "Title"),
                      ),
                      TextField(
                        controller: descController,
                        decoration: InputDecoration(labelText: "Description"),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        icon: Icon(Icons.date_range),
                        label: Text(
                          selectedDate == null
                              ? "Select Due Date"
                              : "${selectedDate?.day}-${selectedDate?.month}-${selectedDate?.year}",
                        ),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (date != null) {
                            setState(() => selectedDate = date);
                          }
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        final title = titleController.text.trim();
                        final desc = descController.text.trim();

                        if (title.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Title is Empty")),
                          );
                          return;
                        }
                        if (desc.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Description is Empty")),
                          );
                          return;
                        }
                        if (selectedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please select the Due Date"),
                            ),
                          );
                          return;
                        }

                        final task = Task(
                          title: title,
                          description: desc,
                          dueDate: selectedDate,
                        );
                        _addtask(task);
                        Navigator.pop(context);
                      },
                      child: Text("Add"),
                    ),
                  ],
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return Center(child: Text("Unauthorized"));

    return Scaffold(
      appBar: AppBar(
        title: Text("To Do List"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.logout_outlined),
            onPressed: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            },
          ),
        ],
      ),

      body: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.red],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Example static task (optional - remove if not needed)
            // AddTile(
            //   task: Task(
            //     title: 'IOT',
            //     description: 'IOT ka project dena h',
            //     dueDate: DateTime.now(),
            //   ),
            //   onDelete: () {},
            // ),
            ..._task
                .map(
                  (task) => AddTile(
                    task: task,
                    onDelete: () {
                      setState(() {
                        _task.removeWhere((t) => t == task);
                      });
                    },
                  ),
                )
                .toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white70,
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add, size: 40, color: Colors.black45),
      ),
    );
  }
}
