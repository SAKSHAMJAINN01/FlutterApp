import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../models/task.dart';
import '../../repositories/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc({required this.taskRepository}) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<DeleteAllTasks>(_onDeleteAllTasks);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await taskRepository.getTasks();
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      try {
        await taskRepository.addTask(event.task);
        final tasks = await taskRepository.getTasks();
        emit(TaskLoaded(tasks: tasks));
      } catch (e) {
        emit(TaskError(message: e.toString()));
      }
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      try {
        await taskRepository.updateTask(event.task);
        final tasks = await taskRepository.getTasks();
        emit(TaskLoaded(tasks: tasks));
      } catch (e) {
        emit(TaskError(message: e.toString()));
      }
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      try {
        await taskRepository.deleteTask(event.taskId);
        final tasks = await taskRepository.getTasks();
        emit(TaskLoaded(tasks: tasks));
      } catch (e) {
        emit(TaskError(message: e.toString()));
      }
    }
  }

  Future<void> _onDeleteAllTasks(DeleteAllTasks event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      try {
        await taskRepository.deleteAllTasks();
        emit(TaskLoaded(tasks: []));
      } catch (e) {
        emit(TaskError(message: e.toString()));
      }
    }
  }
}