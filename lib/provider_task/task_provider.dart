import 'package:flutter/material.dart';

class Task {
  String title;
  bool done;

//practica se agrega parametro de fecha
  Task({required this.title, this.done = false});
}

//Es como el set state, cuando se llame desde otro widget se va a actualizar el dise;o
class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  void addTask(String title) {
    _tasks.insert(0, Task(title: title));
    notifyListeners();
  }

  void toggleTask(int index) {
    _tasks[index].done = !_tasks[index].done;
    notifyListeners();
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }
}