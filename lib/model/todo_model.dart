class TodoModel {
  int? id;
  String title;
  DateTime? scheduledTime;
  bool isDone;

  TodoModel({
    this.id,
    this.isDone = false,
    required this.title,
    this.scheduledTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'scheduledTime': scheduledTime?.toIso8601String(),
    };
  }

  static TodoModel fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      title: map['title'],
      scheduledTime: map['scheduledTime'] != null
          ? DateTime.parse(map['scheduledTime'])
          : null,
    );
  }
}
