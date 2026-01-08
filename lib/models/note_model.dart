class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String category;
  final bool isImportant;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.isImportant = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Convert Note to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'isImportant': isImportant,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create Note from Map
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      category: map['category'] ?? 'عام',
      isImportant: map['isImportant'] ?? false,
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        map['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  // Create a copy with updated fields
  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    bool? isImportant,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      isImportant: isImportant ?? this.isImportant,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Get formatted date
  String get formattedDate =>
      '${createdAt.day}/${createdAt.month}/${createdAt.year}';

  // Get formatted time
  String get formattedTime =>
      '${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';

  // Get preview of content (first 50 characters)
  String get contentPreview =>
      content.length > 50 ? '${content.substring(0, 50)}...' : content;

  @override
  String toString() {
    return 'Note(id: $id, title: $title, category: $category, important: $isImportant)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Note && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
