class Note {
  final String id;
  final String title;
  final String content;
  final String? location;
  final String? fileUrl;
  final String? userId;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.location,
    this.fileUrl,
    this.userId,
    required this.createdAt,
  });
}