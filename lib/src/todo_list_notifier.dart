import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoaps_riverpod/src/todo.dart';

class TodoListNotifier extends StateNotifier<List<Todo>> {
  TodoListNotifier() : super([]);

  void addTodo(Todo todo) {
    state = [...state, todo];
  }

  void toggleTodoStatus(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            title: todo.title,
            isCompleted: !todo.isCompleted,
          )
        else
          todo,
    ];
  }

  void removeTodoById(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }

  void duplicateTodoById(String id) {
    for (final todo in state) {
      if (todo.id == id) {
        final newTodo = Todo(
          id: Random().nextInt(1000).toString(),
          title: todo.title,
          isCompleted: todo.isCompleted,
        );
        state = [...state, newTodo];
      }
    }
  }
}

final todoListProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>(
    (ref) => TodoListNotifier());
