import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoaps_riverpod/src/todo.dart';
import 'package:todoaps_riverpod/src/todo_list_notifier.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TodoApp(),
    );
  }
}

class TodoApp extends ConsumerWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod'),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          final todo = todoList[index];
          Color themeColor =
              todo.isCompleted ? Colors.grey.shade400 : Colors.black;
          return ListTile(
              title: Text(
                todo.title,
                style: TextStyle(
                  color: themeColor,
                  decoration: todo.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              leading: Checkbox(
                value: todo.isCompleted,
                onChanged: (value) {
                  ref.read(todoListProvider.notifier).toggleTodoStatus(todo.id);
                },
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: themeColor,
                    ),
                    onPressed: () {
                      ref
                          .read(todoListProvider.notifier)
                          .removeTodoById(todo.id);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.copy,
                      color: themeColor,
                    ),
                    onPressed: () {
                      ref
                          .read(todoListProvider.notifier)
                          .duplicateTodoById(todo.id);
                    },
                  ),
                ],
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();

    void _addTodo() {
      if (titleController.text.isEmpty)
        return;
      else {
        final newTodo = Todo(
            id: Random().nextInt(1000).toString(), title: titleController.text);
        ref.read(todoListProvider.notifier).addTodo(newTodo);
        Navigator.of(context).pop();
      }
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Todo'),
            content: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Enter Todo Title',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: _addTodo,
                child: const Text('Add'),
              ),
            ],
          );
        });
  }
}
