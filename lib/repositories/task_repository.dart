import '../models/task.dart';
import '../services/api_service.dart';
import '../services/databases_service.dart';

class TaskRepository {
  final ApiService apiService;
  final DatabaseService databaseService;

  TaskRepository({
    required this.apiService,
    required this.databaseService,
  });

  Future<List<Task>> getTasks() async {
    try {
      // Try to sync with API first
      final remoteTasks = await apiService.fetchTasks();
      
      // Clear old local data
      await databaseService.deleteAllTasks();
      
      // Save fresh API data locally
      for (final task in remoteTasks) {
        await databaseService.createTask(task);
      }
      
      return remoteTasks;
    } catch (e) {
      // Fallback to local data
      return await databaseService.readAllTasks();
    }
  }

  Future<int> addTask(Task task) async {
    try {
      // Optimistic local update
      final localId = await databaseService.createTask(task);
      // Sync with API
      await apiService.createTask(task.copyWith(id: localId));
      return localId;
    } catch (e) {
      // Keep local data even if API fails
      rethrow;
    }
  }

  Future<int> updateTask(Task task) async {
    try {
      // Optimistic local update
      await databaseService.updateTask(task);
      // Sync with API
      await apiService.updateTask(task);
      return task.id!;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      // Optimistic local delete
      await databaseService.deleteTask(id);
      // Sync with API
      await apiService.deleteTask(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAllTasks() async {
    await databaseService.deleteAllTasks();
  }
}