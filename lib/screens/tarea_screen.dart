import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
//import '../widgets/card_tarea.dart';
import '../widgets/card_tarea.dart';
import '../widgets/header.dart';
import '../widgets/add_task_sheet.dart';

//nuevas
import 'package:provider/provider.dart';
import 'package:tareas/provider_task/task_provider.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> with SingleTickerProviderStateMixin {
  //final List<Map<String, dynamic>> _tasks = [];

  // Animación para rotar íconos y controlar el AnimatedIcon
  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // diferente duración
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  // void _addTask(String task) {
  //   setState(() {
  //     _tasks.insert(0, {'title': task, 'done': false});
  //   });

  //   // Icono gira cuando se agrega una tarea también
  //   _iconController.forward(from: 0);
  // }

  // void _toggleComplete(int index) {
  //   setState(() {
  //     _tasks[index]['done'] = !_tasks[index]['done'];
  //   });

  //   // Reproduce animación al marcar como completado
  //   _iconController.forward(from: 0);
  // }

  // void _removeTask(int index) {
  //   setState(() {
  //     _tasks.removeAt(index);
  //   });
  // }

  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      //builder: (_) => AddTaskSheet(onSubmit: _addTask),
      builder: (_) => const AddTaskSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    //nueva
     final taskProvider = context.watch<TaskProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            Expanded(
              child: AnimationLimiter(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  //modificada
                  itemCount: taskProvider.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskProvider.tasks[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 30.0,
                        child: FadeInAnimation(
                         //27 mayo- Inicio Se agrega deslizamiento para eliminar tarea
                          child: Dismissible(
                            key: ValueKey(task.title),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) => taskProvider.removeTask(index),
                  //{
                  //             Future.delayed(
                  //               const Duration(milliseconds: 300),
                  //             (){
                  //               if(index < _tasks.length){
                  //                 _removeTask(index);
                  //               }   
                  //           },
                  //         );
                  // },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
        
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                ),
//27 - mayo Fin seccion Se agrega deslizamiento para eliminar tarea
                          child: TaskCard(
                            key: ValueKey(task.title),
                              title: task.title,
                              isDone: task.done,
                            //onToggle: () => _toggleComplete(index),
                            onToggle: () {
                                taskProvider.toggleTask(index);
                                _iconController.forward(from: 0);
                              },
                            //onDelete: () => _removeTask(index),
                            onDelete: () => taskProvider.removeTask(index),
                            iconRotation: _iconController,
                          ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskSheet,
        backgroundColor: Colors.pinkAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: AnimatedIcon(
          // Cambia al ícono de calendario (event_add no cambia visualmente)
          icon: AnimatedIcons.add_event, // cambia visualmente
          progress: _iconController,
        ),
      ),
    );
  }
}
