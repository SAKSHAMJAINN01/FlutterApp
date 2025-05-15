import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Task extends Equatable {
  final int? id;
  final String title;
  final String description;
  final String status;
  final DateTime createdDate;
  final String priority;

  const Task({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdDate,
    required this.priority,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'createdDate': createdDate.toIso8601String(),
      'priority': priority,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      status: map['status'],
      createdDate: DateTime.parse(map['createdDate']),
      priority: map['priority'],
    );
  }

  String get formattedDate => DateFormat('MMM dd, yyyy').format(createdDate);

  // NEW: copyWith method
  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? status,
    DateTime? createdDate,
    String? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdDate: createdDate ?? this.createdDate,
      priority: priority ?? this.priority,
    );
  }

  @override
  List<Object?> get props => [id, title, description, status, createdDate, priority];
}