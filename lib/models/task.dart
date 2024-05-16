class Task {
  final String id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final String userID;
  final DateTime deadline;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.userID,
    required this.deadline,
  });
}
