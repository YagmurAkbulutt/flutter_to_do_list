class Task {
  String? id;
  String title;
  String? description;
  bool isDone;
  DateTime? dueDate;
  String category;

  Task({
    this.id,
    required this.title,
    this.description,
    this.isDone = false,
    this.dueDate,
    this.category = "Kişisel",
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
      'dueDate': dueDate?.toIso8601String(),
      'category': category,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'],
      isDone: map['isDone'] ?? false,
      dueDate:
      map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      category: map['category'] ?? "Kişisel",
    );
  }
}
