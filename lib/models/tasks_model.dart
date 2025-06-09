class Tasks {
  final int? id;
  final String title;
  final String description;
  final bool isDone;
  final DateTime? created;
  final DateTime? updated;


  const Tasks(
      {this.id, required this.title, required this.description, required this.isDone, this.created, this.updated});
}