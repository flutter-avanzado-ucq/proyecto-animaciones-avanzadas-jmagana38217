import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final bool isDone;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final Animation<double> iconRotation;
  final DateTime? vencimiento;

  const TaskCard({
    super.key,
    required this.title,
    required this.isDone,
    required this.onToggle,
    required this.onDelete,
    required this.iconRotation,
    required this.vencimiento,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(title),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDelete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarea eliminada')),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: isDone ? 0.5 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDone ? Colors.yellow.shade300 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: ListTile(
            leading: GestureDetector(
              onTap: onToggle,
              child: AnimatedBuilder(
                animation: iconRotation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: isDone ? iconRotation.value * pi : 0,
                    child: Icon(
                      isDone
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: isDone ? Colors.green : Colors.grey,
                    ),
                  );
                },
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    decoration:
                        isDone ? TextDecoration.lineThrough : null,
                    color: isDone ? Colors.black54 : Colors.black87,
                  ),
                ),
                if (vencimiento != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Vencimiento: ${DateFormat('dd/MM/yyyy').format(vencimiento!)}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onDelete,
            ),
          ),
        ),
      ),
    );
  }
}
