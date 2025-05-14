class RecentAuthor {
  final int authorId;
  final String authorName;
  final String? avatarUrl;
  final String? description;

  RecentAuthor({
    required this.authorId,
    required this.authorName,
    this.avatarUrl,
    this.description,
  });

  factory RecentAuthor.fromJson(Map<String, dynamic> json) {
    return RecentAuthor(
      authorId: json['authorId'] as int,
      authorName: json['authorName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      description: json['description'] as String?,
    );
  }
}