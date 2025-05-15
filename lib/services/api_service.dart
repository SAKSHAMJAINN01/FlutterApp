import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/task.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/todos'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .asMap()
          .entries
          .map((entry) => Task(
                id: entry.key + 1,
                title: entry.value['title'],
                description: 'Mock description ${entry.key + 1}',
                status: entry.value['completed'] ? 'Done' : 'Pending',
                createdDate: DateTime.now(),
                priority: 'Medium',
              ))
          .toList();
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  Future<void> createTask(Task task) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': task.title,
        'completed': task.status == 'Done',
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create task');
    }
  }

  Future<void> updateTask(Task task) async {
    final response = await http.put(
      Uri.parse('$baseUrl/todos/${task.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': task.title,
        'completed': task.status == 'Done',
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/todos/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}