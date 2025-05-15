import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/task/task_bloc.dart';
import 'repositories/task_repository.dart';
import 'services/api_service.dart';
import 'services/databases_service.dart';
import 'screens/task_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseService = DatabaseService.instance;
  await databaseService.database;

  final apiService = ApiService();
  final taskRepository = TaskRepository(
    apiService: apiService,
    databaseService: databaseService,
  );

  runApp(MyApp(taskRepository: taskRepository));
}

class MyApp extends StatelessWidget {
  final TaskRepository taskRepository;

  const MyApp({super.key, required this.taskRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(taskRepository: taskRepository)
        ..add(LoadTasks()),
      child: MaterialApp(
        title: 'Task Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const TaskListScreen(),
      ),
    );
  }
}