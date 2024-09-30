class Todo {
  String id;
  String title;
  final bool isCompleted;

  Todo({required this.id, required this.title, this.isCompleted = false});

  @override
  String toString() {
    return 'Todo{id: $id, title: $title, isCompleted: $isCompleted}';
  }
}
