import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseServices {
  final _client = Supabase.instance.client;
  Future<void> addTask(String title, String desc, DateTime dueDate) async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    await Supabase.instance.client.from('tasks').insert({
      'title': title, 
      'description': desc,
      'due_date': dueDate.toIso8601String(),
      'user_id': user.id, // This links the task to the logged-in user
    });

    await _client.from('tasks').insert({
      'title': title,
      'description': desc,
      'due_date': dueDate.toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) throw Exception("user not logged in");

    final response = await _client
        .from('tasks')
        .select()
        .eq('user_id', user.id);
    print("tasks: $response");
    return response;
  }
}
